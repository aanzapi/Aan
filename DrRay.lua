-- Mobile-Friendly Premium GUI (Theoretical for Android)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Detect platform
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local isDesktop = UserInputService.MouseEnabled

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobilePremiumGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Mobile detection
if isMobile then
    SendNotification("Mobile Mode", "Touch-optimized GUI Activated", 3)
end

-- Adaptive sizing for mobile
local baseWidth = isMobile and 350 or 500
local baseHeight = isMobile and 500 or 450

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, baseWidth, 0, baseHeight)
MainContainer.Position = UDim2.new(0.5, -baseWidth/2, 0.5, -baseHeight/2)
MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = true
MainContainer.Parent = ScreenGui

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, isMobile and 10 or 15)
ContainerCorner.Parent = MainContainer

-- Touch-friendly Header (larger for mobile)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, isMobile and 50 or 45)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
Header.BorderSizePixel = 0
Header.Parent = MainContainer

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, isMobile and 10 or 15)
HeaderCorner.Parent = Header

-- Premium Badge (larger text for mobile)
local PremiumBadge = Instance.new("Frame")
PremiumBadge.Size = UDim2.new(0, isMobile and 100 or 120, 0, isMobile and 30 or 25)
PremiumBadge.Position = UDim2.new(0, 10, 0.5, isMobile and -15 or -12)
PremiumBadge.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
PremiumBadge.BorderSizePixel = 0
PremiumBadge.Parent = Header

local PremiumCorner = Instance.new("UICorner")
PremiumCorner.CornerRadius = UDim.new(0, 6)
PremiumCorner.Parent = PremiumBadge

local PremiumLabel = Instance.new("TextLabel")
PremiumLabel.Size = UDim2.new(1, 0, 1, 0)
PremiumLabel.BackgroundTransparency = 1
PremiumLabel.Text = "📱 PREMIUM"
PremiumLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
PremiumLabel.TextSize = isMobile and 12 or 14
PremiumLabel.Font = Enum.Font.GothamBold
PremiumLabel.Parent = PremiumBadge

-- Title (adaptive sizing)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -120, 1, 0)
TitleLabel.Position = UDim2.new(0, 120, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = isMobile and "DELTA MOBILE" or "DELTA EXECUTOR"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = isMobile and 16 or 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Mobile-friendly Control Buttons (larger touch targets)
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Size = UDim2.new(0, isMobile and 100 or 80, 1, 0)
ControlsFrame.Position = UDim2.new(1, isMobile and -105 or -85, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = Header

-- Hide Button (larger for touch)
local HideButton = Instance.new("TextButton")
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, isMobile and 25 : 20, 0, isMobile and 25 : 20)
HideButton.Position = UDim2.new(0, 5, 0.5, isMobile and -12 : -10)
HideButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
HideButton.BorderSizePixel = 0
HideButton.Text = "👁️"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextSize = isMobile and 14 : 12
HideButton.Font = Enum.Font.Gotham
HideButton.AutoButtonColor = false
HideButton.Parent = ControlsFrame

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 4)
HideCorner.Parent = HideButton

-- Close Button (larger for touch)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, isMobile and 25 : 20, 0, isMobile and 25 : 20)
CloseButton.Position = UDim2.new(0, isMobile and 35 : 30, 0.5, isMobile and -12 : -10)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = isMobile and 14 : 12
CloseButton.Font = Enum.Font.GothamBold
CloseButton.AutoButtonColor = false
CloseButton.Parent = ControlsFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- Mobile-optimized Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, isMobile and 60 : 50)
TabContainer.Position = UDim2.new(0, 0, 0, isMobile and 50 : 45)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainContainer

-- Scrollable tabs for mobile
local TabsScrolling = Instance.new("ScrollingFrame")
TabsScrolling.Size = UDim2.new(1, 0, 1, 0)
TabsScrolling.BackgroundTransparency = 1
TabsScrolling.BorderSizePixel = 0
TabsScrolling.ScrollBarThickness = isMobile and 8 : 6
TabsScrolling.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
TabsScrolling.Parent = TabContainer

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.Parent = TabsScrolling

-- Mobile-optimized tabs
local Tabs = {
    {Name = "Home", Icon = "🏠"},
    {Name = "Scripts", Icon = "⚡"}, 
    {Name = "Player", Icon = "👤"},
    {Name = "Visuals", Icon = "👁️"},
    {Name = "Settings", Icon = "⚙️"}
}

local TabButtons = {}

for i, tab in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tab.Name .. "Tab"
    TabButton.Size = UDim2.new(0, isMobile and 80 : 70, 1, -10)
    TabButton.Position = UDim2.new(0, (i-1) * (isMobile and 85 : 75), 0, 5)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    TabButton.BorderSizePixel = 0
    TabButton.Text = isMobile and tab.Icon .. "\n" .. tab.Name : tab.Icon .. " " .. tab.Name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = isMobile and 12 : 11
    TabButton.Font = Enum.Font.Gotham
    TabButton.AutoButtonColor = false
    TabButton.Parent = TabsScrolling
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    TabButtons[tab.Name] = TabButton
end

-- Update scrolling canvas size
TabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabsScrolling.CanvasSize = UDim2.new(0, TabsLayout.AbsoluteContentSize.X, 0, 0)
end)

-- Content Area (optimized for mobile)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -(isMobile and 110 : 95))
ContentFrame.Position = UDim2.new(0, 0, 0, isMobile and 110 : 95)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainContainer

local ContentScrolling = Instance.new("ScrollingFrame")
ContentScrolling.Size = UDim2.new(1, -10, 1, -10)
ContentScrolling.Position = UDim2.new(0, 5, 0, 5)
ContentScrolling.BackgroundTransparency = 1
ContentScrolling.BorderSizePixel = 0
ContentScrolling.ScrollBarThickness = isMobile and 10 : 8
ContentScrolling.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
ContentScrolling.VerticalScrollBarInset = Enum.ScrollBarInset.Always
ContentScrolling.Parent = ContentFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, isMobile and 12 : 10)
ContentLayout.Parent = ContentScrolling

-- Function to send notification
function SendNotification(title, message, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration or 3,
        Icon = "rbxassetid://13378057870"
    })
end

-- Mobile-optimized button creation
function CreateMobileButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, isMobile and 45 : 40)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = isMobile and 14 : 13
    Button.Font = Enum.Font.Gotham
    Button.AutoButtonColor = false
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    -- Touch feedback
    local function onTouchStart()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(65, 65, 90)}):Play()
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0, isMobile and 43 : 38)}):Play()
    end
    
    local function onTouchEnd()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}):Play()
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, isMobile and 45 : 40)}):Play()
    end
    
    if isMobile then
        Button.TouchLongPress:Connect(function()
            onTouchStart()
            wait(0.2)
            onTouchEnd()
        end)
        
        Button.TouchTap:Connect(function()
            onTouchStart()
            callback()
            wait(0.1)
            onTouchEnd()
            SendNotification("Feature", text .. " activated!", 2)
        end)
    else
        Button.MouseButton1Click:Connect(function()
            callback()
            SendNotification("Feature", text .. " activated!", 2)
        end)
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 85)}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}):Play()
        end)
    end
    
    return Button
end

-- Create mobile-optimized sections
function CreateMobileSection(title, parent)
    local Section = Instance.new("Frame")
    Section.Name = title .. "Section"
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Section.BorderSizePixel = 0
    Section.Parent = parent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 10)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -20, 0, isMobile and 35 : 30)
    SectionTitle.Position = UDim2.new(0, 10, 0, 5)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextSize = isMobile and 16 : 15
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    local SectionContent = Instance.new("Frame")
    SectionContent.Size = UDim2.new(1, -20, 0, 0)
    SectionContent.Position = UDim2.new(0, 10, 0, isMobile and 45 : 40)
    SectionContent.BackgroundTransparency = 1
    SectionContent.Parent = Section
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, isMobile and 10 : 8)
    ContentLayout.Parent = SectionContent
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionContent.Size = UDim2.new(1, -20, 0, ContentLayout.AbsoluteContentSize.Y)
        Section.Size = UDim2.new(1, 0, 0, SectionContent.Size.Y.Offset + (isMobile and 50 : 45))
    end)
    
    return SectionContent
end

-- Create tab contents
local HomeContent = CreateMobileSection("Mobile Features", ContentScrolling)
CreateMobileButton(HomeContent, "🚀 Quick Execute All", function()
    -- Mobile-optimized feature
end)

CreateMobileButton(HomeContent, "⭐ Premium Mobile Tools", function()
    -- Mobile-specific tools
end)

local ScriptsContent = CreateMobileSection("Mobile Scripts", ContentScrolling)
CreateMobileButton(ScriptsContent, "⚡ Touch Optimized ESP", function()
    -- Touch-friendly ESP
end)

CreateMobileButton(ScriptsContent, "🎯 Mobile Aimbot", function()
    -- Mobile aimbot
end)

local PlayerContent = CreateMobileSection("Player Mods", ContentScrolling)
CreateMobileButton(PlayerContent, "💨 Mobile Speed", function()
    -- Mobile speed hack
end)

CreateMobileButton(PlayerContent, "🦘 Touch Jump", function()
    -- Mobile jump mod
end)

local VisualsContent = CreateMobileSection("Mobile Visuals", ContentScrolling)
CreateMobileButton(VisualsContent, "🌈 Mobile UI Theme", function()
    -- Mobile themes
end)

local SettingsContent = CreateMobileSection("Mobile Settings", ContentScrolling)
CreateMobileButton(SettingsContent, "⚙️ Touch Settings", function()
    -- Touch settings
end)

-- Tab switching function
function SwitchTab(tabName)
    -- Hide all sections
    for _, child in pairs(ContentScrolling:GetChildren()) do
        if child:IsA("Frame") and child.Name:match("Section$") then
            child.Visible = false
        end
    end
    
    -- Show selected section
    local targetSection = ContentScrolling:FindFirstChild(tabName .. "Section")
    if targetSection then
        targetSection.Visible = true
    end
    
    -- Update tab buttons
    for name, button in pairs(TabButtons) do
        if name == tabName then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 130, 200)}):Play()
            TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
            TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
    end
    
    SendNotification("Tab", "Switched to " .. tabName, 1)
end

-- Connect tab buttons
for name, button in pairs(TabButtons) do
    if isMobile then
        button.TouchTap:Connect(function()
            SwitchTab(name)
        end)
    else
        button.MouseButton1Click:Connect(function()
            SwitchTab(name)
        end)
    end
end

-- Mobile-optimized UI controls
HideButton.MouseButton1Click:Connect(function()
    MainContainer.Visible = not MainContainer.Visible
    SendNotification("UI", "GUI " .. (MainContainer.Visible and "shown" or "hidden"), 2)
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    SendNotification("UI", "Mobile GUI Closed", 2)
end)

-- Touch controls for header drag
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and dragging then
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Auto-resize content
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
end)

-- Initialize
SwitchTab("Home")

-- Platform-specific welcome message
if isMobile then
    SendNotification("Mobile Premium", "Touch-optimized GUI Ready!\nDrag header to move", 5)
else
    SendNotification("Premium GUI", "Desktop mode activated!", 3)
end

-- Mobile-specific optimizations
if isMobile then
    -- Larger touch targets
    -- Simplified interactions
    -- Mobile-appropriate sizing
end
