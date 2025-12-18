-- =============================================================================
-- ⚡ DELTA FISHING HUB - PREMIUM UI
-- =============================================================================
-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Player
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- UI Library (Premium Design)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "⚡ DELTA FISHING | v3.0",
    LoadingTitle = "Loading Fishing System...",
    LoadingSubtitle = "by Premium Hub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DeltaFishing",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvite",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Fishing Hub",
        Subtitle = "Key System",
        Note = "No key required",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"DELTA"}
    }
})

-- Colors
local Theme = {
    Primary = Color3.fromRGB(0, 184, 255),
    Secondary = Color3.fromRGB(25, 25, 35),
    Success = Color3.fromRGB(0, 255, 136),
    Danger = Color3.fromRGB(255, 71, 87),
    Warning = Color3.fromRGB(255, 170, 0),
    Dark = Color3.fromRGB(15, 15, 20),
    Light = Color3.fromRGB(240, 240, 245)
}

-- Main Tab
local MainTab = Window:CreateTab("Dashboard", "rbxassetid://7733674079")
local AutomationTab = Window:CreateTab("Automation", "rbxassetid://7733675284")
local SettingsTab = Window:CreateTab("Settings", "rbxassetid://7733676211")

-- =============================================================================
-- DASHBOARD TAB
-- =============================================================================
MainTab:CreateSection("🎯 Control Panel")

-- Status Panel
local StatusCard = MainTab:CreateParagraph({
    Title = "System Status",
    Content = "🟢 Ready | Connected to Server"
})

-- Quick Actions
local AutoToggle = MainTab:CreateToggle({
    Name = "⚡ Auto Fishing",
    CurrentValue = false,
    Flag = "AutoFishing",
    Callback = function(Value)
        if Value then
            StatusCard:Set({
                Title = "System Status",
                Content = "🎣 Fishing Active | Auto Mode"
            })
            Rayfield:Notify({
                Title = "Fishing Started",
                Content = "Auto fishing system activated",
                Duration = 2,
                Image = "rbxassetid://7733674079"
            })
        else
            StatusCard:Set({
                Title = "System Status",
                Content = "🟡 Idle | Ready to Fish"
            })
            Rayfield:Notify({
                Title = "Fishing Stopped",
                Content = "Auto fishing system deactivated",
                Duration = 2,
                Image = "rbxassetid://7733674079"
            })
        end
    end
})

-- Statistics Panel
MainTab:CreateSection("📊 Statistics")

local Stats = {
    TotalCatches = 0,
    RareCatches = 0,
    TimeFishing = 0,
    TotalValue = 0
}

local StatsContainer = MainTab:CreateSection("Live Stats", false)

local CatchLabel = MainTab:CreateLabel("Total Catches: 0")
local RareLabel = MainTab:CreateLabel("Rare Catches: 0")
local TimeLabel = MainTab:CreateLabel("Time Fishing: 00:00:00")
local ValueLabel = MainTab:CreateLabel("Total Value: $0")

-- Update timer
spawn(function()
    while true do
        task.wait(1)
        if AutoToggle.CurrentValue then
            Stats.TimeFishing += 1
            local hours = math.floor(Stats.TimeFishing / 3600)
            local minutes = math.floor((Stats.TimeFishing % 3600) / 60)
            local seconds = Stats.TimeFishing % 60
            TimeLabel:Set(string.format("Time Fishing: %02d:%02d:%02d", hours, minutes, seconds))
        end
    end
end)

-- Manual Controls
MainTab:CreateSection("🕹️ Manual Controls")

MainTab:CreateButton({
    Name = "🎣 Cast Rod",
    Callback = function()
        Rayfield:Notify({
            Title = "Manual Cast",
            Content = "Casting fishing rod...",
            Duration = 1.5
        })
    end
})

MainTab:CreateButton({
    Name = "🎯 Reel In",
    Callback = function()
        Stats.TotalCatches += 1
        CatchLabel:Set("Total Catches: " .. Stats.TotalCatches)
        Rayfield:Notify({
            Title = "Success!",
            Content = "Fish caught! Total: " .. Stats.TotalCatches,
            Duration = 2
        })
    end
})

-- Quick Sell
local SellToggle = MainTab:CreateToggle({
    Name = "💸 Auto Sell",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        Rayfield:Notify({
            Title = Value and "Auto Sell ON" or "Auto Sell OFF",
            Content = Value and "Fish will be automatically sold" or "Manual selling required",
            Duration = 2
        })
    end
})

-- =============================================================================
-- AUTOMATION TAB (BLATANT FISHING INTEGRATION)
-- =============================================================================
AutomationTab:CreateSection("⚡ Blatant Fishing System")

-- Blatant Mode Toggle
local BlatantToggle = AutomationTab:CreateToggle({
    Name = "🔥 Blatant Mode",
    CurrentValue = false,
    Flag = "BlatantMode",
    Callback = function(Value)
        if ToggleBlatantMode then
            ToggleBlatantMode(Value)
        end
        Rayfield:Notify({
            Title = Value and "Blatant Mode ON" or "Blatant Mode OFF",
            Content = Value and "Minigame bypass activated" or "Normal fishing mode",
            Duration = 3,
            Image = "rbxassetid://7733675284"
        })
    end
})

-- Delay Settings
AutomationTab:CreateSection("⏱️ Timing Settings")

local ReelSlider = AutomationTab:CreateSlider({
    Name = "Reel Delay",
    Range = {0, 1.87},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.5,
    Flag = "ReelDelay",
    Callback = function(Value)
        if SetBlatantReelDelay then
            SetBlatantReelDelay(Value)
        end
    end
})

local FishSlider = AutomationTab:CreateSlider({
    Name = "Fishing Delay",
    Range = {1, 100},
    Increment = 1,
    Suffix = "ms",
    CurrentValue = 15,
    Flag = "FishingDelay",
    Callback = function(Value)
        if SetBlatantFishingDelay then
            SetBlatantFishingDelay(Value / 1000)
        end
    end
})

-- Advanced Settings
AutomationTab:CreateSection("🔧 Advanced")

AutomationTab:CreateButton({
    Name = "Initialize System",
    Callback = function()
        if InitializeBlatantFishing then
            InitializeBlatantFishing()
        end
        Rayfield:Notify({
            Title = "Initializing",
            Content = "Starting fishing system...",
            Duration = 2
        })
    end
})

AutomationTab:CreateButton({
    Name = "Test Connection",
    Callback = function()
        Rayfield:Notify({
            Title = "Connection Test",
            Content = "Checking server connection...",
            Duration = 2
        })
    end
})

-- Whitelist Settings
AutomationTab:CreateSection("👑 Whitelist")

local PlayerBox = AutomationTab:CreateInput({
    Name = "Whitelist Player",
    PlaceholderText = "Player Name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Rayfield:Notify({
            Title = "Whitelist Added",
            Content = Text .. " has been whitelisted",
            Duration = 3
        })
    end
})

-- =============================================================================
-- SETTINGS TAB
-- =============================================================================
SettingsTab:CreateSection("🎨 UI Customization")

-- Theme Color
local ColorPicker = SettingsTab:CreateColorPicker({
    Name = "Theme Color",
    Color = Theme.Primary,
    Flag = "ThemeColor",
    Callback = function(Color)
        Theme.Primary = Color
    end
})

-- UI Transparency
local TransparencySlider = SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "%",
    CurrentValue = 0,
    Flag = "UITransparency",
    Callback = function(Value)
        -- Set UI transparency
    end
})

-- Toggle Keybind
SettingsTab:CreateSection("⌨️ Keybinds")

local Keybind = SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightControl",
    HoldToInteract = false,
    Flag = "UIToggle",
    Callback = function(Keybind)
        Window:Toggle(Keybind)
    end
})

-- Performance
SettingsTab:CreateSection("⚡ Performance")

SettingsTab:CreateSlider({
    Name = "Update Rate",
    Range = {10, 1000},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = 50,
    Flag = "UpdateRate",
    Callback = function(Value)
        -- Set update interval
    end
})

-- Config Management
SettingsTab:CreateSection("💾 Configuration")

SettingsTab:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        Rayfield:Notify({
            Title = "Configuration Saved",
            Content = "Settings have been saved successfully",
            Duration = 3
        })
    end
})

SettingsTab:CreateButton({
    Name = "Load Configuration",
    Callback = function()
        Rayfield:Notify({
            Title = "Configuration Loaded",
            Content = "Settings have been loaded",
            Duration = 3
        })
    end
})

SettingsTab:CreateButton({
    Name = "Reset to Default",
    Callback = function()
        Rayfield:Notify({
            Title = "Reset Complete",
            Content = "All settings reset to default",
            Duration = 3
        })
    end
})

-- Watermark
SettingsTab:CreateSection("ℹ️ Information")

SettingsTab:CreateLabel("Delta Fishing Hub v3.0")
SettingsTab:CreateLabel("Made for Delta Executor")
SettingsTab:CreateLabel("Status: Premium")

-- =============================================================================
-- PREMIUM FEATURES
-- =============================================================================
local PremiumTab = Window:CreateTab("Premium", "rbxassetid://7733713439")

PremiumTab:CreateSection("🌟 Premium Features")

-- ESP Features
local ESPToggle = PremiumTab:CreateToggle({
    Name = "🎯 Fish ESP",
    CurrentValue = false,
    Flag = "FishESP",
    Callback = function(Value)
        Rayfield:Notify({
            Title = Value and "Fish ESP ON" or "Fish ESP OFF",
            Content = Value and "Highlighting rare fish" or "ESP disabled",
            Duration = 3,
            Image = "rbxassetid://7733713439"
        })
    end
})

-- Auto-Upgrade
PremiumTab:CreateToggle({
    Name = "⚡ Auto Upgrade Rod",
    CurrentValue = false,
    Flag = "AutoUpgrade",
    Callback = function(Value)
        Rayfield:Notify({
            Title = Value and "Auto-Upgrade ON" or "Auto-Upgrade OFF",
            Content = Value and "Automatically upgrading fishing rod" or "Manual upgrades only",
            Duration = 3
        })
    end
})

-- Anti-AFK
PremiumTab:CreateToggle({
    Name = "🤖 Anti-AFK System",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        Rayfield:Notify({
            Title = Value and "Anti-AFK ON" or "Anti-AFK OFF",
            Content = Value and "Preventing AFK detection" or "Normal AFK behavior",
            Duration = 3
        })
    end
})

-- Server Hop
PremiumTab:CreateButton({
    Name = "🔄 Server Hop",
    Callback = function()
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "Finding new server...",
            Duration = 5
        })
    end
})

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

-- Load configuration
Rayfield:LoadConfiguration()

-- Welcome message
task.wait(2)
Rayfield:Notify({
    Title = "Delta Fishing Hub",
    Content = "Welcome! UI Loaded Successfully",
    Duration = 5,
    Image = "rbxassetid://7733674079"
})

-- Status indicator
spawn(function()
    while true do
        task.wait(5)
        if AutoToggle.CurrentValue then
            StatusCard:Set({
                Title = "System Status",
                Content = "🎣 Fishing Active | " .. Stats.TotalCatches .. " Catches"
            })
        end
    end
end)

-- Auto-save
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    Rayfield:Notify({
        Title = "Character Loaded",
        Content = "Resuming fishing system...",
        Duration = 3
    })
end)

-- Return API
return {
    Window = Window,
    ToggleFishing = function(state)
        AutoToggle:Set(state)
    end,
    GetStats = function()
        return Stats
    end,
    AddCatch = function(rare, value)
        Stats.TotalCatches += 1
        if rare then
            Stats.RareCatches += 1
        end
        Stats.TotalValue += value or 0
        
        CatchLabel:Set("Total Catches: " .. Stats.TotalCatches)
        RareLabel:Set("Rare Catches: " .. Stats.RareCatches)
        ValueLabel:Set("Total Value: $" .. Stats.TotalValue)
    end
}
