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
local HoldUI = PlayerGui:WaitForChild("MellyCore"):WaitForChild("Hold")
local ServerGuiToUse = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("Server")
local PortraitGuiToUse = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("Player")
local List = HoldUI:WaitForChild("ServerList"):WaitForChild("List")

local Server = {}
Server.__index = Server

function Server.New(name, serverId, uptime, players, version)
    if not name or not serverId or not uptime or not players then return false end

    local self = setmetatable({}, Server)

    self.Janitor = Janitor
    self.Name = name
    self.serverId = serverId
    self.Uptime = uptime
    self.Version = version
    self.Players = players
    self.PlayerCount = #players

    self.GUI = self:CreateGui()

    return self
end

function Server:PlayerPortraits(userIds, frame)
    local PlayersList = frame:WaitForChild("Right"):WaitForChild("Players")
    
    --Destroy all Portraits
    for _, portrait in pairs(PlayersList:GetChildren()) do
        if not portrait:IsA("ImageLabel") then continue end
        portrait:Destroy()
    end

    for x, id in pairs(userIds) do
        local newPortrait = PortraitGuiToUse:Clone()
        newPortrait.Image = Players:GetUserThumbnailAsync(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        newPortrait.Name = tostring(x)
        newPortrait.ZIndex = x
        newPortrait.Parent = PlayersList
    end
end

function Server:CreateGui()
    local TS = Knit.GetService("TeleportService")
    local newGUI = ServerGuiToUse:Clone()

    newGUI:WaitForChild("Left").NameOfServer.Text = self.Name or self.JoinId
    newGUI:WaitForChild("Left"):WaitForChild("ServerInfo").PlayerCount.Text = self.PlayerCount.. " / ".. "20" or "0 / 0"
    newGUI:WaitForChild("Left"):WaitForChild("ServerInfo").Version.Text = self.Version or "1.0"
    
    newGUI:WaitForChild("Right").ServerJoin:SetAttribute("serverID", self.serverId)
    newGUI:WaitForChild("Right").ServerJoin:SetAttribute("serverType", "public")

    --Set the Uptime Counter
    --[[task.spawn(function() --Uptime Counter
        repeat wait(1)
            uptime += 1
            newGUI:WaitForChild("Left"):WaitForChild("ServerInfo").Uptime.Text = hms(uptime)
        until false
    end)]]

    --Add Players
    self:PlayerPortraits(self.Players, newGUI)

    --Join Button
    newGUI:WaitForChild("Right").ServerJoin.MouseButton1Click:Connect(function()
        TS:TeleportRequestToInstance(newGUI.Right.ServerJoin:GetAttribute("serverID"), newGUI.Right.ServerJoin:GetAttribute("serverType"))
    end)

    newGUI.Parent = List

    return newGUI
end

function Server:Destroy()
    self.GUI:Destroy()
    self = nil
end

return Server