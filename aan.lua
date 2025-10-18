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
-- ⚙️ Settings Tab - Fly & Walk System (Versi Final)
-----------------------------------------------------------

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local PageSetting = TabContents["Settings"]

-----------------------------------------------------------
-- SCROLLABLE CONTAINER
-----------------------------------------------------------
local Scroll = Instance.new("ScrollingFrame", PageSetting)
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1

local List = Instance.new("UIListLayout", Scroll)
List.Padding = UDim.new(0, 6)
List.SortOrder = Enum.SortOrder.LayoutOrder

-----------------------------------------------------------
-- UTILITY: CREATE SMALL SETTING BOX
-----------------------------------------------------------
local function CreateBox(title, desc)
	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, -10, 0, 55)
	box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	box.BackgroundTransparency = 0.15
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

	local titleLabel = Instance.new("TextLabel", box)
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 15
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(0.7, 0, 0, 22)
	titleLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left

	local descLabel = Instance.new("TextLabel", box)
	descLabel.Text = desc
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextSize = 13
	descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	descLabel.BackgroundTransparency = 1
	descLabel.Size = UDim2.new(0.7, 0, 0, 20)
	descLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
	descLabel.TextXAlignment = Enum.TextXAlignment.Left

	box.Parent = Scroll
	return box
end

-----------------------------------------------------------
-- TOGGLE BUTTON (Switch ON/OFF)
-----------------------------------------------------------
local function CreateToggle(parent)
	local toggle = Instance.new("TextButton", parent)
	toggle.Size = UDim2.new(0, 40, 0, 20)
	toggle.Position = UDim2.new(0.9, 0, 0.35, 0)
	toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
	toggle.Text = ""
	toggle.AutoButtonColor = false
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

	local circle = Instance.new("Frame", toggle)
	circle.Size = UDim2.new(0, 18, 0, 18)
	circle.Position = UDim2.new(0.05, 0, 0.05, 0)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	local state = false
	toggle.MouseButton1Click:Connect(function()
		state = not state
		if state then
			toggle.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
			circle:TweenPosition(UDim2.new(0.55, 0, 0.05, 0), "Out", "Quad", 0.15)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
			circle:TweenPosition(UDim2.new(0.05, 0, 0.05, 0), "Out", "Quad", 0.15)
		end
	end)

	return function() return state end, function(v)
		state = v
		if v then
			toggle.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
			circle.Position = UDim2.new(0.55, 0, 0.05, 0)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
			circle.Position = UDim2.new(0.05, 0, 0.05, 0)
		end
	end
end

-----------------------------------------------------------
-- VALUE BOX (+ / -)
-----------------------------------------------------------
local function CreateValue(parent, default, min, max)
	local minus = Instance.new("TextButton", parent)
	minus.Text = "−"
	minus.Font = Enum.Font.GothamBold
	minus.TextSize = 20
	minus.Size = UDim2.new(0, 25, 0, 25)
	minus.Position = UDim2.new(0.75, 0, 0.35, 0)
	minus.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	Instance.new("UICorner", minus).CornerRadius = UDim.new(1, 0)

	local plus = Instance.new("TextButton", parent)
	plus.Text = "+"
	plus.Font = Enum.Font.GothamBold
	plus.TextSize = 20
	plus.Size = UDim2.new(0, 25, 0, 25)
	plus.Position = UDim2.new(0.92, 0, 0.35, 0)
	plus.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	Instance.new("UICorner", plus).CornerRadius = UDim.new(1, 0)

	local valueLabel = Instance.new("TextLabel", parent)
	valueLabel.Text = tostring(default)
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 14
	valueLabel.TextColor3 = Color3.new(1, 1, 1)
	valueLabel.Size = UDim2.new(0, 40, 0, 25)
	valueLabel.Position = UDim2.new(0.82, 0, 0.35, 0)
	valueLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(1, 0)

	local val = default
	plus.MouseButton1Click:Connect(function()
		val = math.clamp(val + 1, min, max)
		valueLabel.Text = tostring(val)
	end)
	minus.MouseButton1Click:Connect(function()
		val = math.clamp(val - 1, min, max)
		valueLabel.Text = tostring(val)
	end)

	return function() return val end
end

-----------------------------------------------------------
-- ✈️ Fly Section
-----------------------------------------------------------
local FlyBox = CreateBox("✈️ Fly Mode", "Enable fly and control up/down.")
local GetFly, SetFly = CreateToggle(FlyBox)
local FlyDelayGetter = CreateValue(CreateBox("Fly Delay Speed", "Adjust fly delay (1–1000)."), 10, 1, 1000)

-----------------------------------------------------------
-- 🚶 Walk Section
-----------------------------------------------------------
local WalkBox = CreateBox("🚶 Walk Speed", "Enable walk speed customization.")
local GetWalk, SetWalk = CreateToggle(WalkBox)
local WalkSpeedGetter = CreateValue(CreateBox("Walk Speed", "Adjust walking speed (8–100)."), 16, 8, 100)
local WalkDelayGetter = CreateValue(CreateBox("Walk Delay Speed", "Adjust walk delay (1–1000)."), 10, 1, 1000)

-----------------------------------------------------------
-- LOGIC
-----------------------------------------------------------
local flyBV
local upHeld, downHeld = false, false

-- Tombol naik turun
local function createFlyButtons()
	local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
	gui.Name = "FlyControl"

	local up = Instance.new("TextButton", gui)
	up.Size = UDim2.new(0, 55, 0, 55)
	up.Position = UDim2.new(0.88, 0, 0.75, 0)
	up.Text = "⬆️"
	up.Font = Enum.Font.GothamBold
	up.TextSize = 28
	up.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
	up.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", up).CornerRadius = UDim.new(1, 0)

	local down = up:Clone()
	down.Text = "⬇️"
	down.Position = UDim2.new(0.88, 0, 0.83, 0)
	down.Parent = gui

	up.MouseButton1Down:Connect(function() upHeld = true end)
	up.MouseButton1Up:Connect(function() upHeld = false end)
	down.MouseButton1Down:Connect(function() downHeld = true end)
	down.MouseButton1Up:Connect(function() downHeld = false end)

	return gui
end

local FlyUI

RunService.RenderStepped:Connect(function()
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")

	if not hum or not hrp then return end

	-- Fly Mode
	if GetFly() then
		SetWalk(false)
		if not flyBV then
			flyBV = Instance.new("BodyVelocity", hrp)
			flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			FlyUI = FlyUI or createFlyButtons()
		end
		local dir = hum.MoveDirection
		local y = 0
		if upHeld then y = 60 elseif downHeld then y = -60 end
		flyBV.Velocity = Vector3.new(dir.X * 60, y, dir.Z * 60)
	else
		if flyBV then flyBV:Destroy() flyBV = nil end
		if FlyUI then FlyUI:Destroy() FlyUI = nil end
	end

	-- Walk Mode
	if GetWalk() then
		hum.WalkSpeed = WalkSpeedGetter()
	else
		-- 🧠 FIX: Reset kecepatan normal kalau walk off
		if hum.WalkSpeed ~= 16 then
			hum.WalkSpeed = 16
		end
	end
end)

print("✅ Base UI + Fly System Loaded Successfully.")
