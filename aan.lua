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
-- ✈️ Fly System (UI Mirip Auto Instant Fishing)
-----------------------------------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local PageSetting = TabContents["Settings"]

-----------------------------------------------------------
-- FRAME UTAMA
-----------------------------------------------------------
local FlyFrame = Instance.new("Frame")
FlyFrame.Name = "FlyFrame"
FlyFrame.Parent = PageSetting
FlyFrame.Size = UDim2.new(0.95, 0, 0, 160)
FlyFrame.Position = UDim2.new(0.025, 0, 0.05, 0)
FlyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
FlyFrame.BackgroundTransparency = 0.05
Instance.new("UICorner", FlyFrame).CornerRadius = UDim.new(0, 10)

-----------------------------------------------------------
-- LABEL UTAMA
-----------------------------------------------------------
local Title = Instance.new("TextLabel")
Title.Parent = FlyFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "✈️ Auto Fly"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-----------------------------------------------------------
-- TOGGLE FLY
-----------------------------------------------------------
local FlyToggle = Instance.new("TextButton")
FlyToggle.Parent = FlyFrame
FlyToggle.Size = UDim2.new(0.9, 0, 0, 40)
FlyToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
FlyToggle.Text = "Auto Fly: OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.TextSize = 16
Instance.new("UICorner", FlyToggle).CornerRadius = UDim.new(0, 8)

-----------------------------------------------------------
-- SLIDER DELAY SPEED
-----------------------------------------------------------
local DelayLabel = Instance.new("TextLabel")
DelayLabel.Parent = FlyFrame
DelayLabel.Size = UDim2.new(0.9, 0, 0, 30)
DelayLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
DelayLabel.Text = "Delay Speed: 500"
DelayLabel.Font = Enum.Font.GothamBold
DelayLabel.TextSize = 14
DelayLabel.BackgroundTransparency = 1
DelayLabel.TextColor3 = Color3.fromRGB(255, 255, 200)

local DelaySlider = Instance.new("TextButton")
DelaySlider.Parent = FlyFrame
DelaySlider.Size = UDim2.new(0.9, 0, 0, 25)
DelaySlider.Position = UDim2.new(0.05, 0, 0.73, 0)
DelaySlider.BackgroundColor3 = Color3.fromRGB(65, 65, 90)
DelaySlider.Text = ""
Instance.new("UICorner", DelaySlider).CornerRadius = UDim.new(0, 8)

local Fill = Instance.new("Frame")
Fill.Parent = DelaySlider
Fill.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
Fill.Size = UDim2.new(0.5, 0, 1, 0)
Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 8)

local delaySpeed = 500
local dragging = false

DelaySlider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
	end
end)

DelaySlider.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging then
		local rel = math.clamp((input.Position.X - DelaySlider.AbsolutePosition.X) / DelaySlider.AbsoluteSize.X, 0, 1)
		delaySpeed = math.floor(1 + (1000 - 1) * rel)
		Fill.Size = UDim2.new(rel, 0, 1, 0)
		DelayLabel.Text = "Delay Speed: " .. delaySpeed
	end
end)

-----------------------------------------------------------
-- FLY LOGIC
-----------------------------------------------------------
local flying = false
local speed = 60
local bv
local flyY = 0
local upHeld, downHeld = false, false

local FlyGui = Instance.new("ScreenGui")
FlyGui.Name = "FlyControl"
FlyGui.Parent = CoreGui
FlyGui.Enabled = false

-- Tombol Naik & Turun
local UpBtn = Instance.new("TextButton")
UpBtn.Parent = FlyGui
UpBtn.Size = UDim2.new(0, 60, 0, 60)
UpBtn.Position = UDim2.new(0.93, 0, 0.8, 0)
UpBtn.Text = "⬆️"
UpBtn.TextColor3 = Color3.new(1,1,1)
UpBtn.Font = Enum.Font.GothamBold
UpBtn.TextSize = 26
UpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
Instance.new("UICorner", UpBtn).CornerRadius = UDim.new(1, 0)

local DownBtn = Instance.new("TextButton")
DownBtn.Parent = FlyGui
DownBtn.Size = UDim2.new(0, 60, 0, 60)
DownBtn.Position = UDim2.new(0.93, 0, 0.87, 0)
DownBtn.Text = "⬇️"
DownBtn.TextColor3 = Color3.new(1,1,1)
DownBtn.Font = Enum.Font.GothamBold
DownBtn.TextSize = 26
DownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
Instance.new("UICorner", DownBtn).CornerRadius = UDim.new(1, 0)

UpBtn.MouseButton1Down:Connect(function() if flying then upHeld = true end end)
UpBtn.MouseButton1Up:Connect(function() upHeld = false end)
DownBtn.MouseButton1Down:Connect(function() if flying then downHeld = true end end)
DownBtn.MouseButton1Up:Connect(function() downHeld = false end)

-----------------------------------------------------------
-- FLY CORE FUNCTION
-----------------------------------------------------------
local function startFly()
	local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not HRP then return end

	if not bv then
		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Velocity = Vector3.zero
		bv.Parent = HRP
	end

	RunService.RenderStepped:Connect(function()
		if flying and bv and HRP then
			local moveDir = LP.Character:FindFirstChildOfClass("Humanoid").MoveDirection
			if upHeld then flyY = speed elseif downHeld then flyY = -speed else flyY = 0 end
			bv.Velocity = Vector3.new(moveDir.X * speed, flyY, moveDir.Z * speed)
		end
	end)
end

-----------------------------------------------------------
-- TOGGLE BEHAVIOR
-----------------------------------------------------------
FlyToggle.MouseButton1Click:Connect(function()
	flying = not flying
	FlyToggle.Text = flying and "Auto Fly: ON" or "Auto Fly: OFF"
	FlyToggle.BackgroundColor3 = flying and Color3.fromRGB(70, 120, 70) or Color3.fromRGB(50, 50, 70)
	FlyGui.Enabled = flying

	if flying then
		startFly()
	else
		if bv then bv:Destroy() bv = nil end
	end
end)          

print("✅ Base UI + Fly System Loaded Successfully.")
