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
local Players = game:GetService("Players")

--Player
local Player = Players.LocalPlayer

--UIs
local AdminUI = game:GetService("ReplicatedStorage"):WaitForChild("GUIs"):WaitForChild("AdminUI")

--Player Class
local plrObj = require(script.Parent.Parent.Components.AdminUserGui)

local AdminGuiController = Knit.CreateController {
    Name = "AdminGuiController";
    CurrentPage = 1;
    CurrentTab = "Bans";
    UI = AdminUI;
    PageUI = AdminUI:WaitForChild("Window"):WaitForChild("PageSys");
    Contents = AdminUI:WaitForChild("Window"):WaitForChild("Contents");
    Tabs = AdminUI:WaitForChild("Window"):WaitForChild("Options");
    DataTbl = {};
    GUIs = {};
}

function AdminGuiController:EnableUI()
    self.UI.Parent = Player.PlayerGui:WaitForChild("MellyCore")
end

function AdminGuiController:RenderPage()
    if self.DataTbl ~= false then
        self.Contents.Information.Visible = false
        for _,gui in pairs(self.Contents:GetChildren()) do
            if gui:IsA("Frame") then 
                self.GUIs[gui.Name]:Destroy()
                --self.GUIs[tonumber(gui.Name)]:Destroy()
            end
        end

        for _,id in pairs(self.DataTbl[self.CurrentPage]) do
            self.GUIs[id] = plrObj.New(id, self.Contents)
        end
    end
end

function AdminGuiController:TabChange(newTab)
    local MS = Knit.GetService("ModerationService")
    self:DisableInputs()
    if newTab == "Bans" then
        self.Contents.Information.Visible = true
        MS:GetAllBans(Player):andThen(function(returned)
            self.DataTbl = returned
            self:RenderPage()
            self:EnableInputs()
        end)
    elseif newTab == "Mutes" then

    end
end

function AdminGuiController:DisableInputs()
    self.PageUI:WaitForChild("Back").Visible = false
    self.PageUI:WaitForChild("Forward").Visible = false
    self.Tabs:WaitForChild("Bans").Visible = false
    self.Tabs:WaitForChild("Mutes").Visible = false
end

function AdminGuiController:EnableInputs()
    if self.CurrentPage > 1 then self.PageUI:WaitForChild("Back").Visible = true end
    if self.CurrentPage <= #self.DataTbl then self.PageUI:WaitForChild("Forward").Visible = true end

    self.Tabs:WaitForChild("Bans").Visible = true
    self.Tabs:WaitForChild("Mutes").Visible = true
end

function AdminGuiController:ChangePage()
    if self.CurrentPage <= 1 then self.PageUI:WaitForChild("Back").Visible = false else self.PageUI:WaitForChild("Back").Visible = true end
    if self.CurrentPage >= #self.DataTbl then self.PageUI:WaitForChild("Forward").Visible = false else self.PageUI:WaitForChild("Forward").Visible = true end
    self.PageUI.Page.Text = self.CurrentPage
    self:RenderPage()
end

function AdminGuiController:OpenUI() 
    self:TabChange("Bans")
    self.UI.Enabled = true
end

function AdminGuiController:CloseUI() 
    self.CurrentPage = 1
    self.CurrentTab = nil
    self.DataTbl = nil
    self.UI.Enabled = false
end

function AdminGuiController:KnitStart()
    self.PageUI:WaitForChild("Back").MouseButton1Click:Connect(function() 
        if self.CurrentPage <= 1 then return false end
        self.CurrentPage -= 1
        self:ChangePage(self.CurrentTab)
    end)

    self.PageUI:WaitForChild("Forward").MouseButton1Click:Connect(function() 
        self.PageUI:WaitForChild("Back").Visible = true
        self.CurrentPage += 1
        self:ChangePage(self.CurrentTab)
    end)
end

return AdminGuiController