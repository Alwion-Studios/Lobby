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
local Janitor = require(packages.Janitor)

local topBar = require(game:GetService("ReplicatedStorage").Topbar)

local Icon = {}
Icon.__index = Icon

function Icon.New()
    local self = setmetatable({}, Icon)
    self.Janitor = Janitor.new()
    self.Instance = topBar.new()
    
    return self
end 

return Icon