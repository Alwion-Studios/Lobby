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
local StarterGui = game:GetService("StarterGui")

local NotificationController = Knit.CreateController {
    Name = "NotificationController";
}

function NotificationController:KnitStart()
    local NotificationService = Knit.GetService("NotificationService")

    NotificationService.SendNotificationToClient:Connect(function(title, description, callback)
        if not title or not description then return false end

        if callback then
            return StarterGui:SetCore("SendNotification", {
                Title=title,
                Text=description,
                Callback=callback,
            })
        end

        return StarterGui:SetCore("SendNotification", {
            Title=title,
            Text=description,
        })
    end)
end

return NotificationController