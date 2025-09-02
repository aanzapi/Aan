-- // Advanced GUI by AanZAPI
-- Bisa digeser, ada tombol close, Fly + Teleport player list
-- Tested untuk HP (mobile analog support)

-- Services
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AanGUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UICorner biar rounded
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "🚀 AanZAPI GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Fly Button
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0.9, 0, 0, 40)
FlyBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
FlyBtn.Text = "✈️ Fly: OFF"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FlyBtn.Font = Enum.Font.SourceSansBold
FlyBtn.TextSize = 18
FlyBtn.Parent = MainFrame
Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(0, 6)

-- Dropdown Teleport
local DropDown = Instance.new("TextButton")
DropDown.Size = UDim2.new(0.9, 0, 0, 40)
DropDown.Position = UDim2.new(0.05, 0, 0.35, 0)
DropDown.Text = "👤 Teleport Menu"
DropDown.TextColor3 = Color3.fromRGB(255, 255, 255)
DropDown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DropDown.Font = Enum.Font.SourceSansBold
DropDown.TextSize = 18
DropDown.Parent = MainFrame
Instance.new("UICorner", DropDown).CornerRadius = UDim.new(0, 6)

-- Frame List Player
local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Size = UDim2.new(0.9, 0, 0.4, 0)
ListFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
ListFrame.CanvasSize = UDim2.new(0,0,0,0)
ListFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
ListFrame.ScrollBarThickness = 4
ListFrame.Visible = false
ListFrame.Parent = MainFrame
Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 6)

-- Fungsi refresh list player
local function refreshPlayers()
    for _,child in pairs(ListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local y = 0
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 30)
            Btn.Position = UDim2.new(0, 0, 0, y)
            Btn.Text = plr.Name
            Btn.TextColor3 = Color3.fromRGB(255,255,255)
            Btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Btn.Parent = ListFrame
            y = y + 35
            Btn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character:WaitForChild("HumanoidRootPart").CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                end
            end)
        end
    end
    ListFrame.CanvasSize = UDim2.new(0,0,0,y)
end
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

DropDown.MouseButton1Click:Connect(function()
    ListFrame.Visible = not ListFrame.Visible
end)

-- Fly System
local flying = false
local speed = 50
local Humanoid = LP.Character:WaitForChild("Humanoid")
local HRP = LP.Character:WaitForChild("HumanoidRootPart")

local function flyLoop()
    RunService.RenderStepped:Connect(function()
        if flying and HRP then
            local moveDir = Humanoid.MoveDirection
            HRP.Velocity = Vector3.new(moveDir.X*speed, 0, moveDir.Z*speed)
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                HRP.Velocity = HRP.Velocity + Vector3.new(0,speed/1.5,0)
            end
        end
    end)
end
flyLoop()

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    FlyBtn.Text = flying and "✈️ Fly: ON" or "✈️ Fly: OFF"
    if not flying then
        HRP.Velocity = Vector3.zero
    end
end)
