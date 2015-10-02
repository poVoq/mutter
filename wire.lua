local w = {}

local bit=require'bit'
local rshift,lshift,bor,band = bit.rshift,bit.lshift,bit.bor,bit.band

function w.toMSB16(value)
   return string.char(rshift(value,8))..string.char(band(value,0xff))
end
function w.toMSB32(value)
   return string.char(band(rshift(value,24),0xff))..
      string.char(band(rshift(value,16),0xff))..
      string.char(band(rshift(value,8),0xff))..
      string.char(band(value,0xff))
end


function w.from_MSB16(s)
   return bor(s:byte(2),lshift(s:byte(1),8))
end
function w.from_MSB32(s)
   return bor(s:byte(4), lshift(s:byte(3),8),
	      lshift(s:byte(2),16),lshift(s:byte(1),24))
end

function w.make_packet(typ,data)
   local len = #data
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
