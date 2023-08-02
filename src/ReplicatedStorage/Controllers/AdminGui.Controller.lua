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

local AdminGuiController = Knit.CreateController {
    Name = "AdminGuiController";
    CurrentPage = nil;
}

function AdminGuiController:TabChange()
end

function AdminGuiController:OpenUI() 
    if self.CurrentPage == nil then self.CurrentPage = "Bans" end
end

function AdminGuiController:CloseUI() 
    
end

return AdminGuiController