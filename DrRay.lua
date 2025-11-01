-- Delta Executor Modern GUI with Hamburger Menu
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaModernGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Variables
local isMinimized = false
local isCollapsed = false
local currentPage = "Home"

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 350, 0, 500)
MainContainer.Position = UDim2.new(0, 20, 0.5, -250)
MainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = true
MainContainer.Parent = ScreenGui

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 12)
ContainerCorner.Parent = MainContainer

local ContainerShadow = Instance.new("ImageLabel")
ContainerShadow.Name = "ContainerShadow"
ContainerShadow.Size = UDim2.new(1, 0, 1, 0)
ContainerShadow.BackgroundTransparency = 1
ContainerShadow.Image = "rbxassetid://1316045217"
ContainerShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
ContainerShadow.ImageTransparency = 0.8
ContainerShadow.ScaleType = Enum.ScaleType.Slice
ContainerShadow.SliceCenter = Rect.new(10, 10, 118, 118)
ContainerShadow.Parent = MainContainer

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Header.BorderSizePixel = 0
Header.Parent = MainContainer

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Hamburger Menu Button
local HamburgerButton = Instance.new("ImageButton")
HamburgerButton.Name = "HamburgerButton"
HamburgerButton.Size = UDim2.new(0, 30, 0, 30)
HamburgerButton.Position = UDim2.new(0, 15, 0.5, -15)
HamburgerButton.BackgroundTransparency = 1
HamburgerButton.Image = "rbxassetid://3926305904"
HamburgerButton.ImageRectOffset = Vector2.new(524, 204)
HamburgerButton.ImageRectSize = Vector2.new(36, 36)
HamburgerButton.ImageColor3 = Color3.fromRGB(220, 220, 220)
HamburgerButton.Parent = Header

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 60, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "DELTA EXECUTOR"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Minimize Button
local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Position = UDim2.new(1, -45, 0.5, -10)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Image = "rbxassetid://3926305904"
MinimizeButton.ImageRectOffset = Vector2.new(884, 284)
MinimizeButton.ImageRectSize = Vector2.new(36, 36)
MinimizeButton.ImageColor3 = Color3.fromRGB(220, 220, 220)
MinimizeButton.Parent = Header

-- Close Button
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -20, 0.5, -10)
CloseButton.BackgroundTransparency = 1
CloseButton.Image = "rbxassetid://3926305904"
CloseButton.ImageRectOffset = Vector2.new(284, 4)
CloseButton.ImageRectSize = Vector2.new(24, 24)
CloseButton.ImageColor3 = Color3.fromRGB(220, 220, 220)
CloseButton.Parent = Header

-- Sidebar (Navigation)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 200, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainContainer

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

-- Navigation Items
local NavigationItems = {
    {Name = "Home", Icon = "🔮"},
    {Name = "Scripts", Icon = "⚡"},
    {Name = "Player", Icon = "👤"},
    {Name = "Teleport", Icon = "📍"},
    {Name = "Visuals", Icon = "👁️"},
    {Name = "Settings", Icon = "⚙️"}
}

local NavigationButtons = {}

for i, item in ipairs(NavigationItems) do
    local NavButton = Instance.new("TextButton")
    NavButton.Name = item.Name .. "Button"
    NavButton.Size = UDim2.new(1, -20, 0, 40)
    NavButton.Position = UDim2.new(0, 10, 0, 10 + (i-1) * 50)
    NavButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    NavButton.BorderSizePixel = 0
    NavButton.Text = " " .. item.Icon .. "   " .. item.Name
    NavButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    NavButton.TextSize = 14
    NavButton.Font = Enum.Font.Gotham
    NavButton.TextXAlignment = Enum.TextXAlignment.Left
    NavButton.AutoButtonColor = false
    NavButton.Parent = Sidebar
    
    local NavCorner = Instance.new("UICorner")
    NavCorner.CornerRadius = UDim.new(0, 8)
    NavCorner.Parent = NavButton
    
    -- Hover effects
    NavButton.MouseEnter:Connect(function()
        if currentPage ~= item.Name then
            TweenService:Create(NavButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
        end
    end)
    
    NavButton.MouseLeave:Connect(function()
        if currentPage ~= item.Name then
            TweenService:Create(NavButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
        end
    end)
    
    NavigationButtons[item.Name] = NavButton
end

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -200, 1, -50)
ContentFrame.Position = UDim2.new(0, 200, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainContainer

local ContentScrolling = Instance.new("ScrollingFrame")
ContentScrolling.Name = "ContentScrolling"
ContentScrolling.Size = UDim2.new(1, 0, 1, 0)
ContentScrolling.BackgroundTransparency = 1
ContentScrolling.BorderSizePixel = 0
ContentScrolling.ScrollBarThickness = 6
ContentScrolling.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ContentScrolling.Parent = ContentFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.Parent = ContentScrolling

-- Pages Content
local Pages = {}

-- Function to create section
function CreateSection(parent, title)
    local Section = Instance.new("Frame")
    Section.Name = title .. "Section"
    Section.Size = UDim2.new(1, -20, 0, 0)
    Section.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Section.BorderSizePixel = 0
    Section.Parent = parent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "SectionTitle"
    SectionTitle.Size = UDim2.new(1, 0, 0, 30)
    SectionTitle.Position = UDim2.new(0, 10, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextSize = 16
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    local SectionContent = Instance.new("Frame")
    SectionContent.Name = "SectionContent"
    SectionContent.Size = UDim2.new(1, -20, 0, 0)
    SectionContent.Position = UDim2.new(0, 10, 0, 35)
    SectionContent.BackgroundTransparency = 1
    SectionContent.Parent = Section
    
    local SectionLayout = Instance.new("UIListLayout")
    SectionLayout.Padding = UDim.new(0, 8)
    SectionLayout.Parent = SectionContent
    
    SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionContent.Size = UDim2.new(1, -20, 0, SectionLayout.AbsoluteContentSize.Y)
        Section.Size = UDim2.new(1, -20, 0, SectionContent.Size.Y.Offset + 40)
    end)
    
    return SectionContent
end

-- Function to create button
function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
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
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
    end)
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

-- Create Home Page
local HomeContent = CreateSection(ContentScrolling, "Welcome")
CreateButton(HomeContent, "🔄 Execute All Scripts", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGui/main/FlyGui.lua"))()
end)

CreateButton(HomeContent, "⚡ Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

CreateButton(HomeContent, "🚀 Fly GUI", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGui/main/FlyGui.lua"))()
end)

-- Create Scripts Page
local ScriptsContent = CreateSection(ContentScrolling, "Popular Scripts")
CreateButton(ScriptsContent, "👁️ ESP Players", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua"))()
end)

CreateButton(ScriptsContent, "🎯 AimBot", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/FE-Aimbot/main/main.lua"))()
end)

CreateButton(ScriptsContent, "🛡️ Anti AFK", function()
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- Create Player Page  
local PlayerContent = CreateSection(ContentScrolling, "Player Modifications")
CreateButton(PlayerContent, "💨 Speed Hack (50)", function()
    LocalPlayer.Character.Humanoid.WalkSpeed = 50
end)

CreateButton(PlayerContent, "🦘 High Jump (100)", function()
    LocalPlayer.Character.Humanoid.JumpPower = 100
end)

CreateButton(PlayerContent, "🔒 No Clip", function()
    local noclip = false
    game:GetService("RunService").Stepped:Connect(function()
        if noclip then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(11)
        end
    end)
end)

CreateButton(PlayerContent, "🔄 Reset Character", function()
    LocalPlayer.Character:BreakJoints()
end)

-- Function to switch pages
function SwitchPage(pageName)
    currentPage = pageName
    
    -- Reset all buttons
    for name, button in pairs(NavigationButtons) do
        if name == pageName then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 120, 200)}):Play()
            TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
    end
    
    -- Show notification
    game.StarterGui:SetCore("SendNotification", {
        Title = "Delta GUI",
        Text = "Switched to " .. pageName,
        Duration = 2
    })
end

-- Connect navigation buttons
for name, button in pairs(NavigationButtons) do
    button.MouseButton1Click:Connect(function()
        SwitchPage(name)
    end)
end

-- Hamburger Menu Toggle
HamburgerButton.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    
    if isCollapsed then
        -- Collapse sidebar
        TweenService:Create(Sidebar, TweenInfo.new(0.3), {Size = UDim2.new(0, 60, 1, -50)}):Play()
        TweenService:Create(ContentFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -60, 1, -50)}):Play()
        TweenService:Create(ContentFrame, TweenInfo.new(0.3), {Position = UDim2.new(0, 60, 0, 50)}):Play()
        
        -- Hide text in nav buttons
        for _, button in pairs(NavigationButtons) do
            local icon = string.sub(button.Text, 1, 3)
            button.Text = icon
        end
    else
        -- Expand sidebar
        TweenService:Create(Sidebar, TweenInfo.new(0.3), {Size = UDim2.new(0, 200, 1, -50)}):Play()
        TweenService:Create(ContentFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -200, 1, -50)}):Play()
        TweenService:Create(ContentFrame, TweenInfo.new(0.3), {Position = UDim2.new(0, 200, 0, 50)}):Play()
        
        -- Show full text in nav buttons
        for name, button in pairs(NavigationButtons) do
            for _, item in ipairs(NavigationItems) do
                if item.Name == name then
                    button.Text = " " .. item.Icon .. "   " .. item.Name
                end
            end
        end
    end
end)

-- Minimize/Maximize functionality
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Minimize to just header
        TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 50)}):Play()
        MinimizeButton.ImageRectOffset = Vector2.new(844, 284) -- Restore icon
    else
        -- Restore to full size
        TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 500)}):Play()
        MinimizeButton.ImageRectOffset = Vector2.new(884, 284) -- Minimize icon
    end
end)

-- Close GUI
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 0)}):Play()
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Auto resize content
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
end)

-- Make window draggable
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

-- Toggle GUI with F1 key
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        MainContainer.Visible = not MainContainer.Visible
    end
end)

-- Initial setup
SwitchPage("Home")

-- Welcome notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Delta Executor",
    Text = "GUI Loaded! F1 to toggle, Drag to move",
    Duration = 5,
    Icon = "rbxassetid://13378057870"
})
