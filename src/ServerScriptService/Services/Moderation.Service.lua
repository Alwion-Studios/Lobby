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

--MDS
local moderationDS = require(script.Parent.Parent.Components.MDS.System.Moderation)

local ModerationService = Knit.CreateService {
    Name = "ModerationService";
    Client = {};
    Moderators = {
        Users = {
            2636513511
        };
        Groups = {
            [12523090] = 10;
        };
    };
    DataStore = moderationDS.New()
}

function ModerationService:CheckStatus(plr)
    if self.Moderators.Users[plr.UserId] then return true end
    
    for groupId, rankRequired in pairs(self.Moderators.Groups) do 
        if plr:IsInGroup(groupId) and plr:GetRankInGroup(groupId) >= rankRequired then return true end
    end

    return false
end

function ModerationService.Client:GetBans(plr) 
    if not self.Server:CheckStatus(plr) then return false end

    self.DataStore:GetAsync(self.Player.UserId)
end

function ModerationService.Client:GetMutes(plr) 
    if not self.Server:CheckStatus(plr) then return false end
end

function ModerationService.Client:RequestBan(plr) 
    if not self.Server:CheckStatus(plr) then return false end
end

function ModerationService.Client:RequestMute(plr) 
    if not self.Server:CheckStatus(plr) then return false end
end

--[[function NotificationService:KnitStart()

end]]

return ModerationService