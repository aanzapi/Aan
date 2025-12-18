--[[=====================================================
  MODERN BASE UI LUA (ROBLOX EXECUTOR)
  Struktur:
  1. ScreenGui
  2. MainFrame
  3. TitleBar (Drag, Minimize, Close)
  4. TabContainer
  5. ContentContainer
  6. UI Components
  7. Notification System
  8. Keybind System
  9. Configuration System
  10. Visual Enhancements
=====================================================]]

--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

--// MainFrame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.fromScale(0.45, 0.55)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BorderSizePixel = 0

--// Corner + Shadow
local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 14)

local Shadow = Instance.new("ImageLabel", MainFrame)
Shadow.Name = "Shadow"
Shadow.BackgroundTransparency = 1
Shadow.Size = UDim2.fromScale(1.1, 1.15)
Shadow.Position = UDim2.fromScale(-0.05, -0.05)
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageTransparency = 0.4
Shadow.ZIndex = 0

--// TitleBar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TitleBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Text = "Modern Executor UI"
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextXAlignment = Left
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

--// Buttons
local function TitleButton(text, pos)
    local btn = Instance.new("TextButton")
    btn.Parent = TitleBar
    btn.Text = text
    btn.Size = UDim2.new(0, 35, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(45,45,55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    return btn
end

local Minimize = TitleButton("–", UDim2.new(1,-80,0.5,-15))
local Close = TitleButton("X", UDim2.new(1,-40,0.5,-15))

--// Drag System
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

--// TabContainer
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.Size = UDim2.new(0, 140, 1, -45)
TabContainer.Position = UDim2.new(0, 0, 0, 45)
TabContainer.BackgroundColor3 = Color3.fromRGB(25,25,32)
TabContainer.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout", TabContainer)
TabLayout.Padding = UDim.new(0,8)

--// ContentContainer
local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.Size = UDim2.new(1, -140, 1, -45)
ContentContainer.Position = UDim2.new(0, 140, 0, 45)
ContentContainer.BackgroundTransparency = 1

--// UI Components API
local Components = {}

function Components:Button(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0,200,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,60)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

function Components:Toggle(parent, text, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Parent = parent
    toggle.Size = UDim2.new(0,200,0,40)
    toggle.BackgroundColor3 = Color3.fromRGB(45,45,60)
    toggle.Text = text .. ": OFF"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    Instance.new("UICorner", toggle)

    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = text .. (state and ": ON" or ": OFF")
        callback(state)
    end)
end

--// Notification System
local function Notify(msg)
    local note = Instance.new("TextLabel", ScreenGui)
    note.Size = UDim2.new(0,300,0,40)
    note.Position = UDim2.new(1,-320,1,-60)
    note.BackgroundColor3 = Color3.fromRGB(35,35,45)
    note.Text = msg
    note.TextColor3 = Color3.new(1,1,1)
    note.Font = Enum.Font.Gotham
    note.TextSize = 14
    Instance.new("UICorner", note)
    task.delay(2,function() note:Destroy() end)
end

--// Keybind System
local ToggleKey = Enum.KeyCode.RightShift
UIS.InputBegan:Connect(function(input,gp)
    if not gp and input.KeyCode == ToggleKey then
        MainFrame.Visible = not MainFrame.Visible
        Notify("UI Toggled")
    end
end)

--// Configuration System (Simple)
local Config = {}
function Config:Save(name, data)
    writefile(name..".json", game:GetService("HttpService"):JSONEncode(data))
end
function Config:Load(name)
    return game:GetService("HttpService"):JSONDecode(readfile(name..".json"))
end

--// Close & Minimize
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

Minimize.MouseButton1Click:Connect(function()
    ContentContainer.Visible = not ContentContainer.Visible
    TabContainer.Visible = ContentContainer.Visible
end)

Notify("Modern UI Loaded")
