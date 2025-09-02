-- GUI Buatan Sendiri (tanpa OrionLib)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local WalkSpeedLabel = Instance.new("TextLabel")
local WalkSpeedBox = Instance.new("TextBox")
local FlyButton = Instance.new("TextButton")

-- Parent GUI
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame utama
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 150)

-- Label WalkSpeed
WalkSpeedLabel.Parent = MainFrame
WalkSpeedLabel.BackgroundTransparency = 1
WalkSpeedLabel.Position = UDim2.new(0, 10, 0, 10)
WalkSpeedLabel.Size = UDim2.new(0, 100, 0, 25)
WalkSpeedLabel.Text = "WalkSpeed:"
WalkSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Box input WalkSpeed
WalkSpeedBox.Parent = MainFrame
WalkSpeedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
WalkSpeedBox.Position = UDim2.new(0, 120, 0, 10)
WalkSpeedBox.Size = UDim2.new(0, 100, 0, 25)
WalkSpeedBox.Text = "16"
WalkSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Fungsi ubah speed
WalkSpeedBox.FocusLost:Connect(function()
    local val = tonumber(WalkSpeedBox.Text)
    if val then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

-- Tombol Fly Mode
FlyButton.Parent = MainFrame
FlyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
FlyButton.Position = UDim2.new(0, 10, 0, 50)
FlyButton.Size = UDim2.new(0, 220, 0, 40)
FlyButton.Text = "Toggle Fly"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Fly system
local flying = false
local bv, hum
FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    hum = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    if flying then
        bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(4000,4000,4000)
        bv.Parent = hum
    else
        if bv then bv:Destroy() end
    end
end)

-- Kontrol terbang (Space = naik, Ctrl = turun)
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp or not flying then return end
    if input.KeyCode == Enum.KeyCode.Space then
        bv.Velocity = Vector3.new(0, 50, 0)
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        bv.Velocity = Vector3.new(0, -50, 0)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, gp)
    if gp or not flying then return end
    if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftControl then
        bv.Velocity = Vector3.new(0, 0, 0)
    end
end)
