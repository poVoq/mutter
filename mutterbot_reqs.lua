local crypto = require'crypto'
local rand = require'randbytes'

local mutter_req = {
   ["genpass"] = {help="Generate a unique password for all users.",
		  func = function (self,cfg,req)
		     local pass = crypto.hex(rand(4))
		     cfg.userpassword = pass
		     return("User Password is "..pass)
		  end
   },
   ["welcome"] = {help="Set a new welcome message.",
		  func = function (self,cfg,req,p1)
		     cfg.welcome_text = p1
		     return("Welcome text is set to:"..p1)
		  end
   },
   ["unknown-request"] = {
      func = function (self,cfg)
	 local msg = "Huh?<br/>"
	 for n,h in pairs(self) do
	    if h.help then
	       msg = msg .. "<bold>"..n .. "</bold> - " .. h.help .. "<br/>"
	    end
	 end
	 return(msg)
      end
   }
}

return mutter_req
