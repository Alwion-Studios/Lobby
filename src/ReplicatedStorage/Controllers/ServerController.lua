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
local SearchBox = Options:WaitForChild("Left").SearchInput

--Random
local isSearching = false

--Server Object
local serverObj = require(script.Parent.Parent.Components.ServerGui)

local ServerController = Knit.CreateController {
    Name = "ServerController";
    OpenServers = {},
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

    self.OpenServers[id] = nil
    self.ServerGuis[id]:Destroy()
    self.ServerGuis[id] = nil

    return true
end

function ServerController:Refresh(tbl)
    local ServerService = Knit.GetService("ServerService")

    if isSearching and tbl and typeof(tbl) == "table" then

        for id, _ in pairs(self.ServerGuis) do
            if tbl[id] then continue end
            self:DeleteServer(id)
        end

        for id, openServer in pairs(tbl) do
            if not self.OpenServers[id] then continue end
            self:ServerChange(self.OpenServers[id])
        end
        return
    end

    for id, _ in pairs(self.ServerGuis) do
        self:DeleteServer(id)
    end
    
    ServerService:GetAllServers():andThen(function(value)
        for _, openServer in pairs(value) do
            self.OpenServers[openServer["serverId"]] = openServer
            self:ServerChange(openServer)
        end
    end)
end

function ServerController:Search(input)
    local isMatch = {}
    local hasBeenFound = nil

    if #input <= 0 then 
        isSearching = false
        self:Refresh()
        return nil
    end

    for id, server in pairs(self.ServerGuis) do
        if id == input then
            hasBeenFound = id
        end

        isSearching = true
        local str = server.Name

        for x=1, #str do
            local char=str:sub(x,x)
            for y=1, #input do
                local inputChar = input:sub(y,y)
                if inputChar ~= char 
                   or y > #str+1 
                   or input == str
                then continue end
                isMatch[id] = server
            end
        end
    end

    if hasBeenFound then 
        local tbl = {}
        tbl[hasBeenFound] = self.OpenServers[hasBeenFound]
        return self:Refresh(tbl) 
    end
    self:Refresh(isMatch)
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
        isSearching = false
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

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        if #SearchBox.Text < 1 then 
            isSearching = false 
            self:Refresh()
            return false 
        end

        self:Search(SearchBox.Text)
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