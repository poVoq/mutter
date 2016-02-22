#!/usr/local/bin/luajit
package.cpath = "./lib/lua/5.1/?.so;"..package.cpath
package.path = "./share/lua/5.1/?.lua;./share/lua/5.1/?/init.lua;"..
   "./share/lua/5.1/?.lua;./share/lua/5.1/?/init.lua;"..package.path

local wire = require'wire'
local mgr = require'manager'
local copas = require'copas'
local ssl = require'ssl'

local sslparams = {
  mode = "server",
  protocol = "sslv23",
  key = "./certs/serverkey.pem",
  certificate = "./certs/server.pem",
  verify = {"none"},
  options = {"all" },
  ciphers = "HIGH+kEDH:HIGH+kEECDH:HIGH:!PSK:!SRP:!3DES:!aNULL"
}

local function tcp_mumble(host, port, handler)
   return copas.addserver(assert(socket.bind(host, port)),
        function(c)
            return handler(copas.wrap(c), c:getpeername())
        end)
end


local manager = nil

local function ssl_handler(sc, host, port)
    print("Got connection from ", host, port)
    sc = copas.wrap(sc):dohandshake(sslparams)
    print("Registering connection from ", host, port)
    mgr.notify(mgr.REGISTER, sc, host,port)
    print("Registered connection from ", host, port)
    while true do
       local hdr = sc:receive(6)
       if not hdr then break end
       local typ,len = wire.from_MSB16(hdr),wire.from_MSB32(hdr:sub(3))
       local payload = sc:receive(len)
       if not payload then break end
       mgr.notify(mgr.REQUEST, sc, typ, payload)
    end
    print("autoclose=",copas.autoclose)
    mgr.notify(mgr.TERMINATE, sc)

    print("termination from", host, port)
    if (not copas.autoclose) then sc:close() end
end

local function udp_mumble(host, port, handler)
   local server = socket.udp()
   server:setsockname(host,port)
   return copas.addserver(server,
			  function(c)
			     return handler(copas.wrap(c))
   end)
end

function udp_handler(sc)
  sc = copas.wrap(sc)
  print("UDP connection handler")
  while true do
    local data,ip,port, err = sc:receivefrom(1024)
    if not data then
      print("UDP Receive error: ", err)
      return
    end
    mgr.notify(mgr.REQUEST_UDP, sc, ip, port, data)
  end
end

copas.autoclose=true
-- copas.loop()
manager = mgr.start()
print("Manager", manager)
tcp_mumble("*", 64738, ssl_handler)
udp_mumble("*", 64738, udp_handler)
print("Waiting on 64738...")
copas.loop()
