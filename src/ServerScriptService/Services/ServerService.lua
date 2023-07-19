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


local function randomisedPlayer() 
    return PS:GetPlayers()[math.random(#PS:GetPlayers())]
end

function ServerService:UploadToIndex(jobId)
    local userIds = {}

    --[[for _, player in pairs(game.Players:GetPlayers()) do
        table.insert(userIds, player.UserId)
    end]]

    local currPlr = 1
    local maxNum

    if #PS:GetPlayers() <= 1 then maxNum = 1 
    elseif #PS:GetPlayers() <= 2 then maxNum = 2
    else maxNum = 3
    end
    
    repeat
        local selPlr = randomisedPlayer()
        table.insert(userIds, selPlr.UserId)
        currPlr += 1
    until (currPlr > maxNum)
    

    local data = {
        serverId = jobId,
        uptime = 0,
        name = jobId,
        players = userIds,
        version = self.version
    }

    ServerIndexMap:SetAsync(jobId, HTTP:JSONEncode(data), 10)
end

function ServerService:RenderServers()
    self.OpenServers = self:GetAllServers()

    for _, openServer in pairs(self.OpenServers) do
        self.Client.RefreshServers:FireAll(openServer)
    end
end

function ServerService:KnitStart()
    wait(1)
    self:UploadToIndex("123")
    self:UploadToIndex("456")
    self:UploadToIndex("789")

    while task.wait() do
        self:RenderServers()
    end
end

return ServerService