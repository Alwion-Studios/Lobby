--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by Marshmelly. All Rights Reserved.
Contact me at Marshmelly#0001 if any issues arise.

]]
--ROBLOX Service Calls
local PS = game:GetService("Players")

--Imports
local packages = game:GetService("ReplicatedStorage").Packages
local Knit = require(packages.Knit)

--Datastore Test
local base = require(game:GetService("ServerScriptService").Components.Player)

local PlayerService = Knit.CreateService {
    Name = "PlayerService";
    Client = {};
    PlayerObjects = { };
}

function PlayerService:KnitStart()
    local ServerService = Knit.GetService("ServerService")
    PS.PlayerAdded:Connect(function(plr) 
        local newPlr = base.New()

        newPlr:SetPlayer(plr)
        newPlr:SetDataStore()

        self.PlayerObjects[plr.UserId] = newPlr
    end)

    PS.PlayerRemoving:Connect(function(plr)
        ServerService:UploadToIndex()
        if not self.PlayerObjects[plr.UserId] then return false end
        local leavingPlr = self.PlayerObjects[plr.UserId]

        leavingPlr:SaveDataStoreAndScrap()
        leavingPlr:Destroy()
    end)
end

return PlayerService