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

local NotificationService = Knit.CreateService {
    Name = "NotificationService";
    Client = {
        SendNotificationToClient = Knit.CreateSignal();
    };
}

function NotificationService:RequestNotification(receiver: player, title: string, description: string, callback)
    if not receiver or not title or not description then return false end
    self.Client.SendNotificationToClient:Fire(receiver, title, description, callback or nil)
end

--[[function NotificationService:KnitStart()

end]]

return NotificationService