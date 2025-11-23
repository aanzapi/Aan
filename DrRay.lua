-- Untuk Roblox menggunakan CorN GUI Library
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUI"
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MODERN UI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Divider
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -40, 0, 1)
Divider.Position = UDim2.new(0, 20, 0, 60)
Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- Function untuk membuat button modern
local function createModernButton(text, position, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -40, 0, 45)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.AutoButtonColor = false
    Button.Parent = MainFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    -- Hover effect
    Button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            Button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}
        ):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            Button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
        ):Play()
    end)
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

-- Membuat beberapa button
createModernButton("Primary Action", UDim2.new(0, 20, 0, 80), function()
    print("Primary action triggered!")
end)

createModernButton("Secondary Action", UDim2.new(0, 20, 0, 140), function()
    print("Secondary action triggered!")
end)

createModernButton("Danger Action", UDim2.new(0, 20, 0, 200), function()
    print("Danger action triggered!")
end)

-- Function untuk membuat toggle
local function createToggle(text, position, default)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -40, 0, 30)
    ToggleFrame.Position = position
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = MainFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -50, 0, 0)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 80)
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleButton
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local isToggled = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        game:GetService("TweenService"):Create(
            ToggleButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = isToggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 80)}
        ):Play()
        print(text .. " toggled:", isToggled)
    end)
    
    return ToggleFrame
end

-- Membuat beberapa toggle
createToggle("Enable Feature A", UDim2.new(0, 20, 0, 270), true)
createToggle("Enable Feature B", UDim2.new(0, 20, 0, 310), false)
createToggle("Advanced Settings", UDim2.new(0, 20, 0, 350), false)
