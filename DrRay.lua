--[[  Elegant Base UI + Hamburger Menu
      Made for StarterGui (LocalScript)
      UI components are created by script, no manual UI needed
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "ElegantBaseUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Theme Config
local THEME = {
    Accent = Color3.fromRGB(36, 90, 191),
    Background = Color3.fromRGB(245, 246, 250),
    Foreground = Color3.fromRGB(25, 25, 25),
    TopbarHeight = 48,
    MenuWidth = 280,
    OverlayTransparency = 0.6
}

-- Helper: round corner
local function round(obj, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = rad or UDim.new(0, 10)
    c.Parent = obj
end

-- Root Background
local root = Instance.new("Frame")
root.Size = UDim2.new(1, 0, 1, 0)
root.BackgroundColor3 = THEME.Background
root.Parent = gui

-- Topbar
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, THEME.TopbarHeight)
top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
top.BorderSizePixel = 0
top.Parent = root

-- Title
local title = Instance.new("TextLabel")
title.Text = "My Elegant UI"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 18
title.TextColor3 = THEME.Foreground
title.BackgroundTransparency = 1
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.Position = UDim2.new(0.5, 0, 0.5, 0)
title.Size = UDim2.new(0, 180, 0, 24)
title.Parent = top

-- Hamburger Button
local hamburger = Instance.new("TextButton")
hamburger.Size = UDim2.new(0, 40, 0, 32)
hamburger.Position = UDim2.new(0, 8, 0.5, -16)
hamburger.BackgroundColor3 = Color3.fromRGB(255,255,255)
hamburger.Text = "☰"
hamburger.Font = Enum.Font.GothamBold
hamburger.TextSize = 22
hamburger.TextColor3 = THEME.Foreground
hamburger.AutoButtonColor = false
hamburger.Parent = top
round(hamburger, UDim.new(0, 6))

-- Overlay (fade black bg)
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.new(0,0,0)
overlay.BackgroundTransparency = 1
overlay.ZIndex = 5
overlay.Visible = false
overlay.Parent = root

-- Side Menu
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, THEME.MenuWidth, 1, 0)
menu.Position = UDim2.new(-1, 0, 0, 0)
menu.BackgroundColor3 = Color3.fromRGB(255,255,255)
menu.BorderSizePixel = 0
menu.ZIndex = 6
menu.Parent = root

-- Menu Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,THEME.TopbarHeight)
header.BackgroundColor3 = THEME.Accent
header.Parent = menu

local headText = Instance.new("TextLabel")
headText.Text = "Menu"
headText.Font = Enum.Font.GothamBold
headText.TextSize = 18
headText.TextColor3 = Color3.new(1,1,1)
headText.BackgroundTransparency = 1
headText.Position = UDim2.new(0,16,0.5,-10)
headText.Size = UDim2.new(0,200,0,20)
headText.Parent = header

-- List layout inside menu
local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-THEME.TopbarHeight)
content.Position = UDim2.new(0,0,0,THEME.TopbarHeight)
content.BackgroundTransparency = 1
content.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = content

-- Create buttons function
local function createButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(245,245,245)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = THEME.Foreground
    btn.Parent = content
    round(btn, UDim.new(0, 8))
    return btn
end

-- Example buttons
createButton("Profile")
createButton("Inventory")
createButton("Settings")
local closeBtn = createButton("Close Menu")

-- Tween settings
local openTween = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local closeTween = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local menuOpen = false

-- Menu open function
local function openMenu()
    if menuOpen then return end
    menuOpen = true
    overlay.Visible = true
    TweenService:Create(overlay, openTween, {BackgroundTransparency = 1 - THEME.OverlayTransparency}):Play()
    TweenService:Create(menu, openTween, {Position = UDim2.new(0,0,0,0)}):Play()
end

-- Menu close function
local function closeMenu()
    if not menuOpen then return end
    menuOpen = false
    TweenService:Create(overlay, closeTween, {BackgroundTransparency = 1}):Play()
    TweenService:Create(menu, closeTween, {Position = UDim2.new(-1,0,0,0)}):Play()
    task.wait(closeTween.Time)
    overlay.Visible = false
end

hamburger.MouseButton1Click:Connect(openMenu)
overlay.MouseButton1Click:Connect(closeMenu)
closeBtn.MouseButton1Click:Connect(closeMenu)
