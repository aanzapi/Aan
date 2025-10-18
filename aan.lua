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

-----------------------------------------------------------
-- ✈️ Fly System (Tab Settings - Versi DrRay Style Clean)
-----------------------------------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local Tab = TabContents["Settings"] -- tab Settings dari base UI kamu

-----------------------------------------------------------
-- 🧱 FRAME FLY CONTROL
-----------------------------------------------------------

local FlyFrame = Instance.new("Frame", Tab)
FlyFrame.Size = UDim2.new(0.96, 0, 0, 190)
FlyFrame.Position = UDim2.new(0.02, 0, 0.05, 0)
FlyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
FlyFrame.BackgroundTransparency = 0.05
FlyFrame.BorderSizePixel = 0
FlyFrame.ClipsDescendants = true
Instance.new("UICorner", FlyFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", FlyFrame).Color = Color3.fromRGB(60, 60, 90)

local Title = Instance.new("TextLabel", FlyFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "✈️ Fly Controller"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 5)

-----------------------------------------------------------
-- 🎛️ TOMBOL & LABEL
-----------------------------------------------------------

local FlyBtn = Instance.new("TextButton", FlyFrame)
FlyBtn.Size = UDim2.new(0.46, 0, 0, 40)
FlyBtn.Position = UDim2.new(0.03, 0, 0.27, 0)
FlyBtn.Text = "✈️ Fly: OFF"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
FlyBtn.Font = Enum.Font.GothamBold
FlyBtn.TextSize = 15
Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", FlyBtn).Color = Color3.fromRGB(80, 80, 120)

local SpeedLabel = Instance.new("TextLabel", FlyFrame)
SpeedLabel.Size = UDim2.new(0.46, 0, 0, 40)
SpeedLabel.Position = UDim2.new(0.51, 0, 0.27, 0)
SpeedLabel.Text = "⚡ Speed: 60"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 200)
SpeedLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 15
SpeedLabel.BackgroundTransparency = 0
Instance.new("UICorner", SpeedLabel).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", SpeedLabel).Color = Color3.fromRGB(80, 80, 120)

local PlusBtn = Instance.new("TextButton", FlyFrame)
PlusBtn.Size = UDim2.new(0.46, 0, 0, 35)
PlusBtn.Position = UDim2.new(0.03, 0, 0.57, 0)
PlusBtn.Text = "+ Speed"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.TextSize = 14
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 8)

local MinusBtn = Instance.new("TextButton", FlyFrame)
MinusBtn.Size = UDim2.new(0.46, 0, 0, 35)
MinusBtn.Position = UDim2.new(0.51, 0, 0.57, 0)
MinusBtn.Text = "- Speed"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.TextSize = 14
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 8)

-----------------------------------------------------------
-- 🕹️ LOGIC FLY
-----------------------------------------------------------

local FlyGui = Instance.new("ScreenGui")
FlyGui.Name = "FlyUI"
FlyGui.IgnoreGuiInset = true
FlyGui.ResetOnSpawn = false
FlyGui.Parent = CoreGui

-- Tombol Naik
local UpBtn = Instance.new("TextButton", FlyGui)
UpBtn.Size = UDim2.new(0, 58, 0, 58)
UpBtn.Position = UDim2.new(0.91, 0, 0.8, 0)
UpBtn.Text = "⬆️"
UpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
UpBtn.Font = Enum.Font.GothamBold
UpBtn.TextSize = 24
UpBtn.BackgroundTransparency = 0.1
UpBtn.Visible = false
Instance.new("UICorner", UpBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", UpBtn).Color = Color3.fromRGB(70, 70, 100)

-- Tombol Turun
local DownBtn = UpBtn:Clone()
DownBtn.Parent = FlyGui
DownBtn.Position = UDim2.new(0.91, 0, 0.87, 0)
DownBtn.Text = "⬇️"
DownBtn.Visible = false

-----------------------------------------------------------
-- 🚀 SISTEM FLY
-----------------------------------------------------------

local flying = false
local speed = 60
local bv
local flyY = 0
local upHeld, downHeld = false, false

local function startFly()
	local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not HRP then return end
	bv = Instance.new("BodyVelocity")
	bv.Velocity = Vector3.zero
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Parent = HRP

	RunService.RenderStepped:Connect(function()
		if flying and HRP and bv then
			local moveDir = LP.Character:FindFirstChild("Humanoid").MoveDirection
			if upHeld then flyY = speed elseif downHeld then flyY = -speed else flyY = 0 end
			bv.Velocity = Vector3.new(moveDir.X * speed, flyY, moveDir.Z * speed)
		end
	end)
end

UpBtn.MouseButton1Down:Connect(function() if flying then upHeld = true end end)
UpBtn.MouseButton1Up:Connect(function() upHeld = false end)
DownBtn.MouseButton1Down:Connect(function() if flying then downHeld = true end end)
DownBtn.MouseButton1Up:Connect(function() downHeld = false end)

PlusBtn.MouseButton1Click:Connect(function()
	speed += 10
	SpeedLabel.Text = "⚡ Speed: " .. speed
end)
MinusBtn.MouseButton1Click:Connect(function()
	speed = math.max(10, speed - 10)
	SpeedLabel.Text = "⚡ Speed: " .. speed
end)

FlyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	FlyBtn.Text = flying and "✈️ Fly: ON" or "✈️ Fly: OFF"
	UpBtn.Visible = flying
	DownBtn.Visible = flying
	flyY = 0
	if flying then
		startFly()
	else
		if bv then bv:Destroy() bv = nil end
	end
end)

print("✅ Base UI + Fly System Loaded Successfully.")
