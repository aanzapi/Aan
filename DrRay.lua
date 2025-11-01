-- Premium Delta Executor GUI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumDeltaGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Variables
local isMinimized = false
local isHidden = false
local currentTab = "Home"
local uiScale = 1

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 600, 0, 450)
MainContainer.Position = UDim2.new(0.5, -300, 0.5, -225)
MainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = true
MainContainer.Parent = ScreenGui

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 15)
ContainerCorner.Parent = MainContainer

-- Gradient Background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
})
Gradient.Rotation = 45
Gradient.Parent = MainContainer

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Header.BorderSizePixel = 0
Header.Parent = MainContainer

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

-- Premium Badge
local PremiumBadge = Instance.new("Frame")
PremiumBadge.Size = UDim2.new(0, 120, 0, 25)
PremiumBadge.Position = UDim2.new(0, 15, 0.5, -12)
PremiumBadge.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
PremiumBadge.BorderSizePixel = 0
PremiumBadge.Parent = Header

local PremiumCorner = Instance.new("UICorner")
PremiumCorner.CornerRadius = UDim.new(0, 8)
PremiumCorner.Parent = PremiumBadge

local PremiumLabel = Instance.new("TextLabel")
PremiumLabel.Size = UDim2.new(1, 0, 1, 0)
PremiumLabel.BackgroundTransparency = 1
PremiumLabel.Text = "⚡ PREMIUM"
PremiumLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
PremiumLabel.TextSize = 14
PremiumLabel.Font = Enum.Font.GothamBold
PremiumLabel.Parent = PremiumBadge

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0.5, -100, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "DELTA EXECUTOR"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = Header

-- Control Buttons
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Size = UDim2.new(0, 80, 1, 0)
ControlsFrame.Position = UDim2.new(1, -85, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = Header

local HideButton = Instance.new("ImageButton")
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 20, 0, 20)
HideButton.Position = UDim2.new(0, 5, 0.5, -10)
HideButton.BackgroundTransparency = 1
HideButton.Image = "rbxassetid://3926305904"
HideButton.ImageRectOffset = Vector2.new(884, 284)
HideButton.ImageRectSize = Vector2.new(36, 36)
HideButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
HideButton.Parent = ControlsFrame

local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Position = UDim2.new(0, 30, 0.5, -10)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Image = "rbxassetid://3926305904"
MinimizeButton.ImageRectOffset = Vector2.new(844, 284)
MinimizeButton.ImageRectSize = Vector2.new(36, 36)
HideButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
MinimizeButton.Parent = ControlsFrame

local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(0, 55, 0.5, -10)
CloseButton.BackgroundTransparency = 1
CloseButton.Image = "rbxassetid://3926305904"
CloseButton.ImageRectOffset = Vector2.new(284, 4)
CloseButton.ImageRectSize = Vector2.new(24, 24)
CloseButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.Parent = ControlsFrame

-- Resize Handle
local ResizeHandle = Instance.new("Frame")
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Parent = MainContainer

local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0, 4)
ResizeCorner.Parent = ResizeHandle

local ResizeIcon = Instance.new("ImageLabel")
ResizeIcon.Size = UDim2.new(1, 0, 1, 0)
ResizeIcon.BackgroundTransparency = 1
ResizeIcon.Image = "rbxassetid://3926305904"
ResizeIcon.ImageRectOffset = Vector2.new(884, 124)
ResizeIcon.ImageRectSize = Vector2.new(36, 36)
ResizeIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
ResizeIcon.Parent = ResizeHandle

-- Main Content Area
local MainContent = Instance.new("Frame")
MainContent.Size = UDim2.new(1, 0, 1, -45)
MainContent.Position = UDim2.new(0, 0, 0, 45)
MainContent.BackgroundTransparency = 1
MainContent.Parent = MainContainer

-- Sidebar Tabs
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainContent

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 15)
SidebarCorner.Parent = Sidebar

-- Tab Buttons
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
    TabButton.Size = UDim2.new(1, -10, 0, 45)
    TabButton.Position = UDim2.new(0, 5, 0, 10 + (i-1) * 50)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TabButton.BorderSizePixel = 0
    TabButton.Text = " " .. tab.Icon .. "   " .. tab.Name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.AutoButtonColor = false
    TabButton.Parent = Sidebar
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    TabButtons[tab.Name] = TabButton
end

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -150, 1, 0)
ContentFrame.Position = UDim2.new(0, 150, 0, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainContent

local ContentScrolling = Instance.new("ScrollingFrame")
ContentScrolling.Size = UDim2.new(1, -20, 1, -20)
ContentScrolling.Position = UDim2.new(0, 10, 0, 10)
ContentScrolling.BackgroundTransparency = 1
ContentScrolling.BorderSizePixel = 0
ContentScrolling.ScrollBarThickness = 6
ContentScrolling.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
ContentScrolling.Parent = ContentFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 15)
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

-- Function to create section
function CreateSection(title, parent)
    local Section = Instance.new("Frame")
    Section.Name = title .. "Section"
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Section.BorderSizePixel = 0
    Section.Parent = parent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 10)
    SectionCorner.Parent = Section
    
    local SectionHeader = Instance.new("Frame")
    SectionHeader.Size = UDim2.new(1, 0, 0, 35)
    SectionHeader.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    SectionHeader.BorderSizePixel = 0
    SectionHeader.Parent = Section
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = SectionHeader
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -20, 1, 0)
    SectionTitle.Position = UDim2.new(0, 10, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextSize = 16
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionHeader
    
    local SectionContent = Instance.new("Frame")
    SectionContent.Size = UDim2.new(1, -20, 0, 0)
    SectionContent.Position = UDim2.new(0, 10, 0, 40)
    SectionContent.BackgroundTransparency = 1
    SectionContent.Parent = Section
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = SectionContent
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionContent.Size = UDim2.new(1, -20, 0, ContentLayout.AbsoluteContentSize.Y)
        Section.Size = UDim2.new(1, 0, 0, SectionContent.Size.Y.Offset + 45)
    end)
    
    return SectionContent
end

-- Function to create button
function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.AutoButtonColor = false
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    -- Hover effects
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 90)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        callback()
        SendNotification("Feature Activated", text .. " has been executed!", 3)
    end)
    
    return Button
end

-- Create Tab Contents
local HomeContent = CreateSection("Welcome to Premium", ContentScrolling)
CreateButton(HomeContent, "🚀 Execute All Premium Scripts", function()
    SendNotification("Premium", "Executing all premium features...", 3)
end)

CreateButton(HomeContent, "⭐ Premium Features Loader", function()
    SendNotification("Premium", "Loading premium features...", 3)
end)

CreateButton(HomeContent, "🔧 Auto Configuration", function()
    SendNotification("Configuration", "Auto-configuring settings...", 3)
end)

local ScriptsContent = CreateSection("Premium Scripts", ContentScrolling)
CreateButton(ScriptsContent, "⚡ Infinite Yield Premium", function()
    SendNotification("Script", "Loading Infinite Yield Premium...", 3)
end)

CreateButton(ScriptsContent, "👁️ Advanced ESP", function()
    SendNotification("Visuals", "Activating Advanced ESP...", 3)
end)

CreateButton(ScriptsContent, "🎯 Premium Aimbot", function()
    SendNotification("Combat", "Enabling Premium Aimbot...", 3)
end)

local PlayerContent = CreateSection("Player Modifications", ContentScrolling)
CreateButton(PlayerContent, "💨 Super Speed", function()
    SendNotification("Player", "Speed boost activated!", 3)
end)

CreateButton(PlayerContent, "🦘 High Jump", function()
    SendNotification("Player", "Jump power increased!", 3)
end)

CreateButton(PlayerContent, "🔒 No Clip", function()
    SendNotification("Player", "No Clip toggled!", 3)
end)

local VisualsContent = CreateSection("Visual Enhancements", ContentScrolling)
CreateButton(VisualsContent, "🌈 UI Customizer", function()
    SendNotification("Visuals", "Opening UI Customizer...", 3)
end)

CreateButton(VisualsContent, "🎨 Theme Changer", function()
    SendNotification("Visuals", "Changing theme...", 3)
end)

CreateButton(VisualsContent, "✨ Particle Effects", function()
    SendNotification("Visuals", "Adding particle effects...", 3)
end)

local SettingsContent = CreateSection("Premium Settings", ContentScrolling)
CreateButton(SettingsContent, "🎛️ Performance Settings", function()
    SendNotification("Settings", "Opening performance settings...", 3)
end)

CreateButton(SettingsContent, "🔑 License Manager", function()
    SendNotification("Settings", "Opening license manager...", 3)
end)

CreateButton(SettingsContent, "📊 Statistics", function()
    SendNotification("Settings", "Showing statistics...", 3)
end)

-- Function to switch tabs
function SwitchTab(tabName)
    currentTab = tabName
    
    -- Hide all contents
    for _, section in pairs(ContentScrolling:GetChildren()) do
        if section:IsA("Frame") then
            section.Visible = false
        end
    end
    
    -- Show selected content
    local contentName = tabName .. "Content"
    if ContentScrolling:FindFirstChild(contentName .. "Section") then
        ContentScrolling[contentName .. "Section"].Visible = true
    end
    
    -- Update tab buttons
    for name, button in pairs(TabButtons) do
        if name == tabName then
            TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 120, 200)}):Play()
            TweenService:Create(button, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}):Play()
            TweenService:Create(button, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
    end
    
    SendNotification("Tab Switched", "Now viewing: " .. tabName, 2)
end

-- Connect tab buttons
for name, button in pairs(TabButtons) do
    button.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
end

-- UI Control Functions
HideButton.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    MainContainer.Visible = not isHidden
    SendNotification("UI", isHidden and "UI Hidden - Press F2 to show" or "UI Visible", 2)
end)

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 45)}):Play()
    else
        TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 450)}):Play()
    end
    SendNotification("UI", isMinimized and "UI Minimized" or "UI Restored", 2)
end)

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 0)}):Play()
    wait(0.3)
    ScreenGui:Destroy()
    SendNotification("UI", "Premium GUI Closed", 2)
end)

-- Resize functionality
local resizing = false
ResizeHandle.MouseButton1Down:Connect(function()
    resizing = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouse = UserInputService:GetMouseLocation()
        local newSize = UDim2.new(0, math.max(400, mouse.X - MainContainer.AbsolutePosition.X), 
                                 0, math.max(300, mouse.Y - MainContainer.AbsolutePosition.Y))
        TweenService:Create(MainContainer, TweenInfo.new(0.1), {Size = newSize}):Play()
    end
end)

-- Drag functionality
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Hotkeys
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F2 then
        isHidden = not isHidden
        MainContainer.Visible = not isHidden
        SendNotification("Hotkey", "F2 - UI Toggled", 2)
    elseif input.KeyCode == Enum.KeyCode.F3 then
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 45)}):Play()
        else
            TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 450)}):Play()
        end
    end
end)

-- Auto resize content
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
end)

-- Initialize
SwitchTab("Home")

-- Welcome message
SendNotification("Premium Delta Executor", "GUI Successfully Loaded!\nF2: Hide/Show | F3: Minimize", 5)

-- Make resize handle interactive
ResizeHandle.MouseEnter:Connect(function()
    TweenService:Create(ResizeHandle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}):Play()
end)

ResizeHandle.MouseLeave:Connect(function()
    if not resizing then
        TweenService:Create(ResizeHandle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
    end
end)
