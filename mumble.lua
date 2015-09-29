local proto = require( "pb4lua" )
local class_registry, enum_registry = {}, {}
local generic_load, generic_check         -- forward declarations
-- cache all required global functions in locals
local assert = assert
local type = assert( type )
local tconcat = assert( type( table ) == "table" and table.concat )
local ssub = assert( type( string ) == "table" and string.sub )
local next = assert( next )
local tostring = assert( tostring )
local setmetatable = assert( setmetatable )

local function message_loader( message )
  return function( s, f, t )
    local vf, vt = proto.load_lendelim( s, f, t )
    if vf == nil then
      return nil, "corrupt protobuf at position " .. f
    end
    return class_registry[ message ]:load( s, vf, vt )
  end
end

----------------------------------------------------------------------
-----------------------[  enum definitions  ]-------------------------
----------------------------------------------------------------------

enum_registry[ "MumbleProto.Reject.RejectType" ] = {
  None = 0,
  [ 0 ] = "None",
  WrongVersion = 1,
  [ 1 ] = "WrongVersion",
  InvalidUsername = 2,
  [ 2 ] = "InvalidUsername",
  WrongUserPW = 3,
  [ 3 ] = "WrongUserPW",
  WrongServerPW = 4,
  [ 4 ] = "WrongServerPW",
  UsernameInUse = 5,
  [ 5 ] = "UsernameInUse",
  ServerFull = 6,
  [ 6 ] = "ServerFull",
  NoCertificate = 7,
  [ 7 ] = "NoCertificate",
  AuthenticatorFail = 8,
  [ 8 ] = "AuthenticatorFail",
}

enum_registry[ "MumbleProto.PermissionDenied.DenyType" ] = {
  Text = 0,
  [ 0 ] = "Text",
  Permission = 1,
  [ 1 ] = "Permission",
  SuperUser = 2,
  [ 2 ] = "SuperUser",
  ChannelName = 3,
  [ 3 ] = "ChannelName",
  TextTooLong = 4,
  [ 4 ] = "TextTooLong",
  H9K = 5,
  [ 5 ] = "H9K",
  TemporaryChannel = 6,
  [ 6 ] = "TemporaryChannel",
  MissingCertificate = 7,
  [ 7 ] = "MissingCertificate",
  UserName = 8,
  [ 8 ] = "UserName",
  ChannelFull = 9,
  [ 9 ] = "ChannelFull",
  NestingLimit = 10,
  [ 10 ] = "NestingLimit",
}

enum_registry[ "MumbleProto.ContextActionModify.Context" ] = {
  Server = 1,
  [ 1 ] = "Server",
  Channel = 2,
  [ 2 ] = "Channel",
  User = 4,
  [ 4 ] = "User",
}

enum_registry[ "MumbleProto.ContextActionModify.Operation" ] = {
  Add = 0,
  [ 0 ] = "Add",
  Remove = 1,
  [ 1 ] = "Remove",
}

----------------------------------------------------------------------
----------------------[  message definitions  ]-----------------------
----------------------------------------------------------------------

do -- MumbleProto.Version
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.version == nil then obj.version = 0 end
      if obj.release == nil then obj.release = "" end
      if obj.os == nil then obj.os = "" end
      if obj.os_version == nil then obj.os_version = "" end
    else
      obj = {
        version = 0,
        release = "",
        os = "",
        os_version = "",
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.version ~= nil then self.version = other.version end
    if other.release ~= nil then self.release = other.release end
    if other.os ~= nil then self.os = other.os end
    if other.os_version ~= nil then self.os_version = other.os_version end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "version",
    },
    [ 2 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "release",
    },
    [ 3 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "os",
    },
    [ 4 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "os_version",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.version ~= nil and self.version ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.version ); i = i + 1
    end
    if self.release ~= nil and self.release ~= "" then
      buffer[ i ] = "\18" --[[ proto.save_key( 2, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.release ); i = i + 1
    end
    if self.os ~= nil and self.os ~= "" then
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.os ); i = i + 1
    end
    if self.os_version ~= nil and self.os_version ~= "" then
      buffer[ i ] = "\34" --[[ proto.save_key( 4, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.os_version ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.Version" ] = message
end



do -- MumbleProto.UDPTunnel
  local required_types = {
    packet = "string",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
    else
      obj = {
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.packet ~= nil then self.packet = other.packet end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "packet",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    buffer[ i ] = "\10" --[[ proto.save_key( 1, 2 ) ]]; i = i + 1
    buffer[ i ] = proto.save_bytes( self.packet ); i = i + 1
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.UDPTunnel" ] = message
end



do -- MumbleProto.Authenticate
  local required_types = {
    tokens = "table",
    celt_versions = "table",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.username == nil then obj.username = "" end
      if obj.password == nil then obj.password = "" end
      if type( obj.tokens ) ~= "table" then obj.tokens = {} end
      if type( obj.celt_versions ) ~= "table" then obj.celt_versions = {} end
      if obj.opus == nil then obj.opus = false end
    else
      obj = {
        username = "",
        password = "",
        tokens = {},
        celt_versions = {},
        opus = false,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.username ~= nil then self.username = other.username end
    if other.password ~= nil then self.password = other.password end
    do
      local dst, src = self.tokens, other.tokens
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    do
      local dst, src = self.celt_versions, other.celt_versions
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    if other.opus ~= nil then self.opus = other.opus end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "username",
    },
    [ 2 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "password",
    },
    [ 3 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "tokens",
      is_repeated = true,
    },
    [ 4 ] = {
      loader = proto.load_int32,
      wire_type = 0,
      name = "celt_versions",
      is_repeated = true,
    },
    [ 5 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "opus",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.username ~= nil and self.username ~= "" then
      buffer[ i ] = "\10" --[[ proto.save_key( 1, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.username ); i = i + 1
    end
    if self.password ~= nil and self.password ~= "" then
      buffer[ i ] = "\18" --[[ proto.save_key( 2, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.password ); i = i + 1
    end
    for k = 1, #(self.tokens) do
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.tokens[ k ] ); i = i + 1
    end
    for k = 1, #(self.celt_versions) do
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_int32( self.celt_versions[ k ] ); i = i + 1
    end
    if self.opus ~= nil and self.opus ~= false then
      buffer[ i ] = "\40" --[[ proto.save_key( 5, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.opus ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.Authenticate" ] = message
end



do -- MumbleProto.Ping
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.timestamp == nil then obj.timestamp = 0 end
      if obj.good == nil then obj.good = 0 end
      if obj.late == nil then obj.late = 0 end
      if obj.lost == nil then obj.lost = 0 end
      if obj.resync == nil then obj.resync = 0 end
      if obj.udp_packets == nil then obj.udp_packets = 0 end
      if obj.tcp_packets == nil then obj.tcp_packets = 0 end
      if obj.udp_ping_avg == nil then obj.udp_ping_avg = 0 end
      if obj.udp_ping_var == nil then obj.udp_ping_var = 0 end
      if obj.tcp_ping_avg == nil then obj.tcp_ping_avg = 0 end
      if obj.tcp_ping_var == nil then obj.tcp_ping_var = 0 end
    else
      obj = {
        timestamp = 0,
        good = 0,
        late = 0,
        lost = 0,
        resync = 0,
        udp_packets = 0,
        tcp_packets = 0,
        udp_ping_avg = 0,
        udp_ping_var = 0,
        tcp_ping_avg = 0,
        tcp_ping_var = 0,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.timestamp ~= nil then self.timestamp = other.timestamp end
    if other.good ~= nil then self.good = other.good end
    if other.late ~= nil then self.late = other.late end
    if other.lost ~= nil then self.lost = other.lost end
    if other.resync ~= nil then self.resync = other.resync end
    if other.udp_packets ~= nil then self.udp_packets = other.udp_packets end
    if other.tcp_packets ~= nil then self.tcp_packets = other.tcp_packets end
    if other.udp_ping_avg ~= nil then self.udp_ping_avg = other.udp_ping_avg end
    if other.udp_ping_var ~= nil then self.udp_ping_var = other.udp_ping_var end
    if other.tcp_ping_avg ~= nil then self.tcp_ping_avg = other.tcp_ping_avg end
    if other.tcp_ping_var ~= nil then self.tcp_ping_var = other.tcp_ping_var end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint64,
      wire_type = 0,
      name = "timestamp",
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "good",
    },
    [ 3 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "late",
    },
    [ 4 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "lost",
    },
    [ 5 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "resync",
    },
    [ 6 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "udp_packets",
    },
    [ 7 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "tcp_packets",
    },
    [ 8 ] = {
      loader = proto.load_float,
      wire_type = 5,
      name = "udp_ping_avg",
    },
    [ 9 ] = {
      loader = proto.load_float,
      wire_type = 5,
      name = "udp_ping_var",
    },
    [ 10 ] = {
      loader = proto.load_float,
      wire_type = 5,
      name = "tcp_ping_avg",
    },
    [ 11 ] = {
      loader = proto.load_float,
      wire_type = 5,
      name = "tcp_ping_var",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.timestamp ~= nil and self.timestamp ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint64( self.timestamp ); i = i + 1
    end
    if self.good ~= nil and self.good ~= 0 then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.good ); i = i + 1
    end
    if self.late ~= nil and self.late ~= 0 then
      buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.late ); i = i + 1
    end
    if self.lost ~= nil and self.lost ~= 0 then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.lost ); i = i + 1
    end
    if self.resync ~= nil and self.resync ~= 0 then
      buffer[ i ] = "\40" --[[ proto.save_key( 5, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.resync ); i = i + 1
    end
    if self.udp_packets ~= nil and self.udp_packets ~= 0 then
      buffer[ i ] = "\48" --[[ proto.save_key( 6, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.udp_packets ); i = i + 1
    end
    if self.tcp_packets ~= nil and self.tcp_packets ~= 0 then
      buffer[ i ] = "\56" --[[ proto.save_key( 7, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.tcp_packets ); i = i + 1
    end
    if self.udp_ping_avg ~= nil and self.udp_ping_avg ~= 0 then
      buffer[ i ] = "\69" --[[ proto.save_key( 8, 5 ) ]]; i = i + 1
      buffer[ i ] = proto.save_float( self.udp_ping_avg ); i = i + 1
    end
    if self.udp_ping_var ~= nil and self.udp_ping_var ~= 0 then
      buffer[ i ] = "\77" --[[ proto.save_key( 9, 5 ) ]]; i = i + 1
      buffer[ i ] = proto.save_float( self.udp_ping_var ); i = i + 1
    end
    if self.tcp_ping_avg ~= nil and self.tcp_ping_avg ~= 0 then
      buffer[ i ] = "\85" --[[ proto.save_key( 10, 5 ) ]]; i = i + 1
      buffer[ i ] = proto.save_float( self.tcp_ping_avg ); i = i + 1
    end
    if self.tcp_ping_var ~= nil and self.tcp_ping_var ~= 0 then
      buffer[ i ] = "\93" --[[ proto.save_key( 11, 5 ) ]]; i = i + 1
      buffer[ i ] = proto.save_float( self.tcp_ping_var ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.Ping" ] = message
end



do -- MumbleProto.Reject
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.type == nil then obj.type = "None" end
      if obj.reason == nil then obj.reason = "" end
    else
      obj = {
        type = "None",
        reason = "",
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.type ~= nil then self.type = other.type end
    if other.reason ~= nil then self.reason = other.reason end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_enum,
      wire_type = 0,
      name = "type",
      mapper = enum_registry[ "MumbleProto.Reject.RejectType" ],
    },
    [ 2 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "reason",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.type ~= nil and self.type ~= "None" then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      local n = enum_registry[ "MumbleProto.Reject.RejectType" ][ self.type ]
      if type( n ) ~= "number" then
        return nil, "invalid enum value `" .. tostring( self.type ) .. "'"
      end
      buffer[ i ] = proto.save_enum( n ); i = i + 1
    end
    if self.reason ~= nil and self.reason ~= "" then
      buffer[ i ] = "\18" --[[ proto.save_key( 2, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.reason ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.Reject" ] = message
end



do -- MumbleProto.ServerSync
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.session == nil then obj.session = 0 end
      if obj.max_bandwidth == nil then obj.max_bandwidth = 0 end
      if obj.welcome_text == nil then obj.welcome_text = "" end
      if obj.permissions == nil then obj.permissions = 0 end
    else
      obj = {
        session = 0,
        max_bandwidth = 0,
        welcome_text = "",
        permissions = 0,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.session ~= nil then self.session = other.session end
    if other.max_bandwidth ~= nil then self.max_bandwidth = other.max_bandwidth end
    if other.welcome_text ~= nil then self.welcome_text = other.welcome_text end
    if other.permissions ~= nil then self.permissions = other.permissions end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "session",
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "max_bandwidth",
    },
    [ 3 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "welcome_text",
    },
    [ 4 ] = {
      loader = proto.load_uint64,
      wire_type = 0,
      name = "permissions",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.session ~= nil and self.session ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.session ); i = i + 1
    end
    if self.max_bandwidth ~= nil and self.max_bandwidth ~= 0 then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.max_bandwidth ); i = i + 1
    end
    if self.welcome_text ~= nil and self.welcome_text ~= "" then
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.welcome_text ); i = i + 1
    end
    if self.permissions ~= nil and self.permissions ~= 0 then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint64( self.permissions ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.ServerSync" ] = message
end



do -- MumbleProto.ChannelRemove
  local required_types = {
    channel_id = "number",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
    else
      obj = {
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.channel_id ~= nil then self.channel_id = other.channel_id end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "channel_id",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
    buffer[ i ] = proto.save_uint32( self.channel_id ); i = i + 1
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.ChannelRemove" ] = message
end



do -- MumbleProto.ChannelState
  local required_types = {
    links = "table",
    links_add = "table",
    links_remove = "table",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.channel_id == nil then obj.channel_id = 0 end
      if obj.parent == nil then obj.parent = 0 end
      if obj.name == nil then obj.name = "" end
      if type( obj.links ) ~= "table" then obj.links = {} end
      if obj.description == nil then obj.description = "" end
      if type( obj.links_add ) ~= "table" then obj.links_add = {} end
      if type( obj.links_remove ) ~= "table" then obj.links_remove = {} end
      if obj.temporary == nil then obj.temporary = false end
      if obj.position == nil then obj.position = 0 end
      if obj.description_hash == nil then obj.description_hash = "" end
    else
      obj = {
        channel_id = 0,
        parent = 0,
        name = "",
        links = {},
        description = "",
        links_add = {},
        links_remove = {},
        temporary = false,
        position = 0,
        description_hash = "",
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.channel_id ~= nil then self.channel_id = other.channel_id end
    if other.parent ~= nil then self.parent = other.parent end
    if other.name ~= nil then self.name = other.name end
    do
      local dst, src = self.links, other.links
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    if other.description ~= nil then self.description = other.description end
    do
      local dst, src = self.links_add, other.links_add
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    do
      local dst, src = self.links_remove, other.links_remove
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    if other.temporary ~= nil then self.temporary = other.temporary end
    if other.position ~= nil then self.position = other.position end
    if other.description_hash ~= nil then self.description_hash = other.description_hash end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "channel_id",
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "parent",
    },
    [ 3 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "name",
    },
    [ 4 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "links",
      is_repeated = true,
    },
    [ 5 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "description",
    },
    [ 6 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "links_add",
      is_repeated = true,
    },
    [ 7 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "links_remove",
      is_repeated = true,
    },
    [ 8 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "temporary",
    },
    [ 9 ] = {
      loader = proto.load_int32,
      wire_type = 0,
      name = "position",
    },
    [ 10 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "description_hash",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.channel_id ~= nil and self.channel_id ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.channel_id ); i = i + 1
    end
    if self.parent ~= nil and self.parent ~= 0 then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.parent ); i = i + 1
    end
    if self.name ~= nil and self.name ~= "" then
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.name ); i = i + 1
    end
    for k = 1, #(self.links) do
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.links[ k ] ); i = i + 1
    end
    if self.description ~= nil and self.description ~= "" then
      buffer[ i ] = "\42" --[[ proto.save_key( 5, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.description ); i = i + 1
    end
    for k = 1, #(self.links_add) do
      buffer[ i ] = "\48" --[[ proto.save_key( 6, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.links_add[ k ] ); i = i + 1
    end
    for k = 1, #(self.links_remove) do
      buffer[ i ] = "\56" --[[ proto.save_key( 7, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.links_remove[ k ] ); i = i + 1
    end
    if self.temporary ~= nil and self.temporary ~= false then
      buffer[ i ] = "\64" --[[ proto.save_key( 8, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.temporary ); i = i + 1
    end
    if self.position ~= nil and self.position ~= 0 then
      buffer[ i ] = "\72" --[[ proto.save_key( 9, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_int32( self.position ); i = i + 1
    end
    if self.description_hash ~= nil and self.description_hash ~= "" then
      buffer[ i ] = "\82" --[[ proto.save_key( 10, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bytes( self.description_hash ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.ChannelState" ] = message
end



do -- MumbleProto.UserRemove
  local required_types = {
    session = "number",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.actor == nil then obj.actor = 0 end
      if obj.reason == nil then obj.reason = "" end
      if obj.ban == nil then obj.ban = false end
    else
      obj = {
        actor = 0,
        reason = "",
        ban = false,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.session ~= nil then self.session = other.session end
    if other.actor ~= nil then self.actor = other.actor end
    if other.reason ~= nil then self.reason = other.reason end
    if other.ban ~= nil then self.ban = other.ban end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "session",
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "actor",
    },
    [ 3 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "reason",
    },
    [ 4 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "ban",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
    buffer[ i ] = proto.save_uint32( self.session ); i = i + 1
    if self.actor ~= nil and self.actor ~= 0 then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.actor ); i = i + 1
    end
    if self.reason ~= nil and self.reason ~= "" then
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.reason ); i = i + 1
    end
    if self.ban ~= nil and self.ban ~= false then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.ban ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.UserRemove" ] = message
end



do -- MumbleProto.UserState
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.session == nil then obj.session = 0 end
      if obj.actor == nil then obj.actor = 0 end
      if obj.name == nil then obj.name = "" end
      if obj.user_id == nil then obj.user_id = 0 end
      if obj.channel_id == nil then obj.channel_id = 0 end
      if obj.mute == nil then obj.mute = false end
      if obj.deaf == nil then obj.deaf = false end
      if obj.suppress == nil then obj.suppress = false end
      if obj.self_mute == nil then obj.self_mute = false end
      if obj.self_deaf == nil then obj.self_deaf = false end
      if obj.texture == nil then obj.texture = "" end
      if obj.plugin_context == nil then obj.plugin_context = "" end
      if obj.plugin_identity == nil then obj.plugin_identity = "" end
      if obj.comment == nil then obj.comment = "" end
      if obj.hash == nil then obj.hash = "" end
      if obj.comment_hash == nil then obj.comment_hash = "" end
      if obj.texture_hash == nil then obj.texture_hash = "" end
      if obj.priority_speaker == nil then obj.priority_speaker = false end
      if obj.recording == nil then obj.recording = false end
    else
      obj = {
        session = 0,
        actor = 0,
        name = "",
        user_id = 0,
        channel_id = 0,
        mute = false,
        deaf = false,
        suppress = false,
        self_mute = false,
        self_deaf = false,
        texture = "",
        plugin_context = "",
        plugin_identity = "",
        comment = "",
        hash = "",
        comment_hash = "",
        texture_hash = "",
        priority_speaker = false,
        recording = false,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.session ~= nil then self.session = other.session end
    if other.actor ~= nil then self.actor = other.actor end
    if other.name ~= nil then self.name = other.name end
    if other.user_id ~= nil then self.user_id = other.user_id end
    if other.channel_id ~= nil then self.channel_id = other.channel_id end
    if other.mute ~= nil then self.mute = other.mute end
    if other.deaf ~= nil then self.deaf = other.deaf end
    if other.suppress ~= nil then self.suppress = other.suppress end
    if other.self_mute ~= nil then self.self_mute = other.self_mute end
    if other.self_deaf ~= nil then self.self_deaf = other.self_deaf end
    if other.texture ~= nil then self.texture = other.texture end
    if other.plugin_context ~= nil then self.plugin_context = other.plugin_context end
    if other.plugin_identity ~= nil then self.plugin_identity = other.plugin_identity end
    if other.comment ~= nil then self.comment = other.comment end
    if other.hash ~= nil then self.hash = other.hash end
    if other.comment_hash ~= nil then self.comment_hash = other.comment_hash end
    if other.texture_hash ~= nil then self.texture_hash = other.texture_hash end
    if other.priority_speaker ~= nil then self.priority_speaker = other.priority_speaker end
    if other.recording ~= nil then self.recording = other.recording end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "session",
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "actor",
    },
    [ 3 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "name",
    },
    [ 4 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "user_id",
    },
    [ 5 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "channel_id",
    },
    [ 6 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "mute",
    },
    [ 7 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "deaf",
    },
    [ 8 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "suppress",
    },
    [ 9 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "self_mute",
    },
    [ 10 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "self_deaf",
    },
    [ 11 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "texture",
    },
    [ 12 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "plugin_context",
    },
    [ 13 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "plugin_identity",
    },
    [ 14 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "comment",
    },
    [ 15 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "hash",
    },
    [ 16 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "comment_hash",
    },
    [ 17 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "texture_hash",
    },
    [ 18 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "priority_speaker",
    },
    [ 19 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "recording",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.session ~= nil and self.session ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.session ); i = i + 1
    end
    if self.actor ~= nil and self.actor ~= 0 then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.actor ); i = i + 1
    end
    if self.name ~= nil and self.name ~= "" then
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.name ); i = i + 1
    end
    if self.user_id ~= nil and self.user_id ~= 0 then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.user_id ); i = i + 1
    end
    if self.channel_id ~= nil and self.channel_id ~= 0 then
      buffer[ i ] = "\40" --[[ proto.save_key( 5, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.channel_id ); i = i + 1
    end
    if self.mute ~= nil and self.mute ~= false then
      buffer[ i ] = "\48" --[[ proto.save_key( 6, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.mute ); i = i + 1
    end
    if self.deaf ~= nil and self.deaf ~= false then
      buffer[ i ] = "\56" --[[ proto.save_key( 7, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.deaf ); i = i + 1
    end
    if self.suppress ~= nil and self.suppress ~= false then
      buffer[ i ] = "\64" --[[ proto.save_key( 8, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.suppress ); i = i + 1
    end
    if self.self_mute ~= nil and self.self_mute ~= false then
      buffer[ i ] = "\72" --[[ proto.save_key( 9, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.self_mute ); i = i + 1
    end
    if self.self_deaf ~= nil and self.self_deaf ~= false then
      buffer[ i ] = "\80" --[[ proto.save_key( 10, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.self_deaf ); i = i + 1
    end
    if self.texture ~= nil and self.texture ~= "" then
      buffer[ i ] = "\90" --[[ proto.save_key( 11, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bytes( self.texture ); i = i + 1
    end
    if self.plugin_context ~= nil and self.plugin_context ~= "" then
      buffer[ i ] = "\98" --[[ proto.save_key( 12, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bytes( self.plugin_context ); i = i + 1
    end
    if self.plugin_identity ~= nil and self.plugin_identity ~= "" then
      buffer[ i ] = "\106" --[[ proto.save_key( 13, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.plugin_identity ); i = i + 1
    end
    if self.comment ~= nil and self.comment ~= "" then
      buffer[ i ] = "\114" --[[ proto.save_key( 14, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.comment ); i = i + 1
    end
    if self.hash ~= nil and self.hash ~= "" then
      buffer[ i ] = "\122" --[[ proto.save_key( 15, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.hash ); i = i + 1
    end
    if self.comment_hash ~= nil and self.comment_hash ~= "" then
      buffer[ i ] = "\130\1" --[[ proto.save_key( 16, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bytes( self.comment_hash ); i = i + 1
    end
    if self.texture_hash ~= nil and self.texture_hash ~= "" then
      buffer[ i ] = "\138\1" --[[ proto.save_key( 17, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bytes( self.texture_hash ); i = i + 1
    end
    if self.priority_speaker ~= nil and self.priority_speaker ~= false then
      buffer[ i ] = "\144\1" --[[ proto.save_key( 18, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.priority_speaker ); i = i + 1
    end
    if self.recording ~= nil and self.recording ~= false then
      buffer[ i ] = "\152\1" --[[ proto.save_key( 19, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.recording ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.UserState" ] = message
end



do -- MumbleProto.BanList
  local required_types = {
    bans = "table",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if type( obj.bans ) ~= "table" then obj.bans = {} end
      if obj.query == nil then obj.query = false end
    else
      obj = {
        bans = {},
        query = false,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    do
      local dst, src = self.bans, other.bans
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    if other.query ~= nil then self.query = other.query end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = message_loader( "MumbleProto.BanList.BanEntry" ),
      wire_type = 2,
      name = "bans",
      is_repeated = true,
      is_usertype = true,
    },
    [ 2 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "query",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    for k = 1, #(self.bans) do
      buffer[ i ] = "\10" --[[ proto.save_key( 1, 2 ) ]]; i = i + 1
      local s, m = self.bans[ k ]:save()
      if s == nil then
        return nil, m
      end
      buffer[ i ] = proto.save_bytes( s ); i = i + 1
    end
    if self.query ~= nil and self.query ~= false then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.query ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.BanList" ] = message
end



do -- MumbleProto.BanList.BanEntry
  local required_types = {
    address = "string",
    mask = "number",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.name == nil then obj.name = "" end
      if obj.hash == nil then obj.hash = "" end
      if obj.reason == nil then obj.reason = "" end
      if obj.start == nil then obj.start = "" end
      if obj.duration == nil then obj.duration = 0 end
    else
      obj = {
        name = "",
        hash = "",
        reason = "",
        start = "",
        duration = 0,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.address ~= nil then self.address = other.address end
    if other.mask ~= nil then self.mask = other.mask end
    if other.name ~= nil then self.name = other.name end
    if other.hash ~= nil then self.hash = other.hash end
    if other.reason ~= nil then self.reason = other.reason end
    if other.start ~= nil then self.start = other.start end
    if other.duration ~= nil then self.duration = other.duration end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "address",
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "mask",
    },
    [ 3 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "name",
    },
    [ 4 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "hash",
    },
    [ 5 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "reason",
    },
    [ 6 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "start",
    },
    [ 7 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "duration",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    buffer[ i ] = "\10" --[[ proto.save_key( 1, 2 ) ]]; i = i + 1
    buffer[ i ] = proto.save_bytes( self.address ); i = i + 1
    buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
    buffer[ i ] = proto.save_uint32( self.mask ); i = i + 1
    if self.name ~= nil and self.name ~= "" then
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.name ); i = i + 1
    end
    if self.hash ~= nil and self.hash ~= "" then
      buffer[ i ] = "\34" --[[ proto.save_key( 4, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.hash ); i = i + 1
    end
    if self.reason ~= nil and self.reason ~= "" then
      buffer[ i ] = "\42" --[[ proto.save_key( 5, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.reason ); i = i + 1
    end
    if self.start ~= nil and self.start ~= "" then
      buffer[ i ] = "\50" --[[ proto.save_key( 6, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.start ); i = i + 1
    end
    if self.duration ~= nil and self.duration ~= 0 then
      buffer[ i ] = "\56" --[[ proto.save_key( 7, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.duration ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.BanList.BanEntry" ] = message
end



do -- MumbleProto.TextMessage
  local required_types = {
    session = "table",
    channel_id = "table",
    tree_id = "table",
    message = "string",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.actor == nil then obj.actor = 0 end
      if type( obj.session ) ~= "table" then obj.session = {} end
      if type( obj.channel_id ) ~= "table" then obj.channel_id = {} end
      if type( obj.tree_id ) ~= "table" then obj.tree_id = {} end
    else
      obj = {
        actor = 0,
        session = {},
        channel_id = {},
        tree_id = {},
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.actor ~= nil then self.actor = other.actor end
    do
      local dst, src = self.session, other.session
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    do
      local dst, src = self.channel_id, other.channel_id
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    do
      local dst, src = self.tree_id, other.tree_id
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    if other.message ~= nil then self.message = other.message end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "actor",
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "session",
      is_repeated = true,
    },
    [ 3 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "channel_id",
      is_repeated = true,
    },
    [ 4 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "tree_id",
      is_repeated = true,
    },
    [ 5 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "message",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.actor ~= nil and self.actor ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.actor ); i = i + 1
    end
    for k = 1, #(self.session) do
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.session[ k ] ); i = i + 1
    end
    for k = 1, #(self.channel_id) do
      buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.channel_id[ k ] ); i = i + 1
    end
    for k = 1, #(self.tree_id) do
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.tree_id[ k ] ); i = i + 1
    end
    buffer[ i ] = "\42" --[[ proto.save_key( 5, 2 ) ]]; i = i + 1
    buffer[ i ] = proto.save_string( self.message ); i = i + 1
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.TextMessage" ] = message
end



do -- MumbleProto.PermissionDenied
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.permission == nil then obj.permission = 0 end
      if obj.channel_id == nil then obj.channel_id = 0 end
      if obj.session == nil then obj.session = 0 end
      if obj.reason == nil then obj.reason = "" end
      if obj.type == nil then obj.type = "Text" end
      if obj.name == nil then obj.name = "" end
    else
      obj = {
        permission = 0,
        channel_id = 0,
        session = 0,
        reason = "",
        type = "Text",
        name = "",
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.permission ~= nil then self.permission = other.permission end
    if other.channel_id ~= nil then self.channel_id = other.channel_id end
    if other.session ~= nil then self.session = other.session end
    if other.reason ~= nil then self.reason = other.reason end
    if other.type ~= nil then self.type = other.type end
    if other.name ~= nil then self.name = other.name end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "permission",
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "channel_id",
    },
    [ 3 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "session",
    },
    [ 4 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "reason",
    },
    [ 5 ] = {
      loader = proto.load_enum,
      wire_type = 0,
      name = "type",
      mapper = enum_registry[ "MumbleProto.PermissionDenied.DenyType" ],
    },
    [ 6 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "name",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.permission ~= nil and self.permission ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.permission ); i = i + 1
    end
    if self.channel_id ~= nil and self.channel_id ~= 0 then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.channel_id ); i = i + 1
    end
    if self.session ~= nil and self.session ~= 0 then
      buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.session ); i = i + 1
    end
    if self.reason ~= nil and self.reason ~= "" then
      buffer[ i ] = "\34" --[[ proto.save_key( 4, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.reason ); i = i + 1
    end
    if self.type ~= nil and self.type ~= "Text" then
      buffer[ i ] = "\40" --[[ proto.save_key( 5, 0 ) ]]; i = i + 1
      local n = enum_registry[ "MumbleProto.PermissionDenied.DenyType" ][ self.type ]
      if type( n ) ~= "number" then
        return nil, "invalid enum value `" .. tostring( self.type ) .. "'"
      end
      buffer[ i ] = proto.save_enum( n ); i = i + 1
    end
    if self.name ~= nil and self.name ~= "" then
      buffer[ i ] = "\50" --[[ proto.save_key( 6, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.name ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.PermissionDenied" ] = message
end



do -- MumbleProto.ACL
  local required_types = {
    channel_id = "number",
    groups = "table",
    acls = "table",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.inherit_acls == nil then obj.inherit_acls = true end
      if type( obj.groups ) ~= "table" then obj.groups = {} end
      if type( obj.acls ) ~= "table" then obj.acls = {} end
      if obj.query == nil then obj.query = false end
    else
      obj = {
        inherit_acls = true,
        groups = {},
        acls = {},
        query = false,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.channel_id ~= nil then self.channel_id = other.channel_id end
    if other.inherit_acls ~= nil then self.inherit_acls = other.inherit_acls end
    do
      local dst, src = self.groups, other.groups
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    do
      local dst, src = self.acls, other.acls
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    if other.query ~= nil then self.query = other.query end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "channel_id",
    },
    [ 2 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "inherit_acls",
    },
    [ 3 ] = {
      loader = message_loader( "MumbleProto.ACL.ChanGroup" ),
      wire_type = 2,
      name = "groups",
      is_repeated = true,
      is_usertype = true,
    },
    [ 4 ] = {
      loader = message_loader( "MumbleProto.ACL.ChanACL" ),
      wire_type = 2,
      name = "acls",
      is_repeated = true,
      is_usertype = true,
    },
    [ 5 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "query",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
    buffer[ i ] = proto.save_uint32( self.channel_id ); i = i + 1
    if self.inherit_acls ~= nil and self.inherit_acls ~= true then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.inherit_acls ); i = i + 1
    end
    for k = 1, #(self.groups) do
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      local s, m = self.groups[ k ]:save()
      if s == nil then
        return nil, m
      end
      buffer[ i ] = proto.save_bytes( s ); i = i + 1
    end
    for k = 1, #(self.acls) do
      buffer[ i ] = "\34" --[[ proto.save_key( 4, 2 ) ]]; i = i + 1
      local s, m = self.acls[ k ]:save()
      if s == nil then
        return nil, m
      end
      buffer[ i ] = proto.save_bytes( s ); i = i + 1
    end
    if self.query ~= nil and self.query ~= false then
      buffer[ i ] = "\40" --[[ proto.save_key( 5, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.query ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.ACL" ] = message
end



do -- MumbleProto.ACL.ChanGroup
  local required_types = {
    name = "string",
    add = "table",
    remove = "table",
    inherited_members = "table",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.inherited == nil then obj.inherited = true end
      if obj.inherit == nil then obj.inherit = true end
      if obj.inheritable == nil then obj.inheritable = true end
      if type( obj.add ) ~= "table" then obj.add = {} end
      if type( obj.remove ) ~= "table" then obj.remove = {} end
      if type( obj.inherited_members ) ~= "table" then obj.inherited_members = {} end
    else
      obj = {
        inherited = true,
        inherit = true,
        inheritable = true,
        add = {},
        remove = {},
        inherited_members = {},
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.name ~= nil then self.name = other.name end
    if other.inherited ~= nil then self.inherited = other.inherited end
    if other.inherit ~= nil then self.inherit = other.inherit end
    if other.inheritable ~= nil then self.inheritable = other.inheritable end
    do
      local dst, src = self.add, other.add
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    do
      local dst, src = self.remove, other.remove
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    do
      local dst, src = self.inherited_members, other.inherited_members
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "name",
    },
    [ 2 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "inherited",
    },
    [ 3 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "inherit",
    },
    [ 4 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "inheritable",
    },
    [ 5 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "add",
      is_repeated = true,
    },
    [ 6 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "remove",
      is_repeated = true,
    },
    [ 7 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "inherited_members",
      is_repeated = true,
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    buffer[ i ] = "\10" --[[ proto.save_key( 1, 2 ) ]]; i = i + 1
    buffer[ i ] = proto.save_string( self.name ); i = i + 1
    if self.inherited ~= nil and self.inherited ~= true then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.inherited ); i = i + 1
    end
    if self.inherit ~= nil and self.inherit ~= true then
      buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.inherit ); i = i + 1
    end
    if self.inheritable ~= nil and self.inheritable ~= true then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.inheritable ); i = i + 1
    end
    for k = 1, #(self.add) do
      buffer[ i ] = "\40" --[[ proto.save_key( 5, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.add[ k ] ); i = i + 1
    end
    for k = 1, #(self.remove) do
      buffer[ i ] = "\48" --[[ proto.save_key( 6, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.remove[ k ] ); i = i + 1
    end
    for k = 1, #(self.inherited_members) do
      buffer[ i ] = "\56" --[[ proto.save_key( 7, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.inherited_members[ k ] ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.ACL.ChanGroup" ] = message
end



do -- MumbleProto.ACL.ChanACL
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.apply_here == nil then obj.apply_here = true end
      if obj.apply_subs == nil then obj.apply_subs = true end
      if obj.inherited == nil then obj.inherited = true end
      if obj.user_id == nil then obj.user_id = 0 end
      if obj.group == nil then obj.group = "" end
      if obj.grant == nil then obj.grant = 0 end
      if obj.deny == nil then obj.deny = 0 end
    else
      obj = {
        apply_here = true,
        apply_subs = true,
        inherited = true,
        user_id = 0,
        group = "",
        grant = 0,
        deny = 0,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.apply_here ~= nil then self.apply_here = other.apply_here end
    if other.apply_subs ~= nil then self.apply_subs = other.apply_subs end
    if other.inherited ~= nil then self.inherited = other.inherited end
    if other.user_id ~= nil then self.user_id = other.user_id end
    if other.group ~= nil then self.group = other.group end
    if other.grant ~= nil then self.grant = other.grant end
    if other.deny ~= nil then self.deny = other.deny end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "apply_here",
    },
    [ 2 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "apply_subs",
    },
    [ 3 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "inherited",
    },
    [ 4 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "user_id",
    },
    [ 5 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "group",
    },
    [ 6 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "grant",
    },
    [ 7 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "deny",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.apply_here ~= nil and self.apply_here ~= true then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.apply_here ); i = i + 1
    end
    if self.apply_subs ~= nil and self.apply_subs ~= true then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.apply_subs ); i = i + 1
    end
    if self.inherited ~= nil and self.inherited ~= true then
      buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.inherited ); i = i + 1
    end
    if self.user_id ~= nil and self.user_id ~= 0 then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.user_id ); i = i + 1
    end
    if self.group ~= nil and self.group ~= "" then
      buffer[ i ] = "\42" --[[ proto.save_key( 5, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.group ); i = i + 1
    end
    if self.grant ~= nil and self.grant ~= 0 then
      buffer[ i ] = "\48" --[[ proto.save_key( 6, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.grant ); i = i + 1
    end
    if self.deny ~= nil and self.deny ~= 0 then
      buffer[ i ] = "\56" --[[ proto.save_key( 7, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.deny ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.ACL.ChanACL" ] = message
end



do -- MumbleProto.QueryUsers
  local required_types = {
    ids = "table",
    names = "table",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if type( obj.ids ) ~= "table" then obj.ids = {} end
      if type( obj.names ) ~= "table" then obj.names = {} end
    else
      obj = {
        ids = {},
        names = {},
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    do
      local dst, src = self.ids, other.ids
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    do
      local dst, src = self.names, other.names
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "ids",
      is_repeated = true,
    },
    [ 2 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "names",
      is_repeated = true,
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    for k = 1, #(self.ids) do
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.ids[ k ] ); i = i + 1
    end
    for k = 1, #(self.names) do
      buffer[ i ] = "\18" --[[ proto.save_key( 2, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.names[ k ] ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.QueryUsers" ] = message
end



do -- MumbleProto.CryptSetup
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.key == nil then obj.key = "" end
      if obj.client_nonce == nil then obj.client_nonce = "" end
      if obj.server_nonce == nil then obj.server_nonce = "" end
    else
      obj = {
        key = "",
        client_nonce = "",
        server_nonce = "",
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.key ~= nil then self.key = other.key end
    if other.client_nonce ~= nil then self.client_nonce = other.client_nonce end
    if other.server_nonce ~= nil then self.server_nonce = other.server_nonce end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "key",
    },
    [ 2 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "client_nonce",
    },
    [ 3 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "server_nonce",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.key ~= nil and self.key ~= "" then
      buffer[ i ] = "\10" --[[ proto.save_key( 1, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bytes( self.key ); i = i + 1
    end
    if self.client_nonce ~= nil and self.client_nonce ~= "" then
      buffer[ i ] = "\18" --[[ proto.save_key( 2, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bytes( self.client_nonce ); i = i + 1
    end
    if self.server_nonce ~= nil and self.server_nonce ~= "" then
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bytes( self.server_nonce ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.CryptSetup" ] = message
end



do -- MumbleProto.ContextActionModify
  local required_types = {
    action = "string",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.text == nil then obj.text = "" end
      if obj.context == nil then obj.context = 0 end
      if obj.operation == nil then obj.operation = "Add" end
    else
      obj = {
        text = "",
        context = 0,
        operation = "Add",
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.action ~= nil then self.action = other.action end
    if other.text ~= nil then self.text = other.text end
    if other.context ~= nil then self.context = other.context end
    if other.operation ~= nil then self.operation = other.operation end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "action",
    },
    [ 2 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "text",
    },
    [ 3 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "context",
    },
    [ 4 ] = {
      loader = proto.load_enum,
      wire_type = 0,
      name = "operation",
      mapper = enum_registry[ "MumbleProto.ContextActionModify.Operation" ],
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    buffer[ i ] = "\10" --[[ proto.save_key( 1, 2 ) ]]; i = i + 1
    buffer[ i ] = proto.save_string( self.action ); i = i + 1
    if self.text ~= nil and self.text ~= "" then
      buffer[ i ] = "\18" --[[ proto.save_key( 2, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.text ); i = i + 1
    end
    if self.context ~= nil and self.context ~= 0 then
      buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.context ); i = i + 1
    end
    if self.operation ~= nil and self.operation ~= "Add" then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      local n = enum_registry[ "MumbleProto.ContextActionModify.Operation" ][ self.operation ]
      if type( n ) ~= "number" then
        return nil, "invalid enum value `" .. tostring( self.operation ) .. "'"
      end
      buffer[ i ] = proto.save_enum( n ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.ContextActionModify" ] = message
end



do -- MumbleProto.ContextAction
  local required_types = {
    action = "string",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.session == nil then obj.session = 0 end
      if obj.channel_id == nil then obj.channel_id = 0 end
    else
      obj = {
        session = 0,
        channel_id = 0,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.session ~= nil then self.session = other.session end
    if other.channel_id ~= nil then self.channel_id = other.channel_id end
    if other.action ~= nil then self.action = other.action end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "session",
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "channel_id",
    },
    [ 3 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "action",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.session ~= nil and self.session ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.session ); i = i + 1
    end
    if self.channel_id ~= nil and self.channel_id ~= 0 then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.channel_id ); i = i + 1
    end
    buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
    buffer[ i ] = proto.save_string( self.action ); i = i + 1
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.ContextAction" ] = message
end



do -- MumbleProto.UserList
  local required_types = {
    users = "table",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if type( obj.users ) ~= "table" then obj.users = {} end
    else
      obj = {
        users = {},
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    do
      local dst, src = self.users, other.users
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = message_loader( "MumbleProto.UserList.User" ),
      wire_type = 2,
      name = "users",
      is_repeated = true,
      is_usertype = true,
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    for k = 1, #(self.users) do
      buffer[ i ] = "\10" --[[ proto.save_key( 1, 2 ) ]]; i = i + 1
      local s, m = self.users[ k ]:save()
      if s == nil then
        return nil, m
      end
      buffer[ i ] = proto.save_bytes( s ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.UserList" ] = message
end



do -- MumbleProto.UserList.User
  local required_types = {
    user_id = "number",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.name == nil then obj.name = "" end
      if obj.last_seen == nil then obj.last_seen = "" end
      if obj.last_channel == nil then obj.last_channel = 0 end
    else
      obj = {
        name = "",
        last_seen = "",
        last_channel = 0,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.user_id ~= nil then self.user_id = other.user_id end
    if other.name ~= nil then self.name = other.name end
    if other.last_seen ~= nil then self.last_seen = other.last_seen end
    if other.last_channel ~= nil then self.last_channel = other.last_channel end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "user_id",
    },
    [ 2 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "name",
    },
    [ 3 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "last_seen",
    },
    [ 4 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "last_channel",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
    buffer[ i ] = proto.save_uint32( self.user_id ); i = i + 1
    if self.name ~= nil and self.name ~= "" then
      buffer[ i ] = "\18" --[[ proto.save_key( 2, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.name ); i = i + 1
    end
    if self.last_seen ~= nil and self.last_seen ~= "" then
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.last_seen ); i = i + 1
    end
    if self.last_channel ~= nil and self.last_channel ~= 0 then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.last_channel ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.UserList.User" ] = message
end



do -- MumbleProto.VoiceTarget
  local required_types = {
    targets = "table",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.id == nil then obj.id = 0 end
      if type( obj.targets ) ~= "table" then obj.targets = {} end
    else
      obj = {
        id = 0,
        targets = {},
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.id ~= nil then self.id = other.id end
    do
      local dst, src = self.targets, other.targets
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "id",
    },
    [ 2 ] = {
      loader = message_loader( "MumbleProto.VoiceTarget.Target" ),
      wire_type = 2,
      name = "targets",
      is_repeated = true,
      is_usertype = true,
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.id ~= nil and self.id ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.id ); i = i + 1
    end
    for k = 1, #(self.targets) do
      buffer[ i ] = "\18" --[[ proto.save_key( 2, 2 ) ]]; i = i + 1
      local s, m = self.targets[ k ]:save()
      if s == nil then
        return nil, m
      end
      buffer[ i ] = proto.save_bytes( s ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.VoiceTarget" ] = message
end



do -- MumbleProto.VoiceTarget.Target
  local required_types = {
    session = "table",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if type( obj.session ) ~= "table" then obj.session = {} end
      if obj.channel_id == nil then obj.channel_id = 0 end
      if obj.group == nil then obj.group = "" end
      if obj.links == nil then obj.links = false end
      if obj.children == nil then obj.children = false end
    else
      obj = {
        session = {},
        channel_id = 0,
        group = "",
        links = false,
        children = false,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    do
      local dst, src = self.session, other.session
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    if other.channel_id ~= nil then self.channel_id = other.channel_id end
    if other.group ~= nil then self.group = other.group end
    if other.links ~= nil then self.links = other.links end
    if other.children ~= nil then self.children = other.children end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "session",
      is_repeated = true,
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "channel_id",
    },
    [ 3 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "group",
    },
    [ 4 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "links",
    },
    [ 5 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "children",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    for k = 1, #(self.session) do
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.session[ k ] ); i = i + 1
    end
    if self.channel_id ~= nil and self.channel_id ~= 0 then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.channel_id ); i = i + 1
    end
    if self.group ~= nil and self.group ~= "" then
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.group ); i = i + 1
    end
    if self.links ~= nil and self.links ~= false then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.links ); i = i + 1
    end
    if self.children ~= nil and self.children ~= false then
      buffer[ i ] = "\40" --[[ proto.save_key( 5, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.children ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.VoiceTarget.Target" ] = message
end



do -- MumbleProto.PermissionQuery
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.channel_id == nil then obj.channel_id = 0 end
      if obj.permissions == nil then obj.permissions = 0 end
      if obj.flush == nil then obj.flush = false end
    else
      obj = {
        channel_id = 0,
        permissions = 0,
        flush = false,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.channel_id ~= nil then self.channel_id = other.channel_id end
    if other.permissions ~= nil then self.permissions = other.permissions end
    if other.flush ~= nil then self.flush = other.flush end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "channel_id",
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "permissions",
    },
    [ 3 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "flush",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.channel_id ~= nil and self.channel_id ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.channel_id ); i = i + 1
    end
    if self.permissions ~= nil and self.permissions ~= 0 then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.permissions ); i = i + 1
    end
    if self.flush ~= nil and self.flush ~= false then
      buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.flush ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.PermissionQuery" ] = message
end



do -- MumbleProto.CodecVersion
  local required_types = {
    alpha = "number",
    beta = "number",
    prefer_alpha = "boolean",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.opus == nil then obj.opus = false end
    else
      obj = {
        opus = false,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.alpha ~= nil then self.alpha = other.alpha end
    if other.beta ~= nil then self.beta = other.beta end
    if other.prefer_alpha ~= nil then self.prefer_alpha = other.prefer_alpha end
    if other.opus ~= nil then self.opus = other.opus end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_int32,
      wire_type = 0,
      name = "alpha",
    },
    [ 2 ] = {
      loader = proto.load_int32,
      wire_type = 0,
      name = "beta",
    },
    [ 3 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "prefer_alpha",
    },
    [ 4 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "opus",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
    buffer[ i ] = proto.save_int32( self.alpha ); i = i + 1
    buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
    buffer[ i ] = proto.save_int32( self.beta ); i = i + 1
    buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
    buffer[ i ] = proto.save_bool( self.prefer_alpha ); i = i + 1
    if self.opus ~= nil and self.opus ~= false then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.opus ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.CodecVersion" ] = message
end



do -- MumbleProto.UserStats
  local required_types = {
    certificates = "table",
    celt_versions = "table",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.session == nil then obj.session = 0 end
      if obj.stats_only == nil then obj.stats_only = false end
      if type( obj.certificates ) ~= "table" then obj.certificates = {} end
      if obj.from_client == nil then obj.from_client = nil end
      if obj.from_server == nil then obj.from_server = nil end
      if obj.udp_packets == nil then obj.udp_packets = 0 end
      if obj.tcp_packets == nil then obj.tcp_packets = 0 end
      if obj.udp_ping_avg == nil then obj.udp_ping_avg = 0 end
      if obj.udp_ping_var == nil then obj.udp_ping_var = 0 end
      if obj.tcp_ping_avg == nil then obj.tcp_ping_avg = 0 end
      if obj.tcp_ping_var == nil then obj.tcp_ping_var = 0 end
      if obj.version == nil then obj.version = nil end
      if type( obj.celt_versions ) ~= "table" then obj.celt_versions = {} end
      if obj.address == nil then obj.address = "" end
      if obj.bandwidth == nil then obj.bandwidth = 0 end
      if obj.onlinesecs == nil then obj.onlinesecs = 0 end
      if obj.idlesecs == nil then obj.idlesecs = 0 end
      if obj.strong_certificate == nil then obj.strong_certificate = false end
      if obj.opus == nil then obj.opus = false end
    else
      obj = {
        session = 0,
        stats_only = false,
        certificates = {},
        from_client = nil,
        from_server = nil,
        udp_packets = 0,
        tcp_packets = 0,
        udp_ping_avg = 0,
        udp_ping_var = 0,
        tcp_ping_avg = 0,
        tcp_ping_var = 0,
        version = nil,
        celt_versions = {},
        address = "",
        bandwidth = 0,
        onlinesecs = 0,
        idlesecs = 0,
        strong_certificate = false,
        opus = false,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.session ~= nil then self.session = other.session end
    if other.stats_only ~= nil then self.stats_only = other.stats_only end
    do
      local dst, src = self.certificates, other.certificates
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    self.from_client:merge( other.from_client )
    self.from_server:merge( other.from_server )
    if other.udp_packets ~= nil then self.udp_packets = other.udp_packets end
    if other.tcp_packets ~= nil then self.tcp_packets = other.tcp_packets end
    if other.udp_ping_avg ~= nil then self.udp_ping_avg = other.udp_ping_avg end
    if other.udp_ping_var ~= nil then self.udp_ping_var = other.udp_ping_var end
    if other.tcp_ping_avg ~= nil then self.tcp_ping_avg = other.tcp_ping_avg end
    if other.tcp_ping_var ~= nil then self.tcp_ping_var = other.tcp_ping_var end
    self.version:merge( other.version )
    do
      local dst, src = self.celt_versions, other.celt_versions
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    if other.address ~= nil then self.address = other.address end
    if other.bandwidth ~= nil then self.bandwidth = other.bandwidth end
    if other.onlinesecs ~= nil then self.onlinesecs = other.onlinesecs end
    if other.idlesecs ~= nil then self.idlesecs = other.idlesecs end
    if other.strong_certificate ~= nil then self.strong_certificate = other.strong_certificate end
    if other.opus ~= nil then self.opus = other.opus end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "session",
    },
    [ 2 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "stats_only",
    },
    [ 3 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "certificates",
      is_repeated = true,
    },
    [ 4 ] = {
      loader = message_loader( "MumbleProto.UserStats.Stats" ),
      wire_type = 2,
      name = "from_client",
      is_usertype = true,
    },
    [ 5 ] = {
      loader = message_loader( "MumbleProto.UserStats.Stats" ),
      wire_type = 2,
      name = "from_server",
      is_usertype = true,
    },
    [ 6 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "udp_packets",
    },
    [ 7 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "tcp_packets",
    },
    [ 8 ] = {
      loader = proto.load_float,
      wire_type = 5,
      name = "udp_ping_avg",
    },
    [ 9 ] = {
      loader = proto.load_float,
      wire_type = 5,
      name = "udp_ping_var",
    },
    [ 10 ] = {
      loader = proto.load_float,
      wire_type = 5,
      name = "tcp_ping_avg",
    },
    [ 11 ] = {
      loader = proto.load_float,
      wire_type = 5,
      name = "tcp_ping_var",
    },
    [ 12 ] = {
      loader = message_loader( "MumbleProto.Version" ),
      wire_type = 2,
      name = "version",
      is_usertype = true,
    },
    [ 13 ] = {
      loader = proto.load_int32,
      wire_type = 0,
      name = "celt_versions",
      is_repeated = true,
    },
    [ 14 ] = {
      loader = proto.load_bytes,
      wire_type = 2,
      name = "address",
    },
    [ 15 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "bandwidth",
    },
    [ 16 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "onlinesecs",
    },
    [ 17 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "idlesecs",
    },
    [ 18 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "strong_certificate",
    },
    [ 19 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "opus",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.session ~= nil and self.session ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.session ); i = i + 1
    end
    if self.stats_only ~= nil and self.stats_only ~= false then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.stats_only ); i = i + 1
    end
    for k = 1, #(self.certificates) do
      buffer[ i ] = "\26" --[[ proto.save_key( 3, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bytes( self.certificates[ k ] ); i = i + 1
    end
    if self.from_client ~= nil and self.from_client ~= nil then
      buffer[ i ] = "\34" --[[ proto.save_key( 4, 2 ) ]]; i = i + 1
      local s, m = v:save()
      if s == nil then
        return nil, m
      end
      buffer[ i ] = proto.save_bytes( s ); i = i + 1
    end
    if self.from_server ~= nil and self.from_server ~= nil then
      buffer[ i ] = "\42" --[[ proto.save_key( 5, 2 ) ]]; i = i + 1
      local s, m = v:save()
      if s == nil then
        return nil, m
      end
      buffer[ i ] = proto.save_bytes( s ); i = i + 1
    end
    if self.udp_packets ~= nil and self.udp_packets ~= 0 then
      buffer[ i ] = "\48" --[[ proto.save_key( 6, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.udp_packets ); i = i + 1
    end
    if self.tcp_packets ~= nil and self.tcp_packets ~= 0 then
      buffer[ i ] = "\56" --[[ proto.save_key( 7, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.tcp_packets ); i = i + 1
    end
    if self.udp_ping_avg ~= nil and self.udp_ping_avg ~= 0 then
      buffer[ i ] = "\69" --[[ proto.save_key( 8, 5 ) ]]; i = i + 1
      buffer[ i ] = proto.save_float( self.udp_ping_avg ); i = i + 1
    end
    if self.udp_ping_var ~= nil and self.udp_ping_var ~= 0 then
      buffer[ i ] = "\77" --[[ proto.save_key( 9, 5 ) ]]; i = i + 1
      buffer[ i ] = proto.save_float( self.udp_ping_var ); i = i + 1
    end
    if self.tcp_ping_avg ~= nil and self.tcp_ping_avg ~= 0 then
      buffer[ i ] = "\85" --[[ proto.save_key( 10, 5 ) ]]; i = i + 1
      buffer[ i ] = proto.save_float( self.tcp_ping_avg ); i = i + 1
    end
    if self.tcp_ping_var ~= nil and self.tcp_ping_var ~= 0 then
      buffer[ i ] = "\93" --[[ proto.save_key( 11, 5 ) ]]; i = i + 1
      buffer[ i ] = proto.save_float( self.tcp_ping_var ); i = i + 1
    end
    if self.version ~= nil and self.version ~= nil then
      buffer[ i ] = "\98" --[[ proto.save_key( 12, 2 ) ]]; i = i + 1
      local s, m = v:save()
      if s == nil then
        return nil, m
      end
      buffer[ i ] = proto.save_bytes( s ); i = i + 1
    end
    for k = 1, #(self.celt_versions) do
      buffer[ i ] = "\104" --[[ proto.save_key( 13, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_int32( self.celt_versions[ k ] ); i = i + 1
    end
    if self.address ~= nil and self.address ~= "" then
      buffer[ i ] = "\114" --[[ proto.save_key( 14, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bytes( self.address ); i = i + 1
    end
    if self.bandwidth ~= nil and self.bandwidth ~= 0 then
      buffer[ i ] = "\120" --[[ proto.save_key( 15, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.bandwidth ); i = i + 1
    end
    if self.onlinesecs ~= nil and self.onlinesecs ~= 0 then
      buffer[ i ] = "\128\1" --[[ proto.save_key( 16, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.onlinesecs ); i = i + 1
    end
    if self.idlesecs ~= nil and self.idlesecs ~= 0 then
      buffer[ i ] = "\136\1" --[[ proto.save_key( 17, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.idlesecs ); i = i + 1
    end
    if self.strong_certificate ~= nil and self.strong_certificate ~= false then
      buffer[ i ] = "\144\1" --[[ proto.save_key( 18, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.strong_certificate ); i = i + 1
    end
    if self.opus ~= nil and self.opus ~= false then
      buffer[ i ] = "\152\1" --[[ proto.save_key( 19, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.opus ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.UserStats" ] = message
end



do -- MumbleProto.UserStats.Stats
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.good == nil then obj.good = 0 end
      if obj.late == nil then obj.late = 0 end
      if obj.lost == nil then obj.lost = 0 end
      if obj.resync == nil then obj.resync = 0 end
    else
      obj = {
        good = 0,
        late = 0,
        lost = 0,
        resync = 0,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.good ~= nil then self.good = other.good end
    if other.late ~= nil then self.late = other.late end
    if other.lost ~= nil then self.lost = other.lost end
    if other.resync ~= nil then self.resync = other.resync end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "good",
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "late",
    },
    [ 3 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "lost",
    },
    [ 4 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "resync",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.good ~= nil and self.good ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.good ); i = i + 1
    end
    if self.late ~= nil and self.late ~= 0 then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.late ); i = i + 1
    end
    if self.lost ~= nil and self.lost ~= 0 then
      buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.lost ); i = i + 1
    end
    if self.resync ~= nil and self.resync ~= 0 then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.resync ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.UserStats.Stats" ] = message
end



do -- MumbleProto.RequestBlob
  local required_types = {
    session_texture = "table",
    session_comment = "table",
    channel_description = "table",
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if type( obj.session_texture ) ~= "table" then obj.session_texture = {} end
      if type( obj.session_comment ) ~= "table" then obj.session_comment = {} end
      if type( obj.channel_description ) ~= "table" then obj.channel_description = {} end
    else
      obj = {
        session_texture = {},
        session_comment = {},
        channel_description = {},
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    do
      local dst, src = self.session_texture, other.session_texture
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    do
      local dst, src = self.session_comment, other.session_comment
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    do
      local dst, src = self.channel_description, other.channel_description
      local n = #dst
      for i = 1, #src do
        dst[ n+i ] = src[ i ]
      end
    end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "session_texture",
      is_repeated = true,
    },
    [ 2 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "session_comment",
      is_repeated = true,
    },
    [ 3 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "channel_description",
      is_repeated = true,
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    for k = 1, #(self.session_texture) do
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.session_texture[ k ] ); i = i + 1
    end
    for k = 1, #(self.session_comment) do
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.session_comment[ k ] ); i = i + 1
    end
    for k = 1, #(self.channel_description) do
      buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.channel_description[ k ] ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.RequestBlob" ] = message
end



do -- MumbleProto.ServerConfig
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.max_bandwidth == nil then obj.max_bandwidth = 0 end
      if obj.welcome_text == nil then obj.welcome_text = "" end
      if obj.allow_html == nil then obj.allow_html = false end
      if obj.message_length == nil then obj.message_length = 0 end
      if obj.image_message_length == nil then obj.image_message_length = 0 end
    else
      obj = {
        max_bandwidth = 0,
        welcome_text = "",
        allow_html = false,
        message_length = 0,
        image_message_length = 0,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.max_bandwidth ~= nil then self.max_bandwidth = other.max_bandwidth end
    if other.welcome_text ~= nil then self.welcome_text = other.welcome_text end
    if other.allow_html ~= nil then self.allow_html = other.allow_html end
    if other.message_length ~= nil then self.message_length = other.message_length end
    if other.image_message_length ~= nil then self.image_message_length = other.image_message_length end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "max_bandwidth",
    },
    [ 2 ] = {
      loader = proto.load_string,
      wire_type = 2,
      name = "welcome_text",
    },
    [ 3 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "allow_html",
    },
    [ 4 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "message_length",
    },
    [ 5 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "image_message_length",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.max_bandwidth ~= nil and self.max_bandwidth ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.max_bandwidth ); i = i + 1
    end
    if self.welcome_text ~= nil and self.welcome_text ~= "" then
      buffer[ i ] = "\18" --[[ proto.save_key( 2, 2 ) ]]; i = i + 1
      buffer[ i ] = proto.save_string( self.welcome_text ); i = i + 1
    end
    if self.allow_html ~= nil and self.allow_html ~= false then
      buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.allow_html ); i = i + 1
    end
    if self.message_length ~= nil and self.message_length ~= 0 then
      buffer[ i ] = "\32" --[[ proto.save_key( 4, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.message_length ); i = i + 1
    end
    if self.image_message_length ~= nil and self.image_message_length ~= 0 then
      buffer[ i ] = "\40" --[[ proto.save_key( 5, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.image_message_length ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.ServerConfig" ] = message
end



do -- MumbleProto.SuggestConfig
  local required_types = {
  }


  local message = {}
  local message_meta = { __index = message }

  function message:new( obj )
    if type( obj ) == "table" then
      if obj.version == nil then obj.version = 0 end
      if obj.positional == nil then obj.positional = false end
      if obj.push_to_talk == nil then obj.push_to_talk = false end
    else
      obj = {
        version = 0,
        positional = false,
        push_to_talk = false,
      }
    end
    obj[ ".unknown." ] = ""
    setmetatable( obj, message_meta )
    return obj
  end
  setmetatable( message, { __call = message.new } )


  function message:merge( other )
    if other.version ~= nil then self.version = other.version end
    if other.positional ~= nil then self.positional = other.positional end
    if other.push_to_talk ~= nil then self.push_to_talk = other.push_to_talk end
    self[ ".unknown." ] = self[ ".unknown." ] .. other[ ".unknown." ]
  end


  local metadata = {
    [ 1 ] = {
      loader = proto.load_uint32,
      wire_type = 0,
      name = "version",
    },
    [ 2 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "positional",
    },
    [ 3 ] = {
      loader = proto.load_bool,
      wire_type = 0,
      name = "push_to_talk",
    },
  }

  function message:load( s, from, to )
    return generic_check( required_types,
             generic_load( s, from, to, metadata, message:new() ) )
  end


  function message:save()
    local status, msg = generic_check( required_types, self )
    if status == nil then
      return nil, msg
    end
    local buffer, i = {}, 1
    if self.version ~= nil and self.version ~= 0 then
      buffer[ i ] = "\8" --[[ proto.save_key( 1, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_uint32( self.version ); i = i + 1
    end
    if self.positional ~= nil and self.positional ~= false then
      buffer[ i ] = "\16" --[[ proto.save_key( 2, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.positional ); i = i + 1
    end
    if self.push_to_talk ~= nil and self.push_to_talk ~= false then
      buffer[ i ] = "\24" --[[ proto.save_key( 3, 0 ) ]]; i = i + 1
      buffer[ i ] = proto.save_bool( self.push_to_talk ); i = i + 1
    end
    buffer[ i ] = self[ ".unknown." ]
    return tconcat( buffer )
  end


  class_registry[ "MumbleProto.SuggestConfig" ] = message
end



----------------------------------------------------------------------
--------------------[  common helper functions  ]---------------------
----------------------------------------------------------------------

local function skip_and_store( obj, s, kpos, vpos, endpos, wt )
  local keystr = ssub( s, kpos, vpos-1 )
  local valstr, fieldend = proto.skip_field( s, vpos, endpos, wt )
  if valstr == nil then
    return nil, "corrupt protobuf at position " .. vpos
  end
  obj[ ".unknown." ] = obj[ ".unknown." ] .. keystr .. valstr
  return fieldend+1
end


local function load_array_field_data( str, pos, endpos, info, obj )
  local val, fieldend = info.loader( str, pos, endpos )
  if val == nil then
    if fieldend ~= nil then
      return nil, fieldend
    end
    return nil, "corrupt protobuf at position " .. pos
  end
  if info.mapper then val = info.mapper[ val ] end
  if val ~= nil then
    local t = obj[ info.name ]
    t[ #t+1 ] = val
  else
    return nil, "unknown value in protobuf at position " .. pos
  end
  return fieldend+1
end


local function load_packed_field_data( str, pos, endpos, info, obj )
  local currentpos, fieldend = proto.load_lendelim( str, pos, endpos )
  if currentpos == nil then
    return nil, "corrupt protobuf at position " .. pos
  else
    local msg
    while currentpos <= fieldend do
      currentpos, msg = load_array_field_data( str, currentpos, fieldend, info, obj )
      if currentpos == nil then return nil, msg end
    end
  end
  return fieldend+1
end


local function load_field_data( str, pos, endpos, info, obj )
  local val, fieldend = info.loader( str, pos, endpos )
  if val == nil then
    if fieldend ~= nil then
      return nil, fieldend
    end
    return nil, "corrupt protobuf at position " .. pos
  end
  if info.mapper then val = info.mapper[ val ] end
  if val ~= nil then
    if info.is_usertype and obj[ info.name ] ~= nil then
      obj[ info.name ]:merge( val )
    else
      obj[ info.name ] = val
    end
  else
    return nil, "unknown value in protobuf at position " .. pos
  end
  return fieldend+1
end


function generic_check( types, val, ... )
  if val ~= nil then
    for k,v in next, types, nil do   -- avoid pairs()
      local t = type( val[ k ] )
      if t ~= v then
        return nil, "wrong type for field `" .. k .. "': " .. t
      end
    end
  end
  return val, ...
end


function generic_load( s, pos, endpos, metadata, obj )
  pos = pos or 1
  endpos = endpos or #s
  while pos <= endpos do
    local tag, wt, keyend = proto.load_key( s, pos, endpos )
    if tag == nil then
      return nil, "no valid key in protobuf at position " .. pos
    end
    local info, msg = metadata[ tag ], nil
    if info == nil then -- unknown field
      pos, msg = skip_and_store( obj, s, pos, keyend+1, endpos, wt )
      if pos == nil then return nil, msg end
    else -- we know what to do with the following field
      if info.is_packed then
        if 2 ~= wt and info.wire_type ~= wt then -- wire type mismatch
          pos, msg = skip_and_store( obj, s, pos, keyend+1, endpos, wt )
          if pos == nil then return nil, msg end
        elseif 2 == wt then -- normal case for packed repeated values
          pos, msg = load_packed_field_data( s, keyend+1, endpos, info, obj )
          if pos == nil then return nil, msg end
        else -- compatibility with normal repeated values
          pos, msg = load_array_field_data( s, keyend+1, endpos, info, obj )
          if pos == nil then return nil, msg end
        end
      else -- not packed
        if info.wire_type ~= wt then -- wire type mismatch
          pos, msg = skip_and_store( obj, s, pos, keyend+1, endpos, wt )
          if pos == nil then return nil, msg end
        elseif info.is_repeated then
          pos, msg = load_array_field_data( s, keyend+1, endpos, info, obj )
          if pos == nil then return nil, msg end
        else
          pos, msg = load_field_data( s, keyend+1, endpos, info, obj )
          if pos == nil then return nil, msg end
        end
      end
    end
  end
  return obj, pos-1
end

-- return factory function for this module
return function( id )
  return assert( class_registry[ id ],
                 "message type `" .. tostring( id ) .. "' not found" )
end

