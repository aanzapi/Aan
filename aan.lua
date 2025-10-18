--[[
===========================================================
    Base UI Deluxe Version (Premium Style)
    Dibuat oleh aanstok & ChatGPT
    Fitur:
    - Blur background halus
    - Fade-in/out animasi
    - Icon di setiap tab
    - Tombol Close & Hide
===========================================================
]]

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Bersihkan UI lama
for _, ui in ipairs({"BaseUI", "HideButton"}) do
    if CoreGui:FindFirstChild(ui) then
        CoreGui[ui]:Destroy()
    end
end

-- === Efek Blur ===
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

local function TweenBlur(target)
    TweenService:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = target}):Play()
end

-- === ScreenGui ===
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "BaseUI"

-- === Frame Utama ===
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(80, 80, 80)
UIStroke.Thickness = 1.4

-- Fade in animasi
TweenService:Create(MainFrame, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()
TweenBlur(10)

-- === Header ===
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "⚡ Base UI Deluxe"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- === Tombol Close ===
local CloseButton = Instance.new("TextButton", Header)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
CloseButton.Text = "×"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CloseButton.BackgroundTransparency = 0.2

local CloseCorner = Instance.new("UICorner", CloseButton)
CloseCorner.CornerRadius = UDim.new(1, 0)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
end)

-- === Navigasi Tab ===
local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Size = UDim2.new(1, 0, 0, 40)
TabHolder.Position = UDim2.new(0, 0, 0, 50)
TabHolder.BackgroundTransparency = 1

local Tabs = {}
local TabIcons = {
    Home = "🏠",
    Settings = "⚙️",
    About = "💡"
}
local TabNames = {"Home", "Settings", "About"}
local CurrentTab = nil

for i, name in ipairs(TabNames) do
    local TabButton = Instance.new("TextButton", TabHolder)
    TabButton.Size = UDim2.new(0, 120, 1, 0)
    TabButton.Position = UDim2.new(0, (i - 1) * 130 + 15, 0, 0)
    TabButton.Text = TabIcons[name] .. " " .. name
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextSize = 14
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButton.AutoButtonColor = false

    local Corner = Instance.new("UICorner", TabButton)
    Corner.CornerRadius = UDim.new(0, 6)

    Tabs[name] = TabButton
end

-- === Area Konten ===
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -110)
ContentFrame.Position = UDim2.new(0, 10, 0, 95)
ContentFrame.BackgroundTransparency = 1

local TabContents = {}

local function createTab(name, contentText)
    local Frame = Instance.new("Frame", ContentFrame)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.Visible = false

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Text = contentText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamMedium
    Label.BackgroundTransparency = 1
    Label.TextWrapped = true

    TabContents[name] = Frame
end

createTab("Home", "🏠 Welcome to the Home Tab!\nYou can add scripts, buttons, or logs here.")
createTab("Settings", "⚙️ Settings Tab\nConfigure features, toggles, or visual styles.")
createTab("About", "💡 Base UI Deluxe v1.2\nCreated by aanstok & ChatGPT\nMinimalistic Premium UI Design")

local function switchTab(name)
    for n, frame in pairs(TabContents) do
        frame.Visible = false
    end
    for n, btn in pairs(Tabs) do
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end
    TabContents[name].Visible = true
    TweenService:Create(Tabs[name], TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 90, 90)}):Play()
    CurrentTab = name
end

for name, btn in pairs(Tabs) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

switchTab("Home")

-- === Tombol Hide ===
local HideGui = Instance.new("ScreenGui", CoreGui)
HideGui.Name = "HideButton"

local HideButton = Instance.new("TextButton", HideGui)
HideButton.Text = "📂 Show UI"
HideButton.Size = UDim2.new(0, 110, 0, 38)
HideButton.Position = UDim2.new(0.02, 0, 0.4, 0)
HideButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.Font = Enum.Font.GothamBold
HideButton.TextSize = 14
HideButton.Visible = false

local HideCorner = Instance.new("UICorner", HideButton)
HideCorner.CornerRadius = UDim.new(0, 6)

HideButton.MouseEnter:Connect(function()
    TweenService:Create(HideButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
end)
HideButton.MouseLeave:Connect(function()
    TweenService:Create(HideButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
end)

-- === Fungsi Close/Hide ===
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
    TweenBlur(0)
    task.wait(0.3)
    MainFrame.Visible = false
    HideButton.Visible = true
end)

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 420, 0, 260)
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    HideButton.Visible = false
    TweenBlur(10)
end)

print("💎 Base UI Deluxe Loaded Successfully.")
