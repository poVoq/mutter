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
--  verify = {"peer", "client_once"},
  verify = {"none"},
  options = {"all" },
  ciphers = "HIGH+kEDH:HIGH+kEECDH:HIGH:!PSK:!SRP:!3DES:!aNULL"
}

local function mumble(host, port, handler)
    return copas.addserver(assert(socket.bind(host, port)),
        function(c)
            return handler(copas.wrap(c), c:getpeername())
        end)
end


local manager = nil

local function ssl_handler(sc, host, port)
    print("Got connection from ", host, port)
    sc = copas.wrap(sc):dohandshake(sslparams)
    mgr.notify(mgr.REGISTER, sc)
    while true do
       local hdr = sc:receive(6)
       if not hdr then break end
       local typ,len = wire.from_MSB16(hdr),wire.from_MSB32(hdr:sub(3))
       local payload = sc:receive(len)
       mgr.notify(mgr.REQUEST, sc, typ, payload)
    end
    mgr.notify(mgr.TERMINATE, sc)
    print("termination from", host, port)
end

manager = mgr.start()
mumble("*", 64738, ssl_handler)
print("Waiting on 64738...")
copas.loop()
