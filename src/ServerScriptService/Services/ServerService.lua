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
local MSS = game:GetService("MemoryStoreService")
local PS = game:GetService("Players")
local HTTP = game:GetService("HttpService")
local Knit = require(packages.Knit)
local ServerKey = "123"

--Memory Stores
local ServerIndexMap = MSS:GetSortedMap("ServerIndex")

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

function ServerService:Close()
    ServerIndexMap:RemoveAsync(ServerKey)
end

function ServerService:GetAllServers()
    local ServerItems = {}
	local StartFrom = nil
	while true do
		local Items = ServerIndexMap:GetRangeAsync(Enum.SortDirection.Ascending, 100, StartFrom)
		for _, Item in ipairs(Items) do
			table.insert(ServerItems, HTTP:JSONDecode(Item.value))
		end
		if #Items < 100 then
			break
		end
		StartFrom = Items[#Items].key
		wait(3)
	end

	return ServerItems
end

function ServerService:KnitStart()
    local server = self

    PS.PlayerAdded:Connect(function() 
        self.OpenServers = self:GetAllServers()
        self.Client.CreateServer:Connect(createServer)

        --Refresh
        while wait(10) do
            self.OpenServers = self:GetAllServers()

            for _, openServer in pairs(self.OpenServers) do
                server.Client.ServerChanged:FireAll(openServer)
            end
        end

        --[[MS:SubscribeAsync("ServerStatus", function(data)
            local fromServer = data.Data
            server.OpenServers[fromServer.serverId] = fromServer
            server.Client.ServerChanged:FireAll(fromServer)
        end)
    
        MS:SubscribeAsync("ClosedServer", function(data)
            local fromServer = data.Data
            server.OpenServers[fromServer.serverId] = nil
            server.Client.ServerDeleted:FireAll(fromServer)
        end)]]
    end)
end

return ServerService