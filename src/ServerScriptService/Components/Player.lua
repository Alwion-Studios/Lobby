--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by Marshmelly. All Rights Reserved.
Contact me at Marshmelly#0001 if any issues arise.

]]

--Imports
local RS = game:GetService("ReplicatedStorage")
local packages = RS.Packages
local Knit = require(packages.Knit)
local Janitor = require(packages.Janitor)

--Main Object
local Player = {}
Player.__index = Player

--Code
local function deployFile(file, player)
    return require(file).New(player)
end


function Player.New() 
    local self = {}

    self.Player = nil
    self.Store = {}
    self.Janitor = Janitor.new()

    return setmetatable(self, Player)
end

function Player:SetPlayer(plr)
    if not plr then return false end
    self.Player = plr
end

function Player:SetDataStore()
    for _, file in pairs(script.Parent.MDS.User:GetDescendants()) do
        if file:IsA("ModuleScript") then
            if file.Parent.Name == "System" then continue end
            if file.Name == "Schema" or file.Name == "Settings" then continue end

            local toUse = deployFile(file, self.Player)
            self.Store[toUse:GetName()] = toUse
        end 
    end
end

function Player:SaveDataStore()
    for _, store in pairs(self.Store) do
        store:Save()
    end
end

function Player:SaveDataStoreAndScrap()
    print("Deleting Datastore")

    for name, store in pairs(self.Store) do
        if name == "Money" then
            print("Stopping Autosave")
            store:StopAutoSave()
        end

        store:Save()
        store:Destroy()
    end
    
    return true
end

function Player:GetDataStore()
    local storeValues = {}

    for _, store in pairs(self.Store) do
        table.insert(storeValues, store:GetAllData())
    end

    return storeValues
end

function Player:GetSchemaFromName(name)
    if self.Store[name] then
        return self.Store[name]
    end
    return nil
end

function Player:SetAttribute(name, value) 
    self.Player:SetAttribute(name, value)
end

function Player:Destroy()
    print("Destroying Player")
    self = nil
end

return Player