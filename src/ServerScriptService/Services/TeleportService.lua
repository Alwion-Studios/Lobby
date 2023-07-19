--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by Marshmelly. All Rights Reserved.
Contact me at Marshmelly#0001 if any issues arise.

]]
--ROBLOX Service Calls

--Imports
local packages = game:GetService("ReplicatedStorage").Packages
local Knit = require(packages.Knit)
local TS = game:GetService("TeleportService")

local TeleportService = Knit.CreateService {
    Name = "TeleportService";
    ApprovedServers = {
        14105573507 --Melly's V1
    },
    LatestServer = 14105573507 -- Melly's V1
}

function checkPermissions(player, groupId, rankId)
    return player:GetRankInGroup(groupId) >= rankId or false
end

function TeleportService.Client:TeleportRequestToInstance(player, id, serverType)
    if not checkPermissions(player, 12523090, 99) then return false end
    if serverType ~= "public" then return false end
    TS:TeleportToPlaceInstance(self.Server.LatestServer, id, player)
end

function TeleportService.Client:TeleportRequest(player)
    if not checkPermissions(player, 12523090, 99) then return false end
    TS:TeleportAsync(self.Server.LatestServer, {player})
end

return TeleportService