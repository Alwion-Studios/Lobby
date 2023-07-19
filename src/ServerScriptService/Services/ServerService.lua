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
        RefreshServers = Knit.CreateSignal(),
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

    --Get Servers
    local Success, Items = pcall(ServerIndexMap.GetRangeAsync, ServerIndexMap, Enum.SortDirection.Ascending, 100, nil)

    if Success then
        for _, Item in ipairs(Items) do
            table.insert(ServerItems, HTTP:JSONDecode(Item.value))
        end
    end
    
    task.wait(3)

	return ServerItems
end

function ServerService:RenderServers()
    self.OpenServers = self:GetAllServers()

    for _, openServer in pairs(self.OpenServers) do
        self.Client.RefreshServers:FireAll(openServer)
    end
end

function ServerService:KnitStart()
    while task.wait() do
        self:RenderServers()
    end
end

return ServerService