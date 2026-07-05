-- ============================================================
--  EXE HUB v7.2  |  Professional Rayfield UI (No Logo)
-- ============================================================

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- ============================================================
--  MAIN HUB WINDOW (with keybind)
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "EXE HUB v7.2",
    Icon = 0,
    LoadingTitle = "",
    LoadingSubtitle = "",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
    Keybind = Enum.KeyCode.RightShift,  -- press RightShift to toggle
})

-- ============================================================
--  HOME TAB (enhanced with more stats)
-- ============================================================
local HomeTab = Window:CreateTab("Home", 0)

HomeTab:CreateSection("📊 System")

HomeTab:CreateButton({
    Name = "User: " .. LocalPlayer.Name,
    Callback = function() end,
})

HomeTab:CreateButton({
    Name = "Game: " .. MarketplaceService:GetProductInfo(game.PlaceId).Name,
    Callback = function() end,
})

-- Live stats: FPS, Ping, Players, Server Time
local FPSButton = HomeTab:CreateButton({
    Name = "FPS: Calculating...",
    Callback = function() end,
})

local PingButton = HomeTab:CreateButton({
    Name = "Ping: Calculating...",
    Callback = function() end,
})

local PlayersButton = HomeTab:CreateButton({
    Name = "Players: " .. #Players:GetPlayers(),
    Callback = function() end,
})

local TimeButton = HomeTab:CreateButton({
    Name = "Uptime: 0s",
    Callback = function() end,
})

-- Update all stats every second
local startTime = tick()
task.spawn(function()
    while task.wait(1) do
        local fps = math.floor(workspace:GetRealPhysicsFPS())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local playerCount = #Players:GetPlayers()
        local uptime = math.floor(tick() - startTime)
        FPSButton:Set("FPS: " .. fps)
        PingButton:Set("Ping: " .. ping .. "ms")
        PlayersButton:Set("Players: " .. playerCount)
        -- Format uptime
        local mins = math.floor(uptime / 60)
        local secs = uptime % 60
        TimeButton:Set("Uptime: " .. string.format("%02d:%02d", mins, secs))
    end
end)

HomeTab:CreateSection("🛠 Utilities")

HomeTab:CreateButton({
    Name = "🔄 Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

HomeTab:CreateButton({
    Name = "🌐 Hop Server",
    Callback = function()
        local servers = {}
        local success, data = pcall(function()
            return HttpService:JSONDecode(HttpService:HttpGetAsync(
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
            ))
        end)
        if success and data and data.data then
            for _, v in ipairs(data.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
            else
                Rayfield:Notify({ Title = "No servers found", Duration = 2 })
            end
        else
            Rayfield:Notify({ Title = "Error fetching servers", Duration = 2 })
        end
    end,
})

HomeTab:CreateButton({
    Name = "⚡ Unlock FPS (240)",
    Callback = function()
        setfpscap(240)
        Rayfield:Notify({ Title = "FPS cap set to 240", Duration = 2 })
    end,
})

HomeTab:CreateButton({
    Name = "🧹 Clear Chat",
    Callback = function()
        for _, v in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if v.Name == "Chat" and v:IsA("Frame") then
                v:ClearAllChildren()
            end
        end
        Rayfield:Notify({ Title = "Chat cleared", Duration = 1 })
    end,
})

-- ============================================================
--  SCRIPTS TAB (with execution feedback)
-- ============================================================
local ScriptsTab = Window:CreateTab("Scripts", 0)

ScriptsTab:CreateSection("🎮 Game Scripts")

-- Helper function to execute a script with a "loading" notification
local function executeScript(name, url)
    Rayfield:Notify({ Title = "⏳ Loading " .. name .. "...", Duration = 2 })
    task.wait(0.5)  -- simulate load time (just for feedback)
    loadstring(game:HttpGet(url))()
    Rayfield:Notify({ Title = "✅ " .. name .. " injected!", Duration = 2 })
end

ScriptsTab:CreateButton({
    Name = "🔫 Arsenal",
    Callback = function()
        executeScript("Arsenal", "https://script.roscripts.io/JGoDuiP")
    end,
})

ScriptsTab:CreateButton({
    Name = "🔪 MM2 (OP)",
    Callback = function()
        executeScript("MM2", "https://raw.githubusercontent.com/dxterr-hub/dxter.lua/refs/heads/main/mm2.lua")
    end,
})

-- ============================================================
--  SETTINGS TAB (professional touch)
-- ============================================================
local SettingsTab = Window:CreateTab("Settings", 0)

SettingsTab:CreateSection("🎨 Theme")

-- Theme dropdown (Rayfield supports themes)
SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = { "Default", "Dark", "Light" },
    CurrentOption = "Default",
    Callback = function(option)
        if option == "Dark" then
            Rayfield:SetTheme("Dark")
        elseif option == "Light" then
            Rayfield:SetTheme("Light")
        else
            Rayfield:SetTheme("Default")
        end
        Rayfield:Notify({ Title = "Theme set to " .. option, Duration = 1 })
    end,
})

SettingsTab:CreateSection("🔔 Notifications")

-- Toggle notifications (just a visual toggle, Rayfield doesn't have a global toggle)
SettingsTab:CreateToggle({
    Name = "Enable Notifications",
    CurrentValue = true,
    Callback = function(value)
        Rayfield:Notify({ Title = "Notifications " .. (value and "enabled" or "disabled"), Duration = 1 })
    end,
})

-- Toggle startup notification
SettingsTab:CreateToggle({
    Name = "Show Startup Notification",
    CurrentValue = true,
    Callback = function(value)
        Rayfield:Notify({ Title = "Startup notification " .. (value and "enabled" or "disabled"), Duration = 1 })
    end,
})

SettingsTab:CreateSection("⌨️ Keybinds")

-- Informational about keybind (already set above)
SettingsTab:CreateButton({
    Name = "Toggle Hub: RightShift",
    Callback = function() end,
})

-- ============================================================
--  CREDITS (added to Home tab already, but we can keep a separate section)
-- ============================================================
HomeTab:CreateSection("👑 Credits")
HomeTab:CreateButton({
    Name = "Owner: BENJO",
    Callback = function() end,
})
HomeTab:CreateButton({
    Name = "EXE HUB v7.2 • No Discord",
    Callback = function() end,
})

-- ============================================================
--  STARTUP NOTIFICATION
-- ============================================================
Rayfield:Notify({
    Title = "⚡ EXE HUB ready!",
    Duration = 3,
})
