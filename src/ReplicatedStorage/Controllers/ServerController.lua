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
local StarterGui = game:GetService('StarterGui')

--Player
local Player = Players.LocalPlayer

--UIs
local HoldUI = Player.PlayerGui:WaitForChild("MellyCore"):WaitForChild("Hold")
local Buttons = HoldUI:WaitForChild("Buttons")
local List = HoldUI:WaitForChild("ServerList"):WaitForChild("List")

local ServerController = Knit.CreateController {
    Name = "ServerController";
    ServerGuis = {},
    ServerGuiToUse = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("Server"),
    PortraitGuiToUse = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("Player")
}

local function hms(seconds)
	return string.format("%02i:%02i:%02i", seconds/60^2, seconds/60%60, seconds%60)
end

function ServerController:CreateServerGui(data)
    if not data["players"] or #data["players"] <= 0 then return self:DeleteServer(data["serverId"]) end

    local uptime = data["uptime"]
    local TS = Knit.GetService("TeleportService")
    local newGUI = self.ServerGuiToUse:Clone()
    newGUI:WaitForChild("Left").NameOfServer.Text = data["name"] or data["serverId"]
    newGUI:WaitForChild("Left"):WaitForChild("ServerInfo").PlayerCount.Text = #data["players"].. " / ".. "20" or "0 / 0"
    newGUI:WaitForChild("Left"):WaitForChild("ServerInfo").Version.Text = data["version"] or "1.0"
    
    newGUI:WaitForChild("Right").ServerJoin:SetAttribute("serverID", data["serverId"])
    newGUI:WaitForChild("Right").ServerJoin:SetAttribute("serverType", "public")

    --Set the Uptime Counter
    task.spawn(function() --Uptime Counter
        repeat wait(1)
            uptime += 1
            newGUI:WaitForChild("Left"):WaitForChild("ServerInfo").Uptime.Text = hms(uptime)
        until false
    end)

    --Add to Collection
    self.ServerGuis[data["serverId"]] = newGUI

    --Add Players
    self:PlayerPortraits(data["players"], newGUI)

    --Join Button
    newGUI:WaitForChild("Right").ServerJoin.MouseButton1Click:Connect(function()
        TS:TeleportRequestToInstance(newGUI.Right.ServerJoin:GetAttribute("serverID"), newGUI.Right.ServerJoin:GetAttribute("serverType"))
    end)

    --Display
    newGUI.Parent = List
end

function ServerController:PlayerPortraits(userIds, frame)
    local PlayersList = frame:WaitForChild("Right"):WaitForChild("Players")
    
    --Destroy all Portraits
    for _, portrait in pairs(PlayersList:GetChildren()) do
        if not portrait:IsA("ImageLabel") then continue end
        portrait:Destroy()
    end

    for x, id in pairs(userIds) do
        local newPortrait = self.PortraitGuiToUse:Clone()
        newPortrait.Image = Players:GetUserThumbnailAsync(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        newPortrait.Name = tostring(x)
        newPortrait.ZIndex = x
        newPortrait.Parent = PlayersList
    end
end

function ServerController:ServerChange(data)
    local id = data["serverId"]
    if not self.ServerGuis[id] then return self:CreateServerGui(data) end
	if not data["players"] or #data["players"] <= 0 then return self:DeleteServer(id) end

    --Set Player Count
    self.ServerGuis[id]:WaitForChild("Left"):WaitForChild("ServerInfo").PlayerCount.Text = #data["players"].. " / ".. "20"

    --Set Player Portraits
    self:PlayerPortraits(data["players"], self.ServerGuis[id])
end

function ServerController:DeleteServer(id)
    if not self.ServerGuis[id] then return false end

    self.ServerGuis[id]:Destroy()
    self.ServerGuis[id] = nil

    return true
end

function ServerController:KnitInit()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    local playerscripts = Player.PlayerScripts
    local playermodule = require(playerscripts:WaitForChild("PlayerModule"))
    local controls = playermodule:GetControls()
    controls:Disable()

    local ServerService = Knit.GetService("ServerService")

    Buttons.PlayButton.MouseButton1Click:Connect(function()
        local teleportService = Knit.GetService("TeleportService")
        teleportService:TeleportRequest()
    end)

    ServerService.CreateServer:Fire("test", "test")

    ServerService.ServerChanged:Connect(function(data) 
        self:ServerChange(data)
    end)

    ServerService.RefreshServers:Connect(function(data) 
        self:ServerChange(data)
    end)
end

return ServerController