--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by Marshmelly. All Rights Reserved.
Contact me at Marshmelly#0001 if any issues arise.

]]
--Imports
local Base = require(script.Parent.Base)

local Icon = Base.New().Instance
    :setProperty("deselectWhenOtherIconSelected", false)
    :bindToggleKey(Enum.KeyCode.V)
    :setLabel("Admin")
    :bindEvent("selected", function(ico)

    end)
    :bindEvent("deselected", function(ico)
        
    end)

return Icon