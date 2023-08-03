--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by xMellylicious. All Rights Reserved.
Contact me at xMellylicious#0001 if any issues arise.

]]
--Imports
local RS = game:GetService("ReplicatedStorage")

--Database
local DS = game:GetService("DataStoreService")

--Data Object
local schema = require(script.Parent.Parent.Schema)

--Base
local base = schema.New()
base.__index = base

function base.New()     
    local self = {}

    base:SetName("Moderation")
    base:SetDataStore("UsrModeration-ActiveB-DEV-1", true)
    base:SetDefaultData()
    self.HistoricDS = DS:GetDataStore("UsrModeration-HistoricB-DEV-1")

    return setmetatable(self, base)
end

function base:Action(plr: Player, reason:String, date:Number, issuedBy:Number)
    if not plr or not reason or not date or not issuedBy then return false end

    self:SetPlayer(plr)
    self:SetData({["reason"]=reason, ["expiryDate"]=date, ["responsibleMod"]=issuedBy})
    self:SetDataToStore()
    self:Save()
end

function base:RemovalAction(plr: Player)
    self:SetPlayer(plr)
    
    local currentData = self.DataStore:GetAsync(plr.UserId)
    local historicData = self.HistoricDS:GetAsync(plr.UserId) or {}
    table.insert(historicData, currentData)
    
    self:SetData({["active"]=false})
    self:SetDataToStore()
    self:Save()
end

return base