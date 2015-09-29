local proto=require'proto'
local wire=require'wire'
local copas=require'copas'
local crypto=require'crypto'

local codecversion = proto.CodecVersion {
   alpha = 2147483637,
   beta = 0,
   prefer_alpha = true}:save()

local manager = {
   session = {}, 			-- mapping session uid to socket (cs)
   user = {},				-- key is socket (cs)
   defpermissions = 0xf07ff,
   serverpassword = "maroc",
   max_bandwidth = 240000,
   welcome_text = "Hello!",
   uid = 1,
   co = nil,
   READY = 1,
   REGISTER = 2,
   REQUEST = 3,
   TERMINATE = 4
}

local cryptsetup = proto.CryptSetup {
   key=crypto.rand.bytes(16),
   client_nonce=crypto.rand.bytes(16),
   server_nonce=crypto.rand.bytes(16) }:save()
local version = proto.Version {
   version = 0x0000010200, release = "alpha", os = "OSv" }:save()
local rootchannelstate = proto.ChannelState {
   channel_id = 0, parent = 0, name = "Rooty", description = "Meetings!" }:save()

local serverconfig = proto.ServerConfig {
   max_bandwidth = manager.max_bandwidth,
   allow_html=true,
   message_length = 128 }:save()

local function handle_version(cs,msg)
   cs:send(wire.make_packet(0,version))
end

local function broadcast(msg_p,ocs)
   for cs,u in pairs(manager.user) do
      if cs ~= ocs then
--	 print("Broadcasting to ", u.name)
	 cs:send(msg_p)
      end
   end
end

local function send_user_states(ncs)
   -- tell everybody about new user
   local nu_p = wire.make_packet(proto.USERSTATE,manager.user[ncs]:save())
   print("EVERYBODY Here is user:", manager.user[ncs].name,
	 "Channel:", manager.user[ncs].channel_id,
	 "Session id:", manager.user[ncs].session)
   broadcast(nu_p,ncs)

   -- tell new user about everybody
   for cs,userstate in pairs(manager.user) do
      print(manager.user[ncs].name, "Here is ",userstate.name,
	    userstate.session)
      ncs:send(wire.make_packet(proto.USERSTATE, userstate:save()))
   end
end

local function add_user(cs,aname)
   print("Adding user...",manager.uid)
   local sid = manager.uid
   manager.user[cs] = proto.UserState { name = aname,
					channel_id = 0,
					session = sid,
					user_id = sid }
   manager.session[sid] = cs
   manager.uid = manager.uid + 1
   return sid
end

local function terminate_user(cs)
   manager.session[manager.user[cs].session] = nil
   manager.user[cs] = nil
--   cs:close()
end

local function remove_user(cs)
   local ur =proto.UserRemove { session = manager.user[cs].session,
				 actor = 0 }:save()				 
   local rm_p = wire.make_packet(proto.USERREMOVE,ur)
   print("Removing user:", manager.user[cs].name)
   broadcast(rm_p,cs)
   terminate_user(cs)
end


local function handle_userstate(cs,typ,msg)
   local newval = proto.UserState:load(msg)
   for k,v in pairs(newval) do
      if v ~= nil and v ~= "" then
	 manager.user[cs].k = v
      end
   end
   local nu_p = wire.make_packet(proto.USERSTATE,manager.user[cs]:save())
   broadcast(nu_p,0)
end

local function handle_auth(cs,typ,msg)
   local auth = proto.Authenticate:load(msg)
   if auth.password ~= manager.serverpassword then
      local rej = proto.Reject { type = "WrongServerPW" }:save()
      cs:send(wire.make_packet(proto.REJECT, rej))
      cs:close()
      return nil
   end
   print("Authenticating...")
   cs:send(wire.make_packet(proto.CRYPTSETUP,cryptsetup))
   cs:send(wire.make_packet(proto.CHANNELSTATE,rootchannelstate))
   sid = add_user(cs,auth.username)
   send_user_states(cs)
   cs:send(wire.make_packet(proto.SERVERCONFIG,serverconfig))
   local serversync = proto.ServerSync {
      session = sid,
      max_bandwidth = manager.max_bandwidth,
      welcome_text = manager.welcome_text}:save()
   cs:send(wire.make_packet(proto.SERVERSYNC,serversync))
end

local function handle_textmessage(fromcs,typ,msg)
   local txtmsg = proto.TextMessage:load(msg)
   txtmsg.actor = manager.user[fromcs].session
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
      permissions = manager.defpermissions }:save()
   cs:send(wire.make_packet(proto.PERMISSIONQUERY,pq))
end

local bit = require("bit")
local band = bit.band
local function handle_udptunnel(cs,typ,msg)
   local typtarg = msg:sub(1,1)
   if (typtarg == 0x20) then
      print("PING")
      cs:send(wire.make_packet(proto.UDPTUNNEL,msg)) -- ping
   else
      local blob = msg:sub(2,-1)
      -- We are going to assume, for now... a maximum of 127 users (uid < 128)
      local newblob = typtarg..string.char(manager.user[cs].session)..blob
      local nmsg = wire.make_packet(proto.UDPTUNNEL,newblob)
      broadcast(nmsg,cs)
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
   local stat,err = pcall(function() handle_msg[typ](cs,typ,msg) end)
   if not stat then
      print("handle_incoming: type,error->", typ, err)
   end
end

local function handle_register(cs,_,_)
   print("Handling registration")
   manager.user[cs] = {}
end

local function handle_terminate(cs,_,_)
   remove_user(cs)
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

