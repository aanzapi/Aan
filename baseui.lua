-- Base UI Delta Executor
-- Script by YourName
-- Version 1.0

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "AanYakan",
    LoadingTitle = "Loading Base UI...",
    LoadingSubtitle = "by AanYakan",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DeltaBaseUI",
        FileName = "Configuration"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Key System",
        Subtitle = "Enter Key",
        Note = "No Key Required",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello", "World"}
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

local MainSection = MainTab:CreateSection("Main Features")

local Button = MainTab:CreateButton({
    Name = "Print Hello World",
    Callback = function()
        print("Hello World from Delta Executor!")
    end,
})

local Toggle = MainTab:CreateToggle({
    Name = "Enable Feature",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        if Value then
            print("Feature Enabled")
        else
            print("Feature Disabled")
        end
    end,
})

local Slider = MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "Slider1",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

local Dropdown = MainTab:CreateDropdown({
    Name = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = {"Option 1"},
    MultipleOptions = false,
    Flag = "Dropdown1",
    Callback = function(Option)
        print("Selected:", Option)
    end,
})

local ColorPicker = MainTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "ColorPicker1",
    Callback = function(Value)
        print("Color changed to:", Value)
    end
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)

local PlayerSection = PlayerTab:CreateSection("Player Modifications")

local WalkSpeedSlider = PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = Value
        end
    end,
})

local JumpPowerSlider = PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 500},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = Value
        end
    end,
})

local InfiniteJumpToggle = PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        local InfiniteJumpEnabled = Value
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if InfiniteJumpEnabled then
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end,
})

-- Visual Tab
local VisualTab = Window:CreateTab("Visual", 4483362458)

local VisualSection = VisualTab:CreateSection("Visual Effects")

local ESPToggle = VisualTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        if Value then
            -- Basic ESP Function
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    local character = player.Character
                    if character then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = character
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Name = "ESP_Highlight"
                    end
                end
            end
        else
            -- Remove ESP
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("ESP_Highlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end,
})

local TracerToggle = VisualTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = false,
    Flag = "Tracers",
    Callback = function(Value)
        if Value then
            print("Tracers Enabled")
            -- Add tracer function here
        else
            print("Tracers Disabled")
            -- Remove tracers here
        end
    end,
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

local TeleportSection = TeleportTab:CreateSection("Teleport Locations")

local TeleportDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport To",
    Options = {"Spawn", "Middle", "Base"},
    CurrentOption = {"Spawn"},
    MultipleOptions = false,
    Flag = "TeleportLoc",
    Callback = function(Option)
        local locations = {
            ["Spawn"] = CFrame.new(0, 5, 0),
            ["Middle"] = CFrame.new(100, 5, 100),
            ["Base"] = CFrame.new(200, 5, 200)
        }
        
        if locations[Option] then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = locations[Option]
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Teleported to " .. Option,
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

local TeleportButton = TeleportTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        Rayfield:Notify({
            Title = "Info",
            Content = "Select a player from dropdown above",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)

local SettingsSection = SettingsTab:CreateSection("UI Settings")

local DestroyUI = SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

local ToggleUI = SettingsTab:CreateButton({
    Name = "Toggle UI (Right Control)",
    Callback = function()
        Rayfield:Notify({
            Title = "Info",
            Content = "Press Right Control to toggle UI visibility",
            Duration = 5,
            Image = 4483362458
        })
    end,
})

local CreditsSection = SettingsTab:CreateSection("Credits")

local CreditsLabel = SettingsTab:CreateLabel("Made for Delta Executor")
local CreditsLabel2 = SettingsTab:CreateLabel("Base UI Template v1.0")

-- Notification saat load
Rayfield:Notify({
    Title = "Delta Base UI Loaded",
    Content = "Successfully loaded the UI!",
    Duration = 5,
    Image = 4483362458
})

-- Auto set walkspeed ketika karakter spawn
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    task.wait(0.5)
    if Rayfield.Flags["WalkSpeed"] then
        character.Humanoid.WalkSpeed = Rayfield.Flags["WalkSpeed"]
    end
    if Rayfield.Flags["JumpPower"] then
        character.Humanoid.JumpPower = Rayfield.Flags["JumpPower"]
    end
end)

print("Delta Base UI Loaded Successfully!")
