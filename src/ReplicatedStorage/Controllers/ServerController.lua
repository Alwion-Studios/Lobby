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
local Buttons = HoldUI:WaitForChild("Buttons")
local List = HoldUI:WaitForChild("ServerList"):WaitForChild("List")

local ServerController = Knit.CreateController {
    Name = "ServerController";
    ServerGuis = {},
    ServerGuiToUse = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("Server"),
    PortraitGuiToUse = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("Player")
}

function ServerController:CreateServerGui(data)
    local newGUI = self.ServerGuiToUse:Clone()
    newGUI.Left.NameOfServer.Text = data["serverId"]
    newGUI.Left.PlayerCount.Text = #data["players"].. " / ".. "20"
    
    --Add to Collection
    self.ServerGuis[data["serverId"]] = newGUI

    --Add Players
    self:PlayerPortraits(data["players"], newGUI)

    --Display
    newGUI.Parent = List
end

function ServerController:PlayerPortraits(userIds, frame)
    local PlayersList = frame:WaitForChild("Right"):WaitForChild("Players")
    
    --Destroy all Portraits
    for _, portrait in pairs(PlayersList:GetChildren()) do
        portrait:Destroy()
    end

    for _, id in pairs(userIds) do
        local newPortrait = self.PortraitGuiToUse:Clone()
        newPortrait.Image = Players:GetUserThumbnailAsync(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        newPortrait.Parent = PlayersList
    end
end

function ServerController:ServerChange(data)
    local id = data["serverId"]
    if not self.ServerGuis[id] then return self:CreateServerGui(data) end

    --Set Player Count
    self.ServerGuis[id].Left.PlayerCount.Text = #data["players"].. " / ".. "20"

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
    local ServerService = Knit.GetService("ServerService")

    Buttons.PlayButton.MouseButton1Click:Connect(function()
        local teleportService = Knit.GetService("TeleportService")
        teleportService:TeleportRequest()
    end)

    ServerService.CreateServer:Fire("test", "test")
    ServerService.ServerChanged:Connect(function(data) 
        self:ServerChange(data)
    end)

    ServerService.ServerDeleted:Connect(function(data) 
        self:DeleteServer(data["serverId"])
    end)
end

return ServerController