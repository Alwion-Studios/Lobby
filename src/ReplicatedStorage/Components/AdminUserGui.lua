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

--Player
local Players = game:GetService("Players")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--UIs
local PlayerItm = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("PlayerDet");
local PlayerItmEXP = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("PlayerDetEXP");

local formatter = "%02i"

local AdminUserGui = {}
AdminUserGui.__index = AdminUserGui

function AdminUserGui.New(userId, toStoreIn)
    local self = setmetatable({}, AdminUserGui)

    self.Storage = toStoreIn
    self.Janitor = Janitor
    self.UserId = userId
    self.IsExpanded = false
    self.reasonsAdded = false
    self.GUI = self:CreateGui()
    
    return self
end

function AdminUserGui:CreateGui()
    local MS = Knit.GetService("ModerationService")
    local newItm = PlayerItmEXP:Clone()

    self:CloseGlanceView(newItm)
    newItm.Content.Glance.Player.Image = Players:GetUserThumbnailAsync(self.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    newItm.Content.Glance.Username.Text = Players:GetNameFromUserIdAsync(self.UserId)
    newItm.Parent = self.Storage
    newItm.Name = self.UserId

    newItm.ActivateFullView.MouseButton1Click:Connect(function() 
        if not self.IsExpanded then
            if self.reasonsAdded == true then return self:OpenGlanceView(newItm) end

            MS:GetBan(self.UserId):andThen(function(res)
                print(res)
                local expiryString = "31/12/9999 @ 23:59"

                if res["expiryDate"] ~= true and res["expiryDate"] ~= false then
                    local date = os.date("*t", res["expiryDate"])
                    expiryString = (
                        formatter:format(date.day).. "/" ..
                        formatter:format(date.month).. "/" ..
                        formatter:format(date.year) .. " @ ".. 
                        formatter:format(date.hour).. ":" ..
                        formatter:format(date.min)
                    )
                end

                newItm.Content.ModDetails.ExpiryDate.Text = expiryString
                newItm.Content.ModDetails.Reason.Text = res["reason"]

                self:OpenGlanceView(newItm)
                self.reasonsAdded = true
            end)
        else
            self:CloseGlanceView(newItm)
        end
    end)

    return newItm
end

function AdminUserGui:OpenGlanceView(gui)
    self.IsExpanded = true
    gui.Content.ModDetails.Size = UDim2.new(1,0,0.5,-4)
    gui.Content.Glance.Size = UDim2.new(1,0,0.5,0)
    gui.Size = UDim2.new(1,0,0,100)
    gui.Content.ModDetails.ExpiryDate.TextTransparency = 0
    gui.Content.ModDetails.Reason.TextTransparency = 0
end

function AdminUserGui:CloseGlanceView(gui)
    self.IsExpanded = false
    gui.Content.ModDetails.Size = UDim2.new(0,0,0,0)
    gui.Content.Glance.Size = UDim2.new(1,0,1,0)
    gui.Size = UDim2.new(1,0,0,50)
    gui.Content.ModDetails.ExpiryDate.TextTransparency = 1
    gui.Content.ModDetails.Reason.TextTransparency = 1
end


function AdminUserGui:Destroy()
    self.GUI:Destroy()
    self = nil
end

return AdminUserGui