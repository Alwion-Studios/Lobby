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

--Player
local Player = game.Players.LocalPlayer

--UIs
local HoldUI = Player.PlayerGui:WaitForChild("MellyCore"):WaitForChild("Hold")
local Buttons = HoldUI:WaitForChild("Buttons")
local List = HoldUI:WaitForChild("ServerList")

local ServerController = Knit.CreateController {
    Name = "ServerController";
    ServerGuis = {},
    ServerGuiToUse = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("Server")
}

function ServerController:CreateServerGui(data)
    local newGUI = self.ServerGuiToUse:Clone()
    newGUI.Left.NameOfServer.Text = data["serverId"]
    newGUI.Left.PlayerCount.Text = #data["players"].. " / ".. "20"
    
    --Add to Collection
    self.ServerGuis[data["serverId"]] = newGUI

    --Display
    newGUI.Parent = List
end

function ServerController:ServerChange(data)
    local id = data["serverId"]
    if not self.ServerGuis[id] then return self:CreateServerGui(data) end

end

function ServerController:DeleteServer(id)
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
end

return ServerController