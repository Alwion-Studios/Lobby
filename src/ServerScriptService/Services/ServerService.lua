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
local Knit = require(packages.Knit)

local ServerService = Knit.CreateService {
    Name = "ServerService";
    Servers = {}
}

function ServerService:KnitStart()
    MS:SubscribeAsync("ServerList", function(data) 
       --[[ local server = data.Data

        if server.serverId ~= game.JobId then
            local serverTbl = {}
            serverTbl["ID"] = server.serverId
            serverTbl["MemberCount"] = server.players
            table.insert(self.Servers, serverTbl)
            wait(5)
            serverTbl = nil
        end]]
        print(data)
    end)

    while wait(5) do
        MS:PublishAsync("ServerList", {
            serverId = game.JobId,
            players = #game.Players:GetPlayers()
        })
    end
end

return ServerService