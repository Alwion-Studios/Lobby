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

--Player Information
local User = Player.PlayerGui:WaitForChild("MellyCore"):WaitForChild("User")

--Server List
local Buttons = HoldUI:WaitForChild("Buttons")
local List = HoldUI:WaitForChild("ServerList"):WaitForChild("List")
local Options = HoldUI:WaitForChild("ServerList"):WaitForChild("Options")

--Server Object
local serverObj = require(script.Parent.Parent.Components.ServerGui)

local ServerController = Knit.CreateController {
    Name = "ServerController";
    ServerGuis = {},
    ServerGuiToUse = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("Server"),
    PortraitGuiToUse = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("Player")
}

local function hms(seconds)
	return string.format("%02i:%02i:%02i", seconds/60^2, seconds/60%60, seconds%60)
end

function ServerController:ServerChange(data)
    if typeof(data) ~= "table" or #data < 0 then return false end

    if not self.ServerGuis[data["serverId"]] then 
        self.ServerGuis[data["serverId"]] = serverObj.New(data["name"], data["serverId"], data["uptime"], data["players"], data["version"])
    end

	if not data["players"] or #data["players"] <= 0 then return self:DeleteServer(data["serverId"]) end

    local id = data["serverId"]

    --Set Player Count
    self.ServerGuis[id].GUI:WaitForChild("Left"):WaitForChild("ServerInfo").PlayerCount.Text = #data["players"].. " / ".. "20"

    --Set Player Portraits
    self.ServerGuis[id]:PlayerPortraits(data["players"], self.ServerGuis[id].GUI)
end

function ServerController:DeleteServer(id)
    if not self.ServerGuis[id] then return false end

    self.ServerGuis[id]:Destroy()
    self.ServerGuis[id] = nil

    return true
end

function ServerController:Refresh()
    local ServerService = Knit.GetService("ServerService")

    for id, renderedServer in pairs(self.ServerGuis) do
        renderedServer:Destroy()
        self.ServerGuis[id] = nil
    end

    ServerService:GetAllServers():andThen(function(value)
        for _, openServer in pairs(value) do
            self:ServerChange(openServer)
        end
    end)
end

function ServerController:KnitStart()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    local playerscripts = Player.PlayerScripts
    local playermodule = require(playerscripts:WaitForChild("PlayerModule"))
    local controls = playermodule:GetControls()
    controls:Disable()

    --Configure User Info
    User:WaitForChild("Avatar").Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    User:WaitForChild("Details").Username.Text = Player.Name
    User:WaitForChild("Details").Rank.Text = Player:GetRoleInGroup(12523090)

    local ServerService = Knit.GetService("ServerService")

    Options:WaitForChild("Right").Refresh.MouseButton1Click:Connect(function()
        self:Refresh()
    end)

    Buttons.PlayButton.MouseButton1Click:Connect(function()
        local teleportService = Knit.GetService("TeleportService")
        teleportService:TeleportRequest()
    end)

    ServerService.CreateServer:Fire("test", "test")

    ServerService.ServerChanged:Connect(function(data) 
        self:ServerChange(data)
    end)

    ServerService.RefreshServers:Connect(function() 
        self:Refresh()
    end)

    wait(4)
    self:Refresh()

    task.spawn(function() --Refresh
        repeat wait(20)
            self:Refresh()
        until false
    end)
end

return ServerController