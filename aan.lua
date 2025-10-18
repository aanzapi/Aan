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
-- ✈️ Fly + Walk System (Gaya Walvy - Auto Farm UI)
-----------------------------------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

local PageSetting = TabContents["Settings"]

-----------------------------------------------------------
-- 🔧 Helper: Buat Kotak Setting (Judul + Deskripsi + Toggle)
-----------------------------------------------------------
local function createSettingBox(parent, titleText, descText)
	local box = Instance.new("Frame")
	box.Parent = parent
	box.Size = UDim2.new(1, -10, 0, 55)
	box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	box.BackgroundTransparency = 0.2
	box.BorderSizePixel = 0
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

	local title = Instance.new("TextLabel", box)
	title.Text = titleText
	title.Size = UDim2.new(0.7, 0, 0, 22)
	title.Position = UDim2.new(0.05, 0, 0.1, 0)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 15
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left

	local desc = Instance.new("TextLabel", box)
	desc.Text = descText
	desc.Size = UDim2.new(0.7, 0, 0, 20)
	desc.Position = UDim2.new(0.05, 0, 0.55, 0)
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 13
	desc.TextColor3 = Color3.fromRGB(180, 180, 180)
	desc.BackgroundTransparency = 1
	desc.TextXAlignment = Enum.TextXAlignment.Left

	local toggle = Instance.new("TextButton", box)
	toggle.Size = UDim2.new(0, 40, 0, 20)
	toggle.Position = UDim2.new(0.9, 0, 0.35, 0)
	toggle.Text = ""
	toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
	toggle.AutoButtonColor = false
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

	local circle = Instance.new("Frame", toggle)
	circle.Size = UDim2.new(0, 18, 0, 18)
	circle.Position = UDim2.new(0.05, 0, 0.05, 0)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	local state = false
	local function toggleSwitch()
		state = not state
		if state then
			toggle.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
			circle:TweenPosition(UDim2.new(0.55, 0, 0.05, 0), "Out", "Quad", 0.15)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
			circle:TweenPosition(UDim2.new(0.05, 0, 0.05, 0), "Out", "Quad", 0.15)
		end
	end

	toggle.MouseButton1Click:Connect(toggleSwitch)

	return box, toggle, function() return state end
end

-----------------------------------------------------------
-- 🔧 Helper: Buat Slider Delay (Gaya Auto Fishing)
-----------------------------------------------------------
local function createSlider(parent, title, desc)
	local box = Instance.new("Frame", parent)
	box.Size = UDim2.new(1, -10, 0, 55)
	box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	box.BackgroundTransparency = 0.2
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel", box)
	label.Text = title
	label.Size = UDim2.new(0.7, 0, 0, 22)
	label.Position = UDim2.new(0.05, 0, 0.1, 0)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 15
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left

	local descLabel = Instance.new("TextLabel", box)
	descLabel.Text = desc
	descLabel.Size = UDim2.new(0.7, 0, 0, 20)
	descLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextSize = 13
	descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	descLabel.BackgroundTransparency = 1
	descLabel.TextXAlignment = Enum.TextXAlignment.Left

	local slider = Instance.new("Frame", box)
	slider.Size = UDim2.new(0.9, 0, 0, 8)
	slider.Position = UDim2.new(0.05, 0, 0.8, 0)
	slider.BackgroundColor3 = Color3.fromRGB(65, 65, 90)
	Instance.new("UICorner", slider).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame", slider)
	fill.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
	fill.Size = UDim2.new(0.5, 0, 1, 0)
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local value = 500
	local dragging = false

	local function updateSlider(x)
		local rel = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
		value = math.floor(1 + (1000 - 1) * rel)
		fill.Size = UDim2.new(rel, 0, 1, 0)
	end

	slider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateSlider(input.Position.X)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input.Position.X)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	return box, function() return value end
end

-----------------------------------------------------------
-- 🧩 Frame Container
-----------------------------------------------------------
local FlyContainer = Instance.new("Frame", PageSetting)
FlyContainer.Size = UDim2.new(1, -10, 0, 250)
FlyContainer.Position = UDim2.new(0, 5, 0.05, 0)
FlyContainer.BackgroundTransparency = 1

-----------------------------------------------------------
-- ✈️ Auto Fly
-----------------------------------------------------------
local FlyBox, FlyToggle, FlyState = createSettingBox(FlyContainer, "Auto Fly", "Fly freely in the air.")
FlyBox.Position = UDim2.new(0, 0, 0, 0)

local FlyDelayBox, getFlyDelay = createSlider(FlyContainer, "Fly Delay Speed", "Adjust delay for fly control.")
FlyDelayBox.Position = UDim2.new(0, 0, 0, 60)

-----------------------------------------------------------
-- 🚶 Walk Speed Control
-----------------------------------------------------------
local WalkBox, WalkToggle, WalkState = createSettingBox(FlyContainer, "Walk Speed", "Custom walking speed.")
WalkBox.Position = UDim2.new(0, 0, 0, 120)

local WalkDelayBox, getWalkDelay = createSlider(FlyContainer, "Walk Delay Speed", "Smoothness of walking change.")
WalkDelayBox.Position = UDim2.new(0, 0, 0, 180)

-----------------------------------------------------------
-- ✈️ Fly Logic
-----------------------------------------------------------
local flying = false
local bv
local flyY = 0
local speed = 60
local upHeld, downHeld = false, false

local FlyGui = Instance.new("ScreenGui", CoreGui)
FlyGui.Name = "FlyControl"
FlyGui.Enabled = false

local function createBtn(text, posY)
	local btn = Instance.new("TextButton", FlyGui)
	btn.Size = UDim2.new(0, 60, 0, 60)
	btn.Position = UDim2.new(0.93, 0, posY, 0)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 26
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
	return btn
end

local UpBtn = createBtn("⬆️", 0.8)
local DownBtn = createBtn("⬇️", 0.87)

UpBtn.MouseButton1Down:Connect(function() if flying then upHeld = true end end)
UpBtn.MouseButton1Up:Connect(function() upHeld = false end)
DownBtn.MouseButton1Down:Connect(function() if flying then downHeld = true end end)
DownBtn.MouseButton1Up:Connect(function() downHeld = false end)

local function startFly()
	local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not HRP then return end
	if not bv then
		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Parent = HRP
	end

	RunService.Heartbeat:Connect(function(dt)
		if flying and bv and HRP then
			local move = LP.Character:FindFirstChildOfClass("Humanoid").MoveDirection
			local delayMs = getFlyDelay() / 1000
			if upHeld then flyY = speed elseif downHeld then flyY = -speed else flyY = 0 end
			bv.Velocity = Vector3.new(move.X * speed, flyY, move.Z * speed)
			task.wait(delayMs)
		end
	end)
end

FlyToggle.MouseButton1Click:Connect(function()
	flying = not flying
	FlyGui.Enabled = flying
	if flying then startFly() else if bv then bv:Destroy() bv = nil end end
end)

-----------------------------------------------------------
-- 🚶 Walk Speed Logic
-----------------------------------------------------------
local humanoid = LP.Character:WaitForChild("Humanoid")
local targetSpeed = 16
local currentSpeed = humanoid.WalkSpeed

RunService.Heartbeat:Connect(function()
	if WalkState() then
		local delayMs = getWalkDelay() / 1000
		currentSpeed = currentSpeed + (targetSpeed - currentSpeed) * 0.2
		humanoid.WalkSpeed = currentSpeed
		task.wait(delayMs)
	end
end)		        

print("✅ Base UI + Fly System Loaded Successfully.")
