--[[
===========================================================
    Custom Base UI (With Tabs)
    Dibuat oleh aanstok & ChatGPT (Style Realistic)
    Fitur:
    - Tombol Close & Hide
    - Tab: Home, Settings, About
    - Transisi halus antar tab
===========================================================
]]

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Bersihkan UI lama
for _, ui in ipairs({"BaseUI", "HideButton"}) do
    if CoreGui:FindFirstChild(ui) then
        CoreGui[ui]:Destroy()
    end
end

-- === ScreenGui ===
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "BaseUI"

-- === Frame Utama ===
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Thickness = 1.5

-- === Judul & Close ===
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Text = "Base UI - Tabs Example"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -35, 0, 7)
CloseButton.Text = "×"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 22
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundTransparency = 0.2
CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local CloseCorner = Instance.new("UICorner", CloseButton)
CloseCorner.CornerRadius = UDim.new(1, 0)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
end)

-- === Navigasi Tab ===
local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Size = UDim2.new(1, 0, 0, 35)
TabHolder.Position = UDim2.new(0, 0, 0, 40)
TabHolder.BackgroundTransparency = 1

local Tabs = {}
local TabNames = {"Home", "Settings", "About"}
local CurrentTab = nil

for i, name in ipairs(TabNames) do
    local TabButton = Instance.new("TextButton", TabHolder)
    TabButton.Size = UDim2.new(0, 100, 1, 0)
    TabButton.Position = UDim2.new(0, (i - 1) * 110 + 10, 0, 0)
    TabButton.Text = name
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextSize = 14
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButton.AutoButtonColor = false

    local Corner = Instance.new("UICorner", TabButton)
    Corner.CornerRadius = UDim.new(0, 6)

    Tabs[name] = TabButton
end

-- === Konten Area ===
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -85)
ContentFrame.Position = UDim2.new(0, 10, 0, 80)
ContentFrame.BackgroundTransparency = 1

-- === Buat 3 Tab Konten ===
local TabContents = {}

local function createTab(name, contentText)
    local Frame = Instance.new("Frame", ContentFrame)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.Visible = false

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.Text = contentText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamMedium
    Label.BackgroundTransparency = 1
    Label.TextWrapped = true

    TabContents[name] = Frame
end

createTab("Home", "Welcome to Home Tab.\nYou can put any button or content here.")
createTab("Settings", "This is Settings Tab.\nAdjust your configurations here.")
createTab("About", "Base UI v1.0\nMade by aanstok & ChatGPT\nFor fun and learning ❤️")

-- === Fungsi Ganti Tab ===
local function switchTab(name)
    for n, frame in pairs(TabContents) do
        frame.Visible = false
    end
    for n, btn in pairs(Tabs) do
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end
    TabContents[name].Visible = true
    TweenService:Create(Tabs[name], TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
    CurrentTab = name
end

for name, btn in pairs(Tabs) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

switchTab("Home") -- Default tab

-- === Tombol Hide ===
local HideGui = Instance.new("ScreenGui", CoreGui)
HideGui.Name = "HideButton"

local HideButton = Instance.new("TextButton", HideGui)
HideButton.Text = "Show UI"
HideButton.Size = UDim2.new(0, 100, 0, 35)
HideButton.Position = UDim2.new(0.02, 0, 0.4, 0)
HideButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
    TweenService:Create(HideButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
end)

-- === Fungsi Close/Hide ===
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    MainFrame.Visible = false
    HideButton.Visible = true
end)

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 400, 0, 250)
    MainFrame.BackgroundTransparency = 0
    HideButton.Visible = false
end)

print("✅ Base UI Tabs Loaded Successfully.")
