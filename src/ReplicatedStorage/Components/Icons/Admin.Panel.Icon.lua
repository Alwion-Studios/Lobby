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
local packages = game:GetService("ReplicatedStorage").Packages
local Knit = require(packages.Knit)
local AdminGuiController = Knit.GetController("AdminGuiController")

local Icon = Base.New().Instance
    :setProperty("deselectWhenOtherIconSelected", false)
    :bindToggleKey(Enum.KeyCode.V)
    :setLabel("Admin")
    :bindEvent("selected", function(ico)
        AdminGuiController:OpenUI()
    end)
    :bindEvent("deselected", function(ico)
        AdminGuiController:CloseUI()
    end)

return Icon