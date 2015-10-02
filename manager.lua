local proto=require'proto'
local wire=require'wire'
local copas=require'copas'
local crypto=require'crypto'
require'coxpcall'

local config = {
   channel_name = "Confab Meet",
   channel_description = "A meeting about this software.",
   serverpassword = "maroc",
   max_bandwidth = 720000,
   max_users = 127,
   welcome_text = "Hello!",
   defpermissions = 0xf07ff,
}


local version = proto.Version {
   version = 0x0000010200, release = "alpha", os = "OSv" }:save()

local manager = {
   user_cnt = 0,
   user = {},	      -- key is socket (cs) -> {use_udp,ipaddr,port,state}
   session = {},		  -- key is session uid -> socket (cs)
   ip = {},			  -- key is ipaddr -> cs or nil
   uid = 1,			  -- ID counter
   co = nil,			  -- Manager coroutine handle
   READY = 1,
   REGISTER = 2,
   REQUEST = 3,
   TERMINATE = 4

}

local codecversion = proto.CodecVersion {
   alpha = 2147483637,
   beta = 0,
   prefer_alpha = true}:save()

local cryptsetup = proto.CryptSetup {
   key=crypto.rand.bytes(16),
   client_nonce=crypto.rand.bytes(16),
   server_nonce=crypto.rand.bytes(16) }:save()


local rootchannelstate = proto.ChannelState {
   channel_id = 0, parent = 0, name = config.channel_name, description = config.channel_description }:save()

local serverconfig = proto.ServerConfig {
   max_bandwidth = config.max_bandwidth,
   allow_html=true,
   message_length = 128 }:save()

local function handle_version(cs,msg)
   cs:send(wire.make_packet(0,version))
end

local function broadcast(msg_p,ocs)
   for cs,_ in pairs(manager.user) do
      if cs ~= ocs then
	 cs:send(msg_p)
      end
   end
end

local function audio_broadcast(msg_p,ocs)
   for cs,user in pairs(manager.user) do
      if cs ~= ocs then
	 if (user.use_udp) then
	    udp_send(msg_p,user.ipaddr)
	 else
	    cs:send(msg_p)
	 end
      end
   end
end

local function send_user_states(ncs)
   -- tell everybody about new user
   local nu_p = wire.make_packet(proto.USERSTATE,manager.user[ncs].state:save())
   print("EVERYBODY Here is user:", manager.user[ncs].state.name,
	 "Channel:", manager.user[ncs].state.channel_id,
	 "Session id:", manager.user[ncs].state.session)
   broadcast(nu_p,ncs)

   -- tell new user about everybody
   for cs,user in pairs(manager.user) do
      print(manager.user[ncs].state.name, "Here is ",user.state.name,
	    user.state.session)
      ncs:send(wire.make_packet(proto.USERSTATE, user.state:save()))
   end
end

local function add_user(cs,aname)
   print("Adding user...",manager.uid)
   local sid = manager.uid
   local ipaddr = manager.user[cs].ipaddr
   manager.user[cs].state = proto.UserState { name = aname,
					      channel_id = 0,
					      session = sid,
					      user_id = sid }
   manager.session[sid] = cs
   manager.ip[ipaddr]=cs
   manager.user[cs].use_udp=false
   manager.uid = manager.uid + 1
   manager.user_cnt = manager.user_cnt + 1
   return sid
end

local function remove_user(cs)
   local sid = manager.user[cs].state.session
   local ipaddr = manager.user[cs].ipaddr

   -- BUG BUG This is a problem with clients coming from same IP
   manager.ip[ipaddr] = nil	

   manager.session[sid] = nil
   manager.user[cs] = nil
   manager.user_cnt = manager.user_cnt - 1
end

local function terminate_user(cs)
   local ur =proto.UserRemove { session = manager.user[cs].state.session,
				 actor = 0 }:save()				 
   local rm_p = wire.make_packet(proto.USERREMOVE,ur)
   print("Terminate user:", manager.user[cs].state.name)
   broadcast(rm_p,cs)
   remove_user(cs)
end


local function handle_userstate(cs,typ,msg)
   local newval = proto.UserState:load(msg)
   for k,v in pairs(newval) do
      if v ~= nil and v ~= "" then
	 manager.user[cs].state.k = v
      end
   end
   local nu_p = wire.make_packet(proto.USERSTATE,manager.user[cs].state:save())
   broadcast(nu_p,0)
end

local function handle_auth(cs,typ,msg)
   local auth = proto.Authenticate:load(msg)
   local sid = add_user(cs,auth.username)
   if manager.user_cnt == manager.max_user2 then
      local rej = proto.Reject { type = "ServerFull" }:save()
      cs:send(wire.make_packet(proto.REJECT, rej))
      cs:close()
      return nil
   end
   if auth.password ~= config.serverpassword then
      local rej = proto.Reject { type = "WrongServerPW" }:save()
      cs:send(wire.make_packet(proto.REJECT, rej))
      cs:close()
      return nil
   end
   print("Authenticating...")
   cs:send(wire.make_packet(proto.CRYPTSETUP,cryptsetup))
   cs:send(wire.make_packet(proto.CHANNELSTATE,rootchannelstate))
--   local sid = add_user(cs,auth.username)
   send_user_states(cs)
   cs:send(wire.make_packet(proto.SERVERCONFIG,serverconfig))
   local serversync = proto.ServerSync {
      session = sid,
      max_bandwidth = config.max_bandwidth,
      welcome_text = config.welcome_text }:save()
   cs:send(wire.make_packet(proto.SERVERSYNC,serversync))
end

local function handle_textmessage(fromcs,typ,msg)
   local txtmsg = proto.TextMessage:load(msg)
   txtmsg.actor = manager.user[fromcs].state.session
   local txtmsg_p = wire.make_packet(proto.TEXTMESSAGE,txtmsg:save())
   local sessions = txtmsg.session
   if next(sessions) == nil then
      broadcast(txtmsg_p,session)
   else
      for i,session in pairs(sessions) do
	 local cs = manager.session[session]
	 cs:send(txtmsg_p)
      end
   end
end

local function handle_ping(cs,typ,msg)
   cs:send(wire.make_packet(proto.PING,msg)) -- echo ping
end

local function handle_permissionquery(cs,typ,msg)
   local pq = proto.PermissionQuery {
      permissions = config.defpermissions }:save()
   cs:send(wire.make_packet(proto.PERMISSIONQUERY,pq))
end

local bit = require("bit")
local band = bit.band
local function handle_udptunnel(cs,typ,msg)
   manager.user[cs].use_udp = false
   local typtarg = msg:sub(1,1)
   local typtargn = string.byte(typtarg)
   if (typtargn == 0x20) then
      print("PING")
      cs:send(wire.make_packet(proto.UDPTUNNEL,msg)) -- ping
   else
      local blob = msg:sub(2,-1)
      -- We are going to assume, for now... a maximum of 127 users (uid < 128)
      local newblob = typtarg..string.char(manager.user[cs].state.session)..blob
      local nmsg = wire.make_packet(proto.UDPTUNNEL,newblob)
      if (typtargn == 0x80) then
	 broadcast(nmsg,cs)	-- broadcast to all
      end
   end

end

local function handle_undef(cs,typ,msg)
   print("Unhandled:", typ)
end

local handle_msg = {
   [proto.VERSION] = handle_version,
   [proto.UDPTUNNEL] = handle_udptunnel,
   [proto.AUTHENTICATE] = handle_auth,
   [proto.PING] = handle_ping,
   [proto.REJECT] = handle_undef,
   [proto.SERVERSYNC] = handle_undef,
   [proto.CHANNELREMOVE] = handle_undef,
   [proto.CHANNELSTATE] = handle_undef,
   [proto.USERREMOVE] = handle_undef,
   [proto.USERSTATE] = handle_userstate,
   [proto.BANLIST] = handle_undef,
   [proto.TEXTMESSAGE] = handle_textmessage,
   [proto.PERMISSIONDENIED] = handle_undef,
   [proto.ACL] = handle_undef,
   [proto.QUERYUSERS] = handle_undef,
   [proto.CRYPTSETUP] = handle_undef,
   [proto.CONTEXTACTIONMODIFY] = handle_undef,
   [proto.CONTEXTACTION] = handle_undef,
   [proto.USERLIST] = handle_undef,
   [proto.VOICETARGET] = handle_undef,
   [proto.PERMISSIONQUERY] = handle_permissionquery,
   [proto.CODECVERSION] = handle_undef,
   [proto.USERSTATS] = handle_undef,
   [proto.REQUESTBLOB] = handle_undef,
   [proto.SERVERCONFIG] = handle_undef,
   [proto.SUGGESTCONFIG] = handle_undef
}

local function handle_ready(cs,_,_)
end

local function handle_incoming(cs,typ,msg)
   local stat,err = copcall(function() handle_msg[typ](cs,typ,msg) end)
   if not stat then
      print("handle_incoming: type,error->", typ, err)
   end
end

local function handle_register(cs,ip,p)
   print("Handling registration")
   manager.user[cs] = {ipaddr = ip, port = p}
end

local function handle_terminate(cs,_,_)
   terminate_user(cs)
end

local handle_cmd = {
   [manager.READY] = handle_ready,
   [manager.REGISTER] = handle_register,
   [manager.REQUEST] = handle_incoming,
   [manager.TERMINATE] = handle_terminate
}


function manager.notify(cmd,csock,typ,msg)
   coroutine.resume(manager.co,cmd,csock,typ,msg)
end

function manager.loop()
   local resp = ""
   while true do
      local cmd,csock,typ,msg = coroutine.yield(resp)
      handle_cmd[cmd](csock,typ,msg)
   end
end

function manager.start()
   manager.co = coroutine.create(manager.loop)
   manager.notify(READY)
   return manager.co
end

return manager

