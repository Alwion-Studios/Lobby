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
local Players = game:GetService("Players")

--Player
local Player = Players.LocalPlayer

--UIs
local HoldUI = Player.PlayerGui:WaitForChild("MellyCore"):WaitForChild("Hold")

--Ban GUI Information
local ModeratedUI = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("Notice")

--Game Icons
local adminIco = nil

local GuiController = Knit.CreateController {
    Name = "GuiController";
    isBanned = false;
}

local formatter = "%02i"

function GuiController:Configure()
    adminIco = require(script.Parent.Parent.Components.Icons["Admin.Panel.Icon"])
end

function GuiController:KnitStart()
    local PlayerService = Knit.GetService("PlayerService")

    self:Configure()
    PlayerService.BannedUser:Connect(function(reason, expiryDate, responsibleMod) 
        local expiryString = "31/12/9999 @ 23:59"

        if expiryDate ~= true and expiryDate ~= false then
            local date = os.date("*t", expiryDate)
            expiryString = (
            formatter:format(date.day).. "/" ..
            formatter:format(date.month).. "/" ..
            formatter:format(date.year) .. " @ ".. 
            formatter:format(date.hour).. ":" ..
            formatter:format(date.min)
            )
        end

        for _, ui in pairs(HoldUI:GetDescendants()) do
            ui:Destroy()
        end

        local modUI = ModeratedUI:Clone()
        modUI:WaitForChild("DetailsHolder"):WaitForChild("Reason").Text = reason
        modUI:WaitForChild("DetailsHolder"):WaitForChild("Details").ResponsibleMod.Text = ("Issued By: ".. Players:GetNameFromUserIdAsync(responsibleMod))
        modUI:WaitForChild("DetailsHolder"):WaitForChild("Details").ExpiryDate.Text = ("Expires: ".. expiryString)
        modUI.Parent = HoldUI

        --Disable Topbar
        adminIco:setEnabled(false)
        adminIco:deselect()
    end)
end

return GuiController