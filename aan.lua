-- Ambil library (OrionLib)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Buat Window
local Window = OrionLib:MakeWindow({
    Name = "🔥 Advanced GUI - AanZAPI",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AanScriptConfig"
})

-- Tab Home
local HomeTab = Window:MakeTab({
    Name = "Home",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- WalkSpeed Slider
HomeTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(0, 170, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Fly Toggle
local flying = false
HomeTab:AddToggle({
    Name = "Fly Mode",
    Default = false,
    Callback = function(Value)
        flying = Value
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:WaitForChild("HumanoidRootPart")

        if flying then
            local bv = Instance.new("BodyVelocity", hum)
            bv.MaxForce = Vector3.new(4000,4000,4000)
            bv.Velocity = Vector3.new(0,0,0)

            -- Kontrol terbang
            local uis = game:GetService("UserInputService")
            uis.InputBegan:Connect(function(input, gp)
                if gp or not flying then return end
                if input.KeyCode == Enum.KeyCode.Space then
                    bv.Velocity = Vector3.new(0, 50, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftControl then
                    bv.Velocity = Vector3.new(0, -50, 0)
                end
            end)

            uis.InputEnded:Connect(function(input, gp)
                if gp or not flying then return end
                if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftControl then
                    bv.Velocity = Vector3.new(0,0,0)
                end
            end)
        else
            if hum:FindFirstChild("BodyVelocity") then
                hum.BodyVelocity:Destroy()
            end
        end
    end    
})

-- Jalankan GUI
OrionLib:Init()
