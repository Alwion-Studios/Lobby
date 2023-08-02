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

--Data Object
local schema = require(script.Parent.Parent.Schema)

--Base
local base = schema.New()
base.__index = base

function base.New()     
    local self = {}

    base:SetName("Moderation")
    base:SetDataStore("UsrModeration-DEV-1", true)
    base:SetDefaultData()

    return setmetatable(self, base)
end

function base:Ban()
end

function base:Mute()
end

return base