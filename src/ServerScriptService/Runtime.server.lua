--[[

 __  __                 _                 _  _  _  _ 
|  \/  | __ _  _ _  ___| |_   _ __   ___ | || || || |
| |\/| |/ _` || '_|(_-/|   \ | '  \ / -_)| || | \_. |
|_|  |_|\__/_||_|  /__/|_||_||_|_|_|\___||_||_| |__/ 

Made by Marshmelly. All Rights Reserved.
Contact me at Marshmelly#0001 if any issues arise.

]]

local packages = game:GetService("ReplicatedStorage").Packages
local Knit = require(packages.Knit)

--Services Directory
Knit.AddServicesDeep(script.Parent.Services)

Knit.Start({ServicePromises=false}):andThen(function()
    print("Knit (SERVER) has been started!")
end):catch(warn)