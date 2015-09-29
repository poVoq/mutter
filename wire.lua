local w = {}


-- This needs to be heavily optimized or find a C lib to do this.

local function toMSB(bytes,value)
  local str = ""
  for j=1,bytes do
     str = str .. string.char(value % 256)
     value = math.floor(value / 256)
  end
  return string.reverse(str)
end


function w.toMSB16(value) return toMSB(2,value) end
function w.toMSB32(value) return toMSB(4,value) end

-- function w.toMSB16(value)
--      return string.char(math.floor(value/256))..string.char(value % 256)
-- end

-- function w.toMSB32(value) return toMSB(4,value) end

function w.from_MSB16(s)
   return s:byte(2) + (s:byte(1)*256)
end
function w.from_MSB32(s)
   return s:byte(4) + (s:byte(3)*256) + 
      (s:byte(2)*65536) + (s:byte(1)*16777216)
end

function w.make_packet(typ,data)
   local len = data:len()
   return w.toMSB16(typ) .. w.toMSB32(len) .. data
end

function timer(cnt,f,...)
   local t1 = os.clock()
   for i=1,cnt do
      f(...)
   end
   local t2 = os.clock()
   return  os.difftime(t2, t1)
end

return w
