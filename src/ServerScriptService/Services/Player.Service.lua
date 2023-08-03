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
    Client = {
        BannedUser = Knit.CreateSignal();
        UserIsAdmin = Knit.CreateSignal()
    };
    PlayerObjects = {};
}

function PlayerService:KnitStart()
    local SS = Knit.GetService("ServerService")
    local MS = Knit.GetService("ModerationService")

    PS.PlayerAdded:Connect(function(plr) 
        local userBanDetails = MS:GetBan(plr.UserId)
        print(userBanDetails)
        if userBanDetails and userBanDetails["reason"] then
            if userBanDetails["expiryDate"] == true or userBanDetails["expiryDate"] == false or userBanDetails["expiryDate"] > os.time() then 
                self.Client.BannedUser:Fire(plr, userBanDetails["reason"], userBanDetails["expiryDate"], userBanDetails["responsibleMod"]) 
                return true 
            end

            MS:ValidateBanRemoval("server", plr, "expired")
        end

        local newPlr = base.New()

        newPlr:SetPlayer(plr)
        newPlr:SetDataStore()

        --MS:ValidateBan(plr, {3904628706, 119928277, 2785616570, 3340003283, 2527755169, 1653758893}, "Blacklisted", true)
        --MS:ValidateBan(plr, {plr.UserId}, "Blacklisted", true)
        --MS:ValidateBanRemoval("server", plr, "expired")
        --MS:GetBans(plr, 1)

        if MS:CheckStatus(plr) then
            self.Client.UserIsAdmin:Fire(plr)
        end

        self.PlayerObjects[plr.UserId] = newPlr
    end)

    PS.PlayerRemoving:Connect(function(plr)
        SS:UploadToIndex()
        if not self.PlayerObjects[plr.UserId] then return false end
        local leavingPlr = self.PlayerObjects[plr.UserId]

        leavingPlr:SaveDataStoreAndScrap()
        leavingPlr:Destroy()
    end)
end

return PlayerService