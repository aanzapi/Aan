-- =============================================================================
-- DELTA FISHING UI BASE
-- Optimized for Delta Executor
-- =============================================================================

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Player
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Library (using Delta's library or create our own)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/UI-Libraries/main/Vynixius/Source.lua"))()
-- Alternative: Use Delta's built-in if available

-- Main Window
local Window = Library:AddWindow({
    title = {"⚡ Delta Fishing", "v2.0"},
    theme = {
        Accent = Color3.fromRGB(0, 170, 255)
    },
    key = Enum.KeyCode.RightControl,
    default = true
})

-- Tabs
local MainTab = Window:AddTab({title = "Main", icon = "home"})
local AutoTab = Window:AddTab({title = "Automation", icon = "settings"})
local SettingsTab = Window:AddTab({title = "Settings", icon = "sliders"})

-- =============================================================================
-- MAIN TAB
-- =============================================================================
MainTab:AddSection({title = "Fishing Control"})

-- Status Label
local StatusLabel = MainTab:AddLabel({
    text = "Status: Idle",
    color = Color3.fromRGB(200, 200, 200)
})

-- Toggle Fishing
local FishingToggle = MainTab:AddToggle({
    title = "Auto Fish",
    default = false,
    callback = function(state)
        if state then
            StatusLabel:Set("Status: Fishing...")
            -- Start fishing logic here
        else
            StatusLabel:Set("Status: Idle")
            -- Stop fishing logic here
        end
    end
})

-- Catch Counter
local CatchCounter = 0
local CatchLabel = MainTab:AddLabel({
    text = "Catches: 0",
    color = Color3.fromRGB(0, 200, 255)
})

-- Catch Button
MainTab:AddButton({
    title = "Manual Catch",
    callback = function()
        CatchCounter = CatchCounter + 1
        CatchLabel:Set("Catches: " .. CatchCounter)
        -- Manual catch logic
    end
})

MainTab:AddDivider()

-- Fishing Stats
MainTab:AddSection({title = "Statistics"})

local Stats = {
    TimeFishing = 0,
    RareCatches = 0,
    TotalValue = 0
}

-- Stats Labels
local TimeLabel = MainTab:AddLabel({text = "Time Fishing: 0s"})
local RareLabel = MainTab:AddLabel({text = "Rare Catches: 0"})
local ValueLabel = MainTab:AddLabel({text = "Total Value: $0"})

-- Update stats timer
spawn(function()
    while true do
        task.wait(1)
        if FishingToggle.Value then
            Stats.TimeFishing = Stats.TimeFishing + 1
            local hours = math.floor(Stats.TimeFishing / 3600)
            local minutes = math.floor((Stats.TimeFishing % 3600) / 60)
            local seconds = Stats.TimeFishing % 60
            TimeLabel:Set(string.format("Time Fishing: %02d:%02d:%02d", hours, minutes, seconds))
        end
    end
end)

-- =============================================================================
-- AUTOMATION TAB (Your Fishing System Integration)
-- =============================================================================
AutoTab:AddSection({title = "⚡ Blatant Fishing System"})

-- Blatant Mode Toggle
local BlatantToggle = AutoTab:AddToggle({
    title = "Blatant Mode",
    description = "Fast fishing with minigame bypass",
    default = false,
    callback = function(state)
        if ToggleBlatantMode then
            ToggleBlatantMode(state)
        end
    end
})

-- Reel Delay Slider
AutoTab:AddSlider({
    title = "Reel Delay",
    description = "Delay before reeling fish",
    suffix = "s",
    default = 0.5,
    min = 0,
    max = 1.87,
    rounding = 2,
    callback = function(value)
        if SetBlatantReelDelay then
            SetBlatantReelDelay(value)
        end
    end
})

-- Fishing Delay Slider
AutoTab:AddSlider({
    title = "Fishing Delay",
    description = "Delay between fishing attempts",
    suffix = "ms",
    default = 15,
    min = 1,
    max = 100,
    rounding = 0,
    callback = function(value)
        if SetBlatantFishingDelay then
            SetBlatantFishingDelay(value / 1000)
        end
    end
})

-- Buttons
AutoTab:AddButton({
    title = "Initialize System",
    callback = function()
        if InitializeBlatantFishing then
            InitializeBlatantFishing()
        end
    end
})

AutoTab:AddButton({
    title = "Manual Cast",
    callback = function()
        if ManualBlatantFish then
            ManualBlatantFish()
        end
    end
})

AutoTab:AddDivider()

-- Webhook Section (Optional)
AutoTab:AddSection({title = "Notifications"})

local WebhookToggle = AutoTab:AddToggle({
    title = "Discord Webhook",
    description = "Send catches to Discord",
    default = false
})

AutoTab:AddInput({
    title = "Webhook URL",
    placeholder = "https://discord.com/api/webhooks/...",
    callback = function(text)
        -- Save webhook URL
    end
})

-- =============================================================================
-- SETTINGS TAB
-- =============================================================================
SettingsTab:AddSection({title = "UI Settings"})

-- Theme Color
SettingsTab:AddColorpicker({
    title = "Theme Color",
    default = Color3.fromRGB(0, 170, 255),
    callback = function(color)
        Window:ChangeThemeOption("Accent", color)
    end
})

-- Toggle Key
SettingsTab:AddKeybind({
    title = "Toggle UI Key",
    default = Enum.KeyCode.RightControl,
    callback = function()
        Window:Toggle()
    end
})

-- Auto Close
SettingsTab:AddToggle({
    title = "Auto-Close UI",
    description = "Close UI after toggling feature",
    default = false
})

SettingsTab:AddDivider()

-- Performance
SettingsTab:AddSection({title = "Performance"})

SettingsTab:AddSlider({
    title = "Update Rate",
    description = "Lower = better performance",
    suffix = "ms",
    default = 50,
    min = 10,
    max = 1000,
    rounding = 0,
    callback = function(value)
        -- Set update interval
    end
})

-- Save/Load
SettingsTab:AddButton({
    title = "Save Settings",
    callback = function()
        -- Save settings logic
    end
})

SettingsTab:AddButton({
    title = "Load Settings",
    callback = function()
        -- Load settings logic
    end
})

-- =============================================================================
-- NOTIFICATION FUNCTION
-- =============================================================================
function Notify(options)
    Library:Notify({
        title = options.Title or "Notification",
        content = options.Content or "",
        duration = options.Duration or 3
    })
    
    -- Also print to console for debugging
    print(string.format("[%s] %s", options.Title or "Notification", options.Content or ""))
end

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

-- Welcome message
spawn(function()
    task.wait(1)
    Notify({
        Title = "Delta Fishing",
        Content = "UI loaded successfully! Press RightControl to toggle.",
        Duration = 5
    })
end)

-- Save settings on close
game:GetService("UserInputService").WindowFocused:Connect(function()
    -- Auto-save when window focused
end)

-- Keybind listener
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessed then
        Window:Toggle()
    end
end)

-- Cleanup on script termination
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    -- Handle character reset
end)

-- Return the window for external access
return {
    Window = Window,
    Tabs = {
        Main = MainTab,
        Auto = AutoTab,
        Settings = SettingsTab
    },
    Notify = Notify,
    GetStatus = function()
        return {
            Fishing = FishingToggle.Value,
            Blatant = BlatantToggle.Value,
            Catches = CatchCounter,
            Time = Stats.TimeFishing
        }
    end
}
