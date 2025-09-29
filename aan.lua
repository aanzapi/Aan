-- Services
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(42, 21, 60) -- base ungu gelap
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(90, 60, 120)

-- Header Bar
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1,0,0,40)
Header.BackgroundColor3 = Color3.fromRGB(58, 29, 83)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0,10,0,0)
Title.Text = "Fish It Script - AldyToi"
Title.TextColor3 = Color3.fromRGB(220,200,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-35,0.5,-15)
CloseBtn.Text = "✖"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.fromRGB(255,150,180)
CloseBtn.BackgroundTransparency = 1

-- Tab Bar
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1,0,0,40)
TabBar.Position = UDim2.new(0,0,0,40)
TabBar.BackgroundColor3 = Color3.fromRGB(42,21,60)
TabBar.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,10)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Contoh Tab
local function createTab(name,icon)
    local Tab = Instance.new("TextButton", TabBar)
    Tab.Size = UDim2.new(0,100,0,30)
    Tab.BackgroundColor3 = Color3.fromRGB(58,29,83)
    Tab.Text = icon.." "..name
    Tab.Font = Enum.Font.Gotham
    Tab.TextSize = 14
    Tab.TextColor3 = Color3.fromRGB(220,200,255)
    local corner = Instance.new("UICorner", Tab)
    corner.CornerRadius = UDim.new(0,8)

    local stroke = Instance.new("UIStroke", Tab)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(90,60,120)
    return Tab
end

local Tab1 = createTab("Event","🎉")
local Tab2 = createTab("Auto Sell","💰")
local Tab3 = createTab("Auto Trade","🔄")
local Tab4 = createTab("Trade Stone","💎")

-- Content Frame
local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1,-20,1,-90)
Content.Position = UDim2.new(0,10,0,80)
Content.BackgroundColor3 = Color3.fromRGB(58,29,83)
Content.BorderSizePixel = 0
Instance.new("UICorner", Content).CornerRadius = UDim.new(0,10)

-- Placeholder isi
local Info = Instance.new("TextLabel", Content)
Info.Size = UDim2.new(1,-20,0,30)
Info.Position = UDim2.new(0,10,0,10)
Info.Text = "⚡ Panel siap dipakai!"
Info.TextColor3 = Color3.fromRGB(230,230,255)
Info.Font = Enum.Font.Gotham
Info.TextSize = 15
Info.BackgroundTransparency = 1
Info.TextXAlignment = Enum.TextXAlignment.Left
