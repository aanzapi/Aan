--[[
===========================================================
    Custom Base UI (4 Tabs Version) + Fly System
    Dibuat oleh aanstok & ChatGPT (Realistic Style)
    Fitur:
    - Tombol Close & Hide
    - Tab: Settings, Teleport, Auto Teleport, Menu Lain
    - Transisi halus antar tab
    - Fly + Speed control
    - Tombol naik & turun di luar UI (dekat tombol jump)
===========================================================
]]

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Hapus UI lama jika ada
for _, ui in ipairs({"BaseUI", "HideButton", "FlyButtons"}) do
	if CoreGui:FindFirstChild(ui) then
		CoreGui[ui]:Destroy()
	end
end

-- === ScreenGui ===
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "BaseUI"

-- === Frame Utama ===
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Thickness = 1.5

-- === Judul & Tombol Close ===
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Text = "Base UI - 4 Tabs"
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
CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

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
local TabNames = {"Settings", "Teleport", "Auto Teleport", "Menu Lain"}
local CurrentTab = nil

for i, name in ipairs(TabNames) do
	local TabButton = Instance.new("TextButton", TabHolder)
	TabButton.Size = UDim2.new(0, 95, 1, 0)
	TabButton.Position = UDim2.new(0, (i - 1) * 100 + 10, 0, 0)
	TabButton.Text = name
	TabButton.Font = Enum.Font.GothamSemibold
	TabButton.TextSize = 14
	TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	TabButton.AutoButtonColor = false
	Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
	Tabs[name] = TabButton
end

-- === Area Konten ===
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -85)
ContentFrame.Position = UDim2.new(0, 10, 0, 80)
ContentFrame.BackgroundTransparency = 1

local TabContents = {}

local function createTab(name)
	local Frame = Instance.new("Frame", ContentFrame)
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1
	Frame.Visible = false
	TabContents[name] = Frame
	return Frame
end

-- === Buat Tab ===
local PageSetting = createTab("Settings")
local PageTeleport = createTab("Teleport")
local PageAutoTeleport = createTab("Auto Teleport")
local PageMenu = createTab("Menu Lain")

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

switchTab("Settings")

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
Instance.new("UICorner", HideButton).CornerRadius = UDim.new(0, 6)

HideButton.MouseEnter:Connect(function()
	TweenService:Create(HideButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
end)
HideButton.MouseLeave:Connect(function()
	TweenService:Create(HideButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
	TweenService:Create(MainFrame, TweenInfo.new(0.3), {
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1
	}):Play()
	task.wait(0.3)
	MainFrame.Visible = false
	HideButton.Visible = true
end)

HideButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	MainFrame.Size = UDim2.new(0, 420, 0, 260)
	MainFrame.BackgroundTransparency = 0
	HideButton.Visible = false
end)

--===============================================================
-- Fly System with Speed Slider (Clean Roblox Style)
--===============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 50 -- default speed
local upButton, downButton = nil, nil
local bodyVelocity = nil

-- Fungsi buat tombol UI sederhana (natural style)
local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 60, 0, 60)
    button.Position = position
    button.Text = text
    button.TextScaled = true
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.BackgroundTransparency = 0.4
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 0
    button.Parent = game:GetService("CoreGui")
    button.AutoButtonColor = true
    button.ZIndex = 10
    button.MouseButton1Down:Connect(callback)
    return button
end

-- Mulai Fly
local function startFly()
    if flying then return end
    flying = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = root

    -- Bikin tombol naik turun di sebelah tombol lompat Roblox
    local jumpButton = player:WaitForChild("PlayerGui"):WaitForChild("TouchGui"):WaitForChild("TouchControlFrame"):WaitForChild("JumpButton")

    upButton = createButton("⬆", jumpButton.Position - UDim2.new(0, 70, 0, 0), function()
        root.CFrame = root.CFrame + Vector3.new(0, flySpeed/50, 0)
    end)

    downButton = createButton("⬇", jumpButton.Position + UDim2.new(0, -70, 0, 70), function()
        root.CFrame = root.CFrame - Vector3.new(0, flySpeed/50, 0)
    end)

    task.spawn(function()
        while flying and character and bodyVelocity do
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector
            end

            bodyVelocity.Velocity = moveDir * (flySpeed / 10)
            task.wait(0.01)
        end
    end)
end

-- Berhenti Fly
local function stopFly()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if upButton then upButton:Destroy() end
    if downButton then downButton:Destroy() end
end

--===============================================================
-- BAGIAN UI DI TAB SETTINGS (nyatu sama base mu)
--===============================================================
-- Toggle Fly ON/OFF
flyTab:CreateToggle("Fly Mode", false, function(state)
    if state then
        startFly()
        flyTab:CreateNotification("Fly", "Mode Terbang Aktif ✅", 2)
    else
        stopFly()
        flyTab:CreateNotification("Fly", "Mode Terbang Dimatikan ❌", 2)
    end
end)
local flyTab = Tabs["Setting"] or DrRayLibrary:CreateTab("Setting")

-- Slider kecepatan fly
flyTab:CreateSlider("Fly Speed", 1, 1000, flySpeed, function(value)
    flySpeed = value
end)


print("✅ Base UI + Fly System Loaded Successfully.")
