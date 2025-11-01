-- Delta Executor UI Premium - Mobile Android
-- Base tampilan dengan fitur geser, hide, notifikasi, dan 5 page

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main Screen GUI
local DeltaGUI = Instance.new("ScreenGui")
DeltaGUI.Name = "DeltaExecutorPremium"
DeltaGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
DeltaGUI.DisplayOrder = 999

-- Main Frame (Bisa di-geser)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Corner Radius
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Drop Shadow
local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.Parent = MainFrame
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow.Size = UDim2.new(1, 40, 1, 40)
DropShadow.BackgroundTransparency = 1
DropShadow.Image = "rbxassetid://6015897843"
DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ImageTransparency = 0.5
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
DropShadow.ZIndex = 0

-- Title Bar (Untuk drag)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 8)
TitleBarCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "DELTA EXECUTOR PREMIUM"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Hide Button
local HideButton = Instance.new("TextButton")
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 30, 0, 30)
HideButton.Position = UDim2.new(1, -40, 0.5, -15)
HideButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
HideButton.BorderSizePixel = 0
HideButton.Text = "_"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextSize = 16
HideButton.Font = Enum.Font.GothamBold

local HideButtonCorner = Instance.new("UICorner")
HideButtonCorner.CornerRadius = UDim.new(0, 6)
HideButtonCorner.Parent = HideButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -80, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold

local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 6)
CloseButtonCorner.Parent = CloseButton

-- Navigation Tabs
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -20, 0, 30)
TabContainer.Position = UDim2.new(0, 10, 0, 50)
TabContainer.BackgroundTransparency = 1

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabContainer
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabListLayout.Padding = UDim.new(0, 5)

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -100)
ContentFrame.Position = UDim2.new(0, 10, 0, 90)
ContentFrame.BackgroundTransparency = 1

-- Notification System
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Size = UDim2.new(0, 300, 0, 60)
NotificationFrame.Position = UDim2.new(1, 10, 0, 10)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Visible = false

local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 8)
NotificationCorner.Parent = NotificationFrame

local NotificationLabel = Instance.new("TextLabel")
NotificationLabel.Name = "NotificationLabel"
NotificationLabel.Size = UDim2.new(1, -20, 1, -20)
NotificationLabel.Position = UDim2.new(0, 10, 0, 10)
NotificationLabel.BackgroundTransparency = 1
NotificationLabel.Text = "Notification System Ready"
NotificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationLabel.TextSize = 12
NotificationLabel.Font = Enum.Font.Gotham
NotificationLabel.TextWrapped = true

-- Parent semua elemen
TitleLabel.Parent = TitleBar
HideButton.Parent = TitleBar
CloseButton.Parent = TitleBar
TitleBar.Parent = MainFrame
TabContainer.Parent = MainFrame
ContentFrame.Parent = MainFrame
NotificationFrame.Parent = MainFrame
MainFrame.Parent = DeltaGUI
DeltaGUI.Parent = playerGui

-- Variabel untuk drag functionality
local dragging = false
local dragInput, dragStart, startPos

-- Fungsi untuk membuat tab
local function createTab(tabName, tabNumber)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Tab"
    TabButton.Size = UDim2.new(0, 60, 1, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 12
    TabButton.Font = Enum.Font.Gotham
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    return TabButton
end

-- Fungsi untuk membuat page content
local function createPage(pageName)
    local PageFrame = Instance.new("ScrollingFrame")
    PageFrame.Name = pageName .. "Page"
    PageFrame.Size = UDim2.new(1, 0, 1, 0)
    PageFrame.Position = UDim2.new(0, 0, 0, 0)
    PageFrame.BackgroundTransparency = 1
    PageFrame.ScrollBarThickness = 4
    PageFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
    PageFrame.Visible = false
    
    local PageListLayout = Instance.new("UIListLayout")
    PageListLayout.Parent = PageFrame
    PageListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageListLayout.Padding = UDim.new(0, 5)
    
    return PageFrame
end

-- Buat 5 tabs
local tabs = {"Home", "Scripts", "Settings", "Tools", "Premium"}
local tabButtons = {}
local pages = {}

for i, tabName in ipairs(tabs) do
    -- Buat tab button
    local tabButton = createTab(tabName, i)
    tabButton.Parent = TabContainer
    tabButtons[tabName] = tabButton
    
    -- Buat page content
    local page = createPage(tabName)
    page.Parent = ContentFrame
    pages[tabName] = page
    
    -- Tambahkan title untuk setiap page
    local pageTitle = Instance.new("TextLabel")
    pageTitle.Name = "Title"
    pageTitle.Size = UDim2.new(1, -20, 0, 30)
    pageTitle.Position = UDim2.new(0, 10, 0, 10)
    pageTitle.BackgroundTransparency = 1
    pageTitle.Text = tabName .. " Page"
    pageTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    pageTitle.TextSize = 18
    pageTitle.Font = Enum.Font.GothamBold
    pageTitle.TextXAlignment = Enum.TextXAlignment.Left
    pageTitle.Parent = page
    
    -- Tambahkan konten dummy untuk setiap page
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "ContentLabel"
    contentLabel.Size = UDim2.new(1, -20, 0, 100)
    contentLabel.Position = UDim2.new(0, 10, 0, 50)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = "This is " .. tabName .. " page content.\nPremium features will be added here."
    contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentLabel.TextSize = 14
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextWrapped = true
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.Parent = page
end

-- Set Home page sebagai default
pages["Home"].Visible = true
tabButtons["Home"].BackgroundColor3 = Color3.fromRGB(65, 120, 200)

-- Fungsi untuk show notification
local function showNotification(message, duration)
    duration = duration or 3
    
    NotificationLabel.Text = message
    NotificationFrame.Visible = true
    
    -- Animasi masuk
    local tweenIn = TweenService:Create(
        NotificationFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -310, 0, 10)}
    )
    tweenIn:Play()
    
    wait(duration)
    
    -- Animasi keluar
    local tweenOut = TweenService:Create(
        NotificationFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, 10, 0, 10)}
    )
    tweenOut:Play()
    
    wait(0.3)
    NotificationFrame.Visible = false
end

-- Fungsi untuk toggle UI visibility
local function toggleUI()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        showNotification("Delta Executor UI Shown")
    end
end

-- Drag functionality
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Tab switching functionality
for tabName, tabButton in pairs(tabButtons) do
    tabButton.MouseButton1Click:Connect(function()
        -- Sembunyikan semua pages
        for _, page in pairs(pages) do
            page.Visible = false
        end
        
        -- Reset semua tab colors
        for _, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        end
        
        -- Tampilkan page yang dipilih dan ubah warna tab
        pages[tabName].Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(65, 120, 200)
        
        showNotification("Switched to " .. tabName .. " page")
    end)
end

-- Hide/Show functionality
HideButton.MouseButton1Click:Connect(function()
    toggleUI()
end)

-- Close functionality
CloseButton.MouseButton1Click:Connect(function()
    DeltaGUI:Destroy()
    showNotification("Delta Executor Closed", 2)
end)

-- Mobile touch optimization
if UserInputService.TouchEnabled then
    -- Adjust sizes for mobile
    MainFrame.Size = UDim2.new(0, 320, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
    
    -- Make buttons bigger for touch
    for _, tabButton in pairs(tabButtons) do
        tabButton.Size = UDim2.new(0, 55, 1, 0)
    end
end

-- Initial notification
showNotification("Delta Executor Premium Loaded!\nMobile UI Ready", 3)

-- Safe boundaries untuk mobile
local function ensureSafePosition()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local frameSize = MainFrame.AbsoluteSize
    local position = MainFrame.Position
    
    local minX = 0
    local maxX = viewportSize.X - frameSize.X
    local minY = 0
    local maxY = viewportSize.Y - frameSize.Y
    
    local currentX = position.X.Offset
    local currentY = position.Y.Offset
    
    -- Clamp position
    local newX = math.clamp(currentX, minX, maxX)
    local newY = math.clamp(currentY, minY, maxY)
    
    if currentX ~= newX or currentY ~= newY then
        MainFrame.Position = UDim2.new(position.X.Scale, newX, position.Y.Scale, newY)
    end
end

-- Run boundary check periodically
RunService.Heartbeat:Connect(ensureSafePosition)

return DeltaGUI
