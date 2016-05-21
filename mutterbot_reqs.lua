local crypto = require'crypto'
local rand = require'randbytes'

local mutter_req = {
   ["genpass"] = function (cfg,req)
      local pass = crypto.hex(rand(4))
      cfg.userpassword = pass
      return("User Password is "..pass)
   end,
   ["welcome"] = function (cfg,req,p1)
      cfg.welcome_text = p1
      return("Welcome text is set to:"..p1)
   end,
   ["unknown-request"] = function (cfg,req)
      return("Huh? "..req)
   end
}

return mutter_req
