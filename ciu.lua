-- ============================================
-- DELTA FISHING HUB - Custom Premium UI
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- UI Colors
local Colors = {
    Primary = Color3.fromRGB(0, 184, 255),
    Secondary = Color3.fromRGB(30, 35, 45),
    Dark = Color3.fromRGB(20, 25, 35),
    Light = Color3.fromRGB(240, 245, 250),
    Success = Color3.fromRGB(0, 255, 136),
    Danger = Color3.fromRGB(255, 85, 85),
    Warning = Color3.fromRGB(255, 184, 0)
}

-- Main UI Container
local ScreenGui = Instance.new("ScreenGui")
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = game.CoreGui
end
ScreenGui.Name = "DeltaFishingHub"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.BackgroundColor3 = Colors.Dark
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner & Shadow
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 25, 35))
})
UIGradient.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Colors.Secondary
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12, 0, 0)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "⚡ DELTA FISHING HUB"
TitleLabel.Size = UDim2.new(0, 200, 0, 30)
TitleLabel.Position = UDim2.new(0, 15, 0.5, -15)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Colors.Light
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Text = "v3.0"
VersionLabel.Size = UDim2.new(0, 40, 0, 16)
VersionLabel.Position = UDim2.new(0, 180, 0.5, -8)
VersionLabel.BackgroundColor3 = Colors.Primary
VersionLabel.BackgroundTransparency = 0.2
VersionLabel.TextColor3 = Colors.Light
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextSize = 12
VersionLabel.Parent = TitleBar

local VersionCorner = Instance.new("UICorner")
VersionCorner.CornerRadius = UDim.new(0, 4)
VersionCorner.Parent = VersionLabel

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Text = "×"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
CloseButton.BackgroundColor3 = Colors.Danger
CloseButton.BackgroundTransparency = 0.2
CloseButton.TextColor3 = Colors.Light
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Text = "–"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -75, 0.5, -15)
MinimizeButton.BackgroundColor3 = Colors.Warning
MinimizeButton.BackgroundTransparency = 0.2
MinimizeButton.TextColor3 = Colors.Light
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Drag Functionality
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Tab System
local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(1, -20, 0, 40)
TabsContainer.Position = UDim2.new(0, 10, 0, 60)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = MainFrame

local Tabs = {}
local CurrentTab = nil

-- Content Container
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -110)
ContentFrame.Position = UDim2.new(0, 10, 0, 110)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- Create Tab Function
function CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(0, 100, 1, 0)
    TabButton.Position = UDim2.new(0, (#Tabs * 110), 0, 0)
    TabButton.BackgroundColor3 = Colors.Secondary
    TabButton.BackgroundTransparency = 0.5
    TabButton.Text = icon .. " " .. name
    TabButton.TextColor3 = Colors.Light
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 14
    TabButton.Parent = TabsContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.Position = UDim2.new(0, 0, 0, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 3
    TabContent.ScrollBarImageColor3 = Colors.Primary
    TabContent.Visible = false
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Parent = ContentFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = TabContent
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 5)
    Padding.PaddingLeft = UDim.new(0, 5)
    Padding.PaddingRight = UDim.new(0, 5)
    Padding.Parent = TabContent
    
    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab then
            CurrentTab.Button.BackgroundTransparency = 0.5
            CurrentTab.Content.Visible = false
            
            TweenService:Create(CurrentTab.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Colors.Secondary
            }):Play()
        end
        
        TabButton.BackgroundTransparency = 0
        TabContent.Visible = true
        
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Colors.Primary
        }):Play()
        
        CurrentTab = {
            Button = TabButton,
            Content = TabContent
        }
    end)
    
    local tabData = {
        Button = TabButton,
        Content = TabContent,
        CreateSection = function(title)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, -10, 0, 40)
            SectionFrame.BackgroundColor3 = Colors.Secondary
            SectionFrame.BackgroundTransparency = 0.9
            SectionFrame.Parent = TabContent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Text = "  " .. title
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.TextColor3 = Colors.Primary
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextSize = 16
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = SectionFrame
            
            return {
                Frame = SectionFrame,
                CreateToggle = function(config)
                    local ToggleFrame = Instance.new("Frame")
                    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
                    ToggleFrame.BackgroundColor3 = Colors.Dark
                    ToggleFrame.BackgroundTransparency = 0.8
                    ToggleFrame.Parent = TabContent
                    
                    local ToggleCorner = Instance.new("UICorner")
                    ToggleCorner.CornerRadius = UDim.new(0, 6)
                    ToggleCorner.Parent = ToggleFrame
                    
                    local ToggleLabel = Instance.new("TextLabel")
                    ToggleLabel.Text = "  " .. config.Name
                    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                    ToggleLabel.BackgroundTransparency = 1
                    ToggleLabel.TextColor3 = Colors.Light
                    ToggleLabel.Font = Enum.Font.Gotham
                    ToggleLabel.TextSize = 14
                    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                    ToggleLabel.Parent = ToggleFrame
                    
                    local ToggleButton = Instance.new("Frame")
                    ToggleButton.Size = UDim2.new(0, 50, 0, 26)
                    ToggleButton.Position = UDim2.new(1, -60, 0.5, -13)
                    ToggleButton.BackgroundColor3 = Colors.Danger
                    ToggleButton.Parent = ToggleFrame
                    
                    local ToggleCircle = Instance.new("Frame")
                    ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
                    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
                    ToggleCircle.BackgroundColor3 = Colors.Light
                    ToggleCircle.Parent = ToggleButton
                    
                    local ToggleCorner1 = Instance.new("UICorner")
                    ToggleCorner1.CornerRadius = UDim.new(1, 0)
                    ToggleCorner1.Parent = ToggleCircle
                    
                    local ToggleCorner2 = Instance.new("UICorner")
                    ToggleCorner2.CornerRadius = UDim.new(1, 0)
                    ToggleCorner2.Parent = ToggleButton
                    
                    local state = config.Default or false
                    
                    local function updateToggle()
                        if state then
                            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                                BackgroundColor3 = Colors.Success
                            }):Play()
                            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                                Position = UDim2.new(1, -23, 0.5, -10)
                            }):Play()
                        else
                            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                                BackgroundColor3 = Colors.Danger
                            }):Play()
                            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                                Position = UDim2.new(0, 3, 0.5, -10)
                            }):Play()
                        end
                        
                        if config.Callback then
                            config.Callback(state)
                        end
                    end
                    
                    ToggleFrame.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            state = not state
                            updateToggle()
                        end
                    end)
                    
                    updateToggle()
                    
                    return {
                        Set = function(value)
                            state = value
                            updateToggle()
                        end,
                        Get = function()
                            return state
                        end
                    }
                end,
                
                CreateButton = function(config)
                    local Button = Instance.new("TextButton")
                    Button.Size = UDim2.new(1, -10, 0, 40)
                    Button.BackgroundColor3 = Colors.Primary
                    Button.BackgroundTransparency = 0.2
                    Button.Text = config.Name
                    Button.TextColor3 = Colors.Light
                    Button.Font = Enum.Font.Gotham
                    Button.TextSize = 14
                    Button.Parent = TabContent
                    
                    local ButtonCorner = Instance.new("UICorner")
                    ButtonCorner.CornerRadius = UDim.new(0, 8)
                    ButtonCorner.Parent = Button
                    
                    Button.MouseButton1Click:Connect(function()
                        TweenService:Create(Button, TweenInfo.new(0.1), {
                            BackgroundTransparency = 0
                        }):Play()
                        if config.Callback then
                            config.Callback()
                        end
                        task.wait(0.1)
                        TweenService:Create(Button, TweenInfo.new(0.1), {
                            BackgroundTransparency = 0.2
                        }):Play()
                    end)
                end,
                
                CreateSlider = function(config)
                    local SliderFrame = Instance.new("Frame")
                    SliderFrame.Size = UDim2.new(1, -10, 0, 60)
                    SliderFrame.BackgroundColor3 = Colors.Dark
                    SliderFrame.BackgroundTransparency = 0.8
                    SliderFrame.Parent = TabContent
                    
                    local SliderCorner = Instance.new("UICorner")
                    SliderCorner.CornerRadius = UDim.new(0, 6)
                    SliderCorner.Parent = SliderFrame
                    
                    local SliderLabel = Instance.new("TextLabel")
                    SliderLabel.Text = "  " .. config.Name
                    SliderLabel.Size = UDim2.new(1, 0, 0, 25)
                    SliderLabel.BackgroundTransparency = 1
                    SliderLabel.TextColor3 = Colors.Light
                    SliderLabel.Font = Enum.Font.Gotham
                    SliderLabel.TextSize = 14
                    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                    SliderLabel.Parent = SliderFrame
                    
                    local ValueLabel = Instance.new("TextLabel")
                    ValueLabel.Text = tostring(config.Default or config.Min) .. (config.Suffix or "")
                    ValueLabel.Size = UDim2.new(0, 60, 0, 25)
                    ValueLabel.Position = UDim2.new(1, -65, 0, 0)
                    ValueLabel.BackgroundTransparency = 1
                    ValueLabel.TextColor3 = Colors.Primary
                    ValueLabel.Font = Enum.Font.GothamBold
                    ValueLabel.TextSize = 14
                    ValueLabel.Parent = SliderFrame
                    
                    local SliderTrack = Instance.new("Frame")
                    SliderTrack.Size = UDim2.new(1, -20, 0, 6)
                    SliderTrack.Position = UDim2.new(0, 10, 1, -25)
                    SliderTrack.BackgroundColor3 = Colors.Secondary
                    SliderTrack.Parent = SliderFrame
                    
                    local TrackCorner = Instance.new("UICorner")
                    TrackCorner.CornerRadius = UDim.new(1, 0)
                    TrackCorner.Parent = SliderTrack
                    
                    local SliderFill = Instance.new("Frame")
                    SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
                    SliderFill.BackgroundColor3 = Colors.Primary
                    SliderFill.Parent = SliderTrack
                    
                    local FillCorner = Instance.new("UICorner")
                    FillCorner.CornerRadius = UDim.new(1, 0)
                    FillCorner.Parent = SliderFill
                    
                    local SliderButton = Instance.new("TextButton")
                    SliderButton.Size = UDim2.new(0, 16, 0, 16)
                    SliderButton.BackgroundColor3 = Colors.Light
                    SliderButton.Text = ""
                    SliderButton.Parent = SliderFrame
                    
                    local ButtonCorner = Instance.new("UICorner")
                    ButtonCorner.CornerRadius = UDim.new(1, 0)
                    ButtonCorner.Parent = SliderButton
                    
                    local min = config.Min or 0
                    local max = config.Max or 100
                    local value = config.Default or min
                    local dragging = false
                    
                    local function updateSlider()
                        local percent = (value - min) / (max - min)
                        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                        SliderButton.Position = UDim2.new(percent, -8, 1, -28)
                        ValueLabel.Text = string.format("%.1f", value) .. (config.Suffix or "")
                        
                        if config.Callback then
                            config.Callback(value)
                        end
                    end
                    
                    updateSlider()
                    
                    SliderButton.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                        end
                    end)
                    
                    SliderButton.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local pos = input.Position.X - SliderTrack.AbsolutePosition.X
                            local percent = math.clamp(pos / SliderTrack.AbsoluteSize.X, 0, 1)
                            value = min + (max - min) * percent
                            updateSlider()
                        end
                    end)
                end
            }
        end
    }
    
    table.insert(Tabs, tabData)
    
    if #Tabs == 1 then
        TabButton.BackgroundTransparency = 0
        TabContent.Visible = true
        CurrentTab = tabData
        
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Colors.Primary
        }):Play()
    end
    
    return tabData
end

-- Create Notification System
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.new(0, 300, 1, -20)
NotificationFrame.Position = UDim2.new(1, 10, 0, 10)
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.Parent = ScreenGui

local NotificationsList = Instance.new("UIListLayout")
NotificationsList.Padding = UDim.new(0, 10)
NotificationsList.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationsList.Parent = NotificationFrame

function Notify(title, message, color)
    color = color or Colors.Primary
    
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0, 280, 0, 80)
    Notification.BackgroundColor3 = Colors.Dark
    Notification.BackgroundTransparency = 0.05
    Notification.Parent = NotificationFrame
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = Notification
    
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 5, 1, 0)
    Accent.BackgroundColor3 = color
    Accent.Parent = Notification
    
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(0, 8, 0, 0)
    AccentCorner.Parent = Accent
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Size = UDim2.new(1, -15, 0, 25)
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Colors.Light
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notification
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Text = message
    MessageLabel.Size = UDim2.new(1, -15, 0, 35)
    MessageLabel.Position = UDim2.new(0, 15, 0, 35)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextSize = 13
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextWrapped = true
    MessageLabel.Parent = Notification
    
    Notification:TweenPosition(UDim2.new(1, -290, 0, Notification.Position.Y.Offset), "Out", "Quad", 0.3)
    
    task.wait(3)
    
    Notification:TweenPosition(UDim2.new(1, 10, 0, Notification.Position.Y.Offset), "Out", "Quad", 0.3)
    task.wait(0.3)
    Notification:Destroy()
end

-- Create Tabs
local MainTab = CreateTab("Main", "🏠")
local AutoTab = CreateTab("Auto", "⚡")
local SettingsTab = CreateTab("Settings", "⚙️")

-- Main Tab Content
MainTab.CreateSection("Status Panel")

local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(1, -10, 0, 150)
StatsFrame.BackgroundColor3 = Colors.Secondary
StatsFrame.BackgroundTransparency = 0.8
StatsFrame.Parent = MainTab.Content

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 8)
StatsCorner.Parent = StatsFrame

-- Stats Grid
for i = 1, 4 do
    local StatBox = Instance.new("Frame")
    StatBox.Size = UDim2.new(0.48, -5, 0.48, -5)
    StatBox.Position = UDim2.new((i-1)%2*0.52, 5, math.floor((i-1)/2)*0.52, 5)
    StatBox.BackgroundColor3 = Colors.Dark
    StatBox.BackgroundTransparency = 0.9
    StatBox.Parent = StatsFrame
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = StatBox
end

local CatchesLabel = Instance.new("TextLabel")
CatchesLabel.Text = "0\nCatches"
CatchesLabel.Size = UDim2.new(1, 0, 1, 0)
CatchesLabel.BackgroundTransparency = 1
CatchesLabel.TextColor3 = Colors.Success
CatchesLabel.Font = Enum.Font.GothamBold
CatchesLabel.TextSize = 20
CatchesLabel.TextWrapped = true
CatchesLabel.Parent = StatsFrame:FindFirstChild("Frame")

-- Quick Controls
MainTab.CreateSection("Quick Controls")

local AutoFishToggle = MainTab.CreateSection("").CreateToggle({
    Name = "Auto Fishing",
    Default = false,
    Callback = function(state)
        Notify("Auto Fishing", state and "Started fishing" or "Stopped fishing", state and Colors.Success or Colors.Danger)
    end
})

MainTab.CreateSection("").CreateButton({
    Name = "🎣 Cast Now",
    Callback = function()
        Notify("Manual Cast", "Casting fishing rod...", Colors.Primary)
    end
})

-- Auto Tab Content
AutoTab.CreateSection("Blatant Fishing")

local BlatantToggle = AutoTab.CreateSection("").CreateToggle({
    Name = "Blatant Mode",
    Default = false,
    Callback = function(state)
        Notify("Blatant Mode", state and "Bypass activated" or "Bypass disabled", state and Colors.Warning or Colors.Danger)
    end
})

AutoTab.CreateSection("Timing Settings")

AutoTab.CreateSection("").CreateSlider({
    Name = "Reel Delay",
    Min = 0,
    Max = 1.87,
    Default = 0.5,
    Suffix = "s",
    Callback = function(value)
        Notify("Reel Delay", "Set to " .. value .. "s", Colors.Primary)
    end
})

AutoTab.CreateSection("").CreateSlider({
    Name = "Fishing Delay",
    Min = 1,
    Max = 100,
    Default = 15,
    Suffix = "ms",
    Callback = function(value)
        Notify("Fishing Delay", "Set to " .. value .. "ms", Colors.Primary)
    end
})

AutoTab.CreateSection("Actions")

AutoTab.CreateSection("").CreateButton({
    Name = "Initialize System",
    Callback = function()
        Notify("System", "Initializing fishing system...", Colors.Success)
    end
})

-- Settings Tab Content
SettingsTab.CreateSection("UI Settings")

SettingsTab.CreateSection("").CreateSlider({
    Name = "UI Transparency",
    Min = 0,
    Max = 1,
    Default = 0.05,
    Suffix = "%",
    Callback = function(value)
        MainFrame.BackgroundTransparency = value
    end
})

SettingsTab.CreateSection("").CreateButton({
    Name = "Change Theme Color",
    Callback = function()
        Colors.Primary = Color3.fromHSV(math.random(), 0.8, 1)
        Notify("Theme", "Changed theme color", Colors.Primary)
    end
})

-- Button Functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Toggle UI Keybind
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Initial Notification
task.wait(1)
Notify("Delta Fishing", "UI Loaded Successfully!\nPress RightControl to toggle", Colors.Success)

-- Export API
return {
    Notify = Notify,
    ToggleUI = function()
        MainFrame.Visible = not MainFrame.Visible
    end,
    GetToggle = function(name)
        if name == "AutoFish" then
            return AutoFishToggle
        elseif name == "Blatant" then
            return BlatantToggle
        end
    end
}
