--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by Marshmelly. All Rights Reserved.
Contact me at Marshmelly#0001 if any issues arise.

]]

--Imports
local RS = game:GetService("ReplicatedStorage")
local packages = RS.Packages
local Knit = require(packages.Knit)
local Janitor = require(packages.Janitor)

--Main Object
local Player = {}
Player.__index = Player

--Code
local function deployFile(file, player)
    return require(file).New(player)
end


function Player.New() 
    local self = {}

    self.Player = nil
    self.Store = {}
    self.Janitor = Janitor.new()

    return setmetatable(self, Player)
end

function Player:Destroy()
    print("Destroying Player")
    self = nil
end

return Player