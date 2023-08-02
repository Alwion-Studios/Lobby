--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by Marshmelly. All Rights Reserved.
Contact me at Marshmelly#0001 if any issues arise.

]]

--Imports
local packages = game:GetService("ReplicatedStorage").Packages
local Knit = require(packages.Knit)

--Game Icons
local adminIco

local GuiController = Knit.CreateController {
    Name = "GuiController";
}

function GuiController:Configure()
    adminIco = require(script.Parent.Parent.Components.Icons["Admin.Panel.Icon"])
end

function GuiController:KnitStart()
    self:Configure()
end

return GuiController