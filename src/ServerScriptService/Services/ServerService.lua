--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by Marshmelly. All Rights Reserved.
Contact me at Marshmelly#0001 if any issues arise.

]]
--ROBLOX Service Calls

--Imports
local packages = game:GetService("ReplicatedStorage").Packages
local MS = game:GetService("MessagingService")
local PS = game:GetService("Players")
local HTTP = game:GetService("HttpService")
local Knit = require(packages.Knit)

local ServerService = Knit.CreateService {
    Name = "ServerService";
    Client = {
        CreateServer = Knit.CreateSignal(),
        ReplicateServerChange = Knit.CreateSignal(),
        ServerChanged = Knit.CreateSignal(),
        ServerDeleted = Knit.CreateSignal(),
    },
    OpenServers = {}
}

function checkGamepass(plr, id)
    return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(plr.UserId, id) or false
end

function createServer(plr, name, gameID)
    if not checkGamepass(plr, 111306708) or not checkGamepass(plr, 26328389) then return false end
    return true
end

function ServerService:KnitStart()
    local server = self
    PS.PlayerAdded:Connect(function() 
        self.Client.CreateServer:Connect(createServer)

        MS:SubscribeAsync("ServerStatus", function(data)
            local fromServer = data.Data
            server.OpenServers[fromServer.serverId] = fromServer
            server.Client.ServerChanged:FireAll(fromServer)
        end)
    
        MS:SubscribeAsync("ClosedServer", function(data)
            local fromServer = data.Data
            server.OpenServers[fromServer.serverId] = nil
            server.Client.ServerDeleted:FireAll(fromServer)
        end)
    end)
end

return ServerService