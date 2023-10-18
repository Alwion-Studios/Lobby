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
end

return PlayerService