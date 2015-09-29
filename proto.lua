package.cpath = "../../luarocks/lib/lua/5.1/?.so;"..package.cpath
package.path = "../../.luarocks/share/lua/5.1/?.lua;../../.luarocks/share/lua/5.1/?/init.lua;../../luarocks/share/lua/5.1/?.lua;../../luarocks/share/lua/5.1/?/init.lua;"..package.path
local protobuf = require "mumble"

local proto = {
   VERSION=0, UDPTUNNEL=1, AUTHENTICATE=2, PING=3, REJECT=4, SERVERSYNC=5,
   CHANNELREMOVE=6, CHANNELSTATE=7, USERREMOVE=8, USERSTATE=9, BANLIST=10,
   TEXTMESSAGE=11, PERMISSIONDENIED=12, ACL=13, QUERYUSERS=14, CRYPTSETUP=15,
   CONTEXTACTIONMODIFY=16, CONTEXTACTION=17, USERLIST=18, VOICETARGET=19,
   PERMISSIONQUERY=20, CODECVERSION=21, USERSTATS=22, REQUESTBLOB=23,
   SERVERCONFIG=24, SUGGESTCONFIG=25
}

proto.Version = protobuf("MumbleProto.Version")
proto.UDPTunnel = protobuf("MumbleProto.UDPTunnel")
proto.Authenticate = protobuf("MumbleProto.Authenticate")
proto.Ping = protobuf("MumbleProto.Ping")
proto.Reject = protobuf("MumbleProto.Reject")
proto.ServerSync = protobuf("MumbleProto.ServerSync")
proto.ChannelRemove = protobuf("MumbleProto.ChannelRemove")
proto.ChannelState = protobuf("MumbleProto.ChannelState")
proto.UserRemove = protobuf("MumbleProto.UserRemove")
proto.UserState = protobuf("MumbleProto.UserState")
proto.BanList = protobuf("MumbleProto.BanList")
proto.TextMessage = protobuf("MumbleProto.TextMessage")
proto.PermissionDenied = protobuf("MumbleProto.PermissionDenied")
proto.ACL = protobuf("MumbleProto.ACL")
proto.QueryUsers = protobuf("MumbleProto.QueryUsers")
proto.CryptSetup = protobuf("MumbleProto.CryptSetup")
proto.ContextActionModify = protobuf("MumbleProto.ContextActionModify")
proto.ContextAction = protobuf("MumbleProto.ContextAction")
proto.UserList = protobuf("MumbleProto.UserList")
proto.VoiceTarget = protobuf("MumbleProto.VoiceTarget")
proto.PermissionQuery = protobuf("MumbleProto.PermissionQuery")
proto.CodecVersion = protobuf("MumbleProto.CodecVersion")
proto.UserStats = protobuf("MumbleProto.UserStats")
proto.RequestBlob = protobuf("MumbleProto.RequestBlob")
proto.ServerConfig = protobuf("MumbleProto.ServerConfig")
proto.SuggestConfig = protobuf("MumbleProto.SuggestConfig")

return proto

