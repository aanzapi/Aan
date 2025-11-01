-- Delta Executor GUI Modern
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Delta Executor - Modern GUI", "DarkTheme")

-- Main Tab
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Main Features")

MainSection:NewButton("Infinite Yield", "Admin Commands", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

MainSection:NewButton("Fly GUI", "Fly Script", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGui/main/FlyGui.lua"))()
end)

MainSection:NewButton("ESP Players", "Player ESP", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua"))()
end)

MainSection:NewToggle("Speed Hack", "Increase WalkSpeed", function(state)
    if state then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

MainSection:NewSlider("WalkSpeed", "Change WalkSpeed", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

MainSection:NewSlider("JumpPower", "Change JumpPower", 500, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

-- Player Tab
local PlayerTab = Window:NewTab("Player")
local PlayerSection = PlayerTab:NewSection("Player Modifications")

PlayerSection:NewTextBox("Change Name", "Change Display Name", function(txt)
    game.Players.LocalPlayer.DisplayName = txt
end)

PlayerSection:NewButton("Reset Character", "Respawn Character", function()
    game.Players.LocalPlayer.Character:BreakJoints()
end)

PlayerSection:NewKeybind("Toggle GUI", "Toggle GUI Visibility", Enum.KeyCode.RightControl, function()
	Library:ToggleUI()
end)

-- Teleport Tab
local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("Teleport Locations")

TeleportSection:NewDropdown("Teleport to Player", "Select Player", function(plr)
    local target = game.Players[plr]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end)

TeleportSection:NewButton("Spawn Location", "Teleport to Spawn", function()
    local spawn = game:GetService("Players").LocalPlayer:FindFirstChild("SpawnPos")
    if spawn then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawn.Value)
    end
end)

-- Game Tab
local GameTab = Window:NewTab("Game")
local GameSection = GameTab:NewSection("Game Features")

GameSection:NewButton("Anti AFK", "Prevent AFK Kick", function()
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

GameSection:NewToggle("No Clip", "Walk through walls", function(state)
    if state then
        game:GetService("RunService").Stepped:Connect(function()
            if game.Players.LocalPlayer.Character then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

GameSection:NewToggle("God Mode", "Invincibility", function(state)
    if state then
        game.Players.LocalPlayer.Character.Humanoid.Name = "Humanoid1"
        local newHumanoid = game.Players.LocalPlayer.Character.Humanoid1:Clone()
        newHumanoid.Parent = game.Players.LocalPlayer.Character
        newHumanoid.Name = "Humanoid"
        wait()
        game.Players.LocalPlayer.Character.Humanoid1:Destroy()
        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
    end
end)

-- Settings Tab
local SettingsTab = Window:NewTab("Settings")
local SettingsSection = SettingsTab:NewSection("GUI Settings")

SettingsSection:NewButton("Destroy GUI", "Remove GUI", function()
    Library:Destroy()
end)

SettingsSection:NewColorPicker("GUI Color", "Change GUI Color", Color3.fromRGB(0, 255, 0), function(color)
    Window:ChangeColor(color)
end)

SettingsSection:NewKeybind("UI Toggle Key", "Change Toggle Key", Enum.KeyCode.F1, function()
    print("Keybind changed")
end)

-- Notification ketika GUI loaded
Library:Notify("Delta GUI Loaded Successfully!", 5)

-- Auto execute beberapa fitur
wait(1)
Library:Notify("Welcome to Delta Executor!", 3)
