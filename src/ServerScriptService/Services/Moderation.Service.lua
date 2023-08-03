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
local bansDS = require(script.Parent.Parent.Components.MDS.System.ActiveBans)
local mutesDS = require(script.Parent.Parent.Components.MDS.System.ActiveMutes)

local ModerationService = Knit.CreateService {
    Name = "ModerationService";
    Client = {};
    Moderators = {
        Users = {
            2636513511
        };
        Groups = {
            [32862712] = 1;
        };
    };
    BansDataStore = bansDS.New();
    mutesDS = mutesDS.New();
    pageObj = nil;
}

function pagesToTbl(pages)
    local items = {}
    while true do
        table.insert(items, pages:GetCurrentPage())
        if pages.IsFinished then break end
        pages:AdvanceToNextPageAsync()
    end
    return items
end

function ModerationService:CheckStatus(plr)
    if self.Moderators.Users[plr.UserId] then return true end
    
    for groupId, rankRequired in pairs(self.Moderators.Groups) do 
        if plr:IsInGroup(groupId) and plr:GetRankInGroup(groupId) >= rankRequired then return true end
    end

    return false
end

function ModerationService:ValidateBan(plr, targetedPlr, reason, expiryDate)
    if not self:CheckStatus(plr) then return false end

    for _, id in pairs(targetedPlr) do
        local targetedPlrEmulatedPlayer = {["UserId"] = id, ["Name"]="BAN"}
        self.BansDataStore:Action(targetedPlrEmulatedPlayer, reason, expiryDate, plr.UserId)
        print("Banned ".. id.. " for ".. reason)
    end
end

function ModerationService:ValidateBanRemoval(plr, targetedPlr, reason)
    if plr == "server" or self:CheckStatus(plr) then self.BansDataStore:RemovalAction(targetedPlr, reason) end
    
    print("Removed ".. targetedPlr.Name.. "'s ban")

    return false
end

function ModerationService:ValidateMute(plr, targetedPlr, reason, expiryDate)
    if not self:CheckStatus(plr) then return false end

    local targetedPlrEmulatedPlayer = {["UserId"] = targetedPlr, ["Name"]="BAN"}
    self.mutesDS:Action(targetedPlrEmulatedPlayer, reason, expiryDate, plr.UserId)
end

function ModerationService:GetBans(plr, page)
    if not self:CheckStatus(plr) then return false end

    local listSuccess, pages = pcall(function()
        local contents = pagesToTbl(self.pageObj)
        local maxPageNum = #contents

        if page > maxPageNum or not contents[page] then return false end

        local toReturn = {}
        for _, itm in pairs(contents[page]) do
            table.insert(toReturn, {["userId"]=itm.KeyName})
        end
        return toReturn
    end)

    print(pages)
    return pages or false
end

function ModerationService:GetAllBans(plr)
    if not self:CheckStatus(plr) then return false end
    local listSuccess, pages = pcall(function()
        local contents = pagesToTbl(self.pageObj)
        local toReturn = {}

        for x,page in pairs(contents) do
            toReturn[x] = {}
            for y,item in pairs(page) do
                table.insert(toReturn[x], item.KeyName)
            end
        end
        
        return toReturn
    end)
    return pages or false
end

function ModerationService:GetBan(targetID)
    return self.BansDataStore.DataStore:GetAsync(targetID) or nil
end

function ModerationService.Client:GetBans(plr, page) 
    return self.Server:GetBans(plr, page)
end

function ModerationService.Client:GetAllBans(plr, page) 
    return self.Server:GetAllBans(plr)
end

function ModerationService:GetMutes(plr)
    if not self:CheckStatus(plr) then return false end
end

function ModerationService.Client:GetMutes(plr) 
    return self.Server:GetMutes(plr)
end

function ModerationService.Client:RequestBan(plr, targetedPlr, reason, expiryDate) 
    return self.Server:ValidateBan(plr, targetedPlr, reason, expiryDate)
end

function ModerationService.Client:RequestMute(plr, targetedPlr, reason, expiryDate) 
    return self.Server:ValidateMute(plr, targetedPlr, reason, expiryDate)
end

function ModerationService:KnitStart()
    self.pageObj = self.BansDataStore.DataStore:ListKeysAsync("",10)
end

return ModerationService