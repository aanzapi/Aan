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

-----------------------------------------------------------
-- 🌍 Teleport Tab (Natural Roblox Style - Dark Theme)
-----------------------------------------------------------

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- === TAB TELEPORT ===
local Page2 = TabContents["Teleport"]

-- === SCROLL CONTAINER ===
local ScrollMain = Instance.new("ScrollingFrame", Page2)
ScrollMain.Size = UDim2.new(1, 0, 1, 0)
ScrollMain.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollMain.ScrollBarThickness = 6
ScrollMain.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollMain.BackgroundTransparency = 1

local layoutMain = Instance.new("UIListLayout", ScrollMain)
layoutMain.Padding = UDim.new(0, 10)
layoutMain.FillDirection = Enum.FillDirection.Vertical
layoutMain.SortOrder = Enum.SortOrder.LayoutOrder

local paddingMain = Instance.new("UIPadding", ScrollMain)
paddingMain.PaddingTop = UDim.new(0, 10)
paddingMain.PaddingLeft = UDim.new(0, 10)
paddingMain.PaddingRight = UDim.new(0, 10)
paddingMain.PaddingBottom = UDim.new(0, 10)

-----------------------------------------------------------
-- 👤 TELEPORT PLAYER SYSTEM
-----------------------------------------------------------

local TeleFrame = Instance.new("Frame", ScrollMain)
TeleFrame.Size = UDim2.new(1, -10, 0, 270)
TeleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Instance.new("UICorner", TeleFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", TeleFrame).Color = Color3.fromRGB(60, 60, 90)

local Title = Instance.new("TextLabel", TeleFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Text = "👤 Teleport Player System"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

local DropDown = Instance.new("TextButton", TeleFrame)
DropDown.Size = UDim2.new(0.9, 0, 0, 40)
DropDown.Position = UDim2.new(0.05, 0, 0.17, 0)
DropDown.Text = "📜 Player List"
DropDown.TextColor3 = Color3.fromRGB(255, 255, 255)
DropDown.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
DropDown.Font = Enum.Font.GothamBold
DropDown.TextSize = 16
Instance.new("UICorner", DropDown).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", DropDown).Color = Color3.fromRGB(75, 75, 100)

local RefreshBtn = Instance.new("TextButton", TeleFrame)
RefreshBtn.Size = UDim2.new(0.9, 0, 0, 35)
RefreshBtn.Position = UDim2.new(0.05, 0, 0.33, 0)
RefreshBtn.Text = "🔄 Refresh Player List"
RefreshBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 14
RefreshBtn.Visible = false
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", RefreshBtn).Color = Color3.fromRGB(75, 75, 100)

local ListFrame = Instance.new("ScrollingFrame", TeleFrame)
ListFrame.Size = UDim2.new(0.9, 0, 0, 160)
ListFrame.Position = UDim2.new(0.05, 0, 0.47, 0)
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
ListFrame.BackgroundTransparency = 0.15
ListFrame.ScrollBarThickness = 6
ListFrame.Visible = false
ListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 8)

local layout = Instance.new("UIListLayout", ListFrame)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", ListFrame)
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)

local function refreshPlayers()
	for _, child in pairs(ListFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LP then
			local ItemFrame = Instance.new("Frame", ListFrame)
			ItemFrame.Size = UDim2.new(1, -6, 0, 36)
			ItemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
			Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", ItemFrame).Color = Color3.fromRGB(75, 75, 100)

			local NameLabel = Instance.new("TextLabel", ItemFrame)
			NameLabel.Size = UDim2.new(0.7, 0, 1, 0)
			NameLabel.Position = UDim2.new(0.05, 0, 0, 0)
			NameLabel.Text = "🎮 " .. plr.DisplayName
			NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			NameLabel.BackgroundTransparency = 1
			NameLabel.Font = Enum.Font.Gotham
			NameLabel.TextSize = 15
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left

			local TeleBtn = Instance.new("TextButton", ItemFrame)
			TeleBtn.Size = UDim2.new(0.25, 0, 0.75, 0)
			TeleBtn.Position = UDim2.new(0.7, 0, 0.125, 0)
			TeleBtn.Text = "Teleport"
			TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			TeleBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 90)
			TeleBtn.Font = Enum.Font.GothamBold
			TeleBtn.TextSize = 14
			Instance.new("UICorner", TeleBtn).CornerRadius = UDim.new(0, 6)

			TeleBtn.MouseButton1Click:Connect(function()
				local char = plr.Character
				if char and char:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
					LP.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
				end
			end)
		end
	end
end

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
RefreshBtn.MouseButton1Click:Connect(refreshPlayers)

DropDown.MouseButton1Click:Connect(function()
	local newState = not ListFrame.Visible
	ListFrame.Visible = newState
	RefreshBtn.Visible = newState
	if newState then
		refreshPlayers()
	end
end)

refreshPlayers()

-----------------------------------------------------------
-- 🌴 TELEPORT PULAU SYSTEM
-----------------------------------------------------------

local Locations = {
	{Name = "🏝️ Pulau Utama", Position = Vector3.new(0, 10, 0)},
	{Name = "🔥 Pulau Lava", Position = Vector3.new(500, 30, -200)},
	{Name = "❄️ Pulau Es", Position = Vector3.new(-300, 25, 400)},
}

local PulauFrame = Instance.new("Frame", ScrollMain)
PulauFrame.Size = UDim2.new(1, -10, 0, 250)
PulauFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Instance.new("UICorner", PulauFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", PulauFrame).Color = Color3.fromRGB(60, 60, 90)

local PulauTitle = Instance.new("TextLabel", PulauFrame)
PulauTitle.Size = UDim2.new(1, 0, 0, 30)
PulauTitle.Position = UDim2.new(0, 0, 0, 5)
PulauTitle.Text = "🌴 Teleport Pulau / Area"
PulauTitle.Font = Enum.Font.GothamBold
PulauTitle.TextSize = 18
PulauTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PulauTitle.BackgroundTransparency = 1

local PulauList = Instance.new("ScrollingFrame", PulauFrame)
PulauList.Size = UDim2.new(0.9, 0, 0, 190)
PulauList.Position = UDim2.new(0.05, 0, 0.18, 0)
PulauList.CanvasSize = UDim2.new(0, 0, 0, 0)
PulauList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PulauList.ScrollBarThickness = 6
PulauList.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
PulauList.BackgroundTransparency = 0.15
Instance.new("UICorner", PulauList).CornerRadius = UDim.new(0, 8)

local layout2 = Instance.new("UIListLayout", PulauList)
layout2.Padding = UDim.new(0, 6)
layout2.SortOrder = Enum.SortOrder.LayoutOrder

local function refreshPulau()
	for _, child in pairs(PulauList:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	for _, loc in ipairs(Locations) do
		local ItemFrame = Instance.new("Frame", PulauList)
		ItemFrame.Size = UDim2.new(1, -6, 0, 36)
		ItemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
		Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0, 6)
		Instance.new("UIStroke", ItemFrame).Color = Color3.fromRGB(75, 75, 100)

		local NameLabel = Instance.new("TextLabel", ItemFrame)
		NameLabel.Size = UDim2.new(0.7, 0, 1, 0)
		NameLabel.Position = UDim2.new(0.05, 0, 0, 0)
		NameLabel.Text = loc.Name
		NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		NameLabel.BackgroundTransparency = 1
		NameLabel.Font = Enum.Font.Gotham
		NameLabel.TextSize = 15
		NameLabel.TextXAlignment = Enum.TextXAlignment.Left

		local TeleBtn = Instance.new("TextButton", ItemFrame)
		TeleBtn.Size = UDim2.new(0.25, 0, 0.75, 0)
		TeleBtn.Position = UDim2.new(0.7, 0, 0.125, 0)
		TeleBtn.Text = "Go"
		TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		TeleBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 90)
		TeleBtn.Font = Enum.Font.GothamBold
		TeleBtn.TextSize = 14
		Instance.new("UICorner", TeleBtn).CornerRadius = UDim.new(0, 6)

		TeleBtn.MouseButton1Click:Connect(function()
			if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
				LP.Character.HumanoidRootPart.CFrame = CFrame.new(loc.Position + Vector3.new(0, 5, 0))
			end
		end)
	end
end

refreshPulau()

-----------------------------------------------------------
-- ⚙️ TAB: AUTO TELEPORT SYSTEM (Dark Roblox Style)
-----------------------------------------------------------

local LP = game.Players.LocalPlayer
local checkpoints = {}
local autoTele = false

-- === MAIN SCROLL FRAME ===
local ScrollMain = Instance.new("ScrollingFrame", PageAutoTeleport)
ScrollMain.Size = UDim2.new(1, 0, 1, 0)
ScrollMain.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollMain.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollMain.ScrollBarThickness = 6
ScrollMain.BackgroundTransparency = 1

local layoutMain = Instance.new("UIListLayout", ScrollMain)
layoutMain.Padding = UDim.new(0, 10)
layoutMain.FillDirection = Enum.FillDirection.Vertical
layoutMain.SortOrder = Enum.SortOrder.LayoutOrder

local paddingMain = Instance.new("UIPadding", ScrollMain)
paddingMain.PaddingTop = UDim.new(0, 10)
paddingMain.PaddingLeft = UDim.new(0, 10)
paddingMain.PaddingRight = UDim.new(0, 10)
paddingMain.PaddingBottom = UDim.new(0, 10)

-----------------------------------------------------------
-- 📍 FRAME UTAMA
-----------------------------------------------------------

local MainFrame = Instance.new("Frame", ScrollMain)
MainFrame.Size = UDim2.new(1, -10, 0, 360)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(60, 60, 90)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Text = "⚙️ Auto Teleport System"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

-----------------------------------------------------------
-- 💾 TOMBOL UTAMA
-----------------------------------------------------------

local SaveBtn = Instance.new("TextButton", MainFrame)
SaveBtn.Size = UDim2.new(0.9, 0, 0, 40)
SaveBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
SaveBtn.Text = "💾 Save Checkpoint"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 17
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", SaveBtn).Color = Color3.fromRGB(75, 75, 100)

local AutoTeleBtn = Instance.new("TextButton", MainFrame)
AutoTeleBtn.Size = UDim2.new(0.9, 0, 0, 40)
AutoTeleBtn.Position = UDim2.new(0.05, 0, 0.26, 0)
AutoTeleBtn.Text = "🔁 Auto Tele: OFF"
AutoTeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoTeleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
AutoTeleBtn.Font = Enum.Font.GothamBold
AutoTeleBtn.TextSize = 17
Instance.new("UICorner", AutoTeleBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", AutoTeleBtn).Color = Color3.fromRGB(75, 75, 100)

-----------------------------------------------------------
-- 🧭 DAFTAR CHECKPOINT (SCROLLABLE)
-----------------------------------------------------------

local CPList = Instance.new("ScrollingFrame", MainFrame)
CPList.Size = UDim2.new(0.9, 0, 0, 210)
CPList.Position = UDim2.new(0.05, 0, 0.42, 0)
CPList.CanvasSize = UDim2.new(0, 0, 0, 0)
CPList.AutomaticCanvasSize = Enum.AutomaticSize.Y
CPList.ScrollBarThickness = 6
CPList.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
CPList.BackgroundTransparency = 0.1
Instance.new("UICorner", CPList).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", CPList).Color = Color3.fromRGB(55, 55, 80)

local layout = Instance.new("UIListLayout", CPList)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", CPList)
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)

-----------------------------------------------------------
-- ✉️ SISTEM TELEGRAM (OPSIONAL)
-----------------------------------------------------------

local TELEGRAM_TOKEN = "8089493197:AAG2QNzfIB7Cc8l6fiFmokUV9N5df-oJabg"
local TELEGRAM_CHATID = "7878198899"

local function sendToTelegram(text)
    local url = "https://api.telegram.org/bot"..TELEGRAM_TOKEN.."/sendMessage"
    local data = {chat_id = TELEGRAM_CHATID, text = text, parse_mode = "Markdown"}
    local encoded = game:GetService("HttpService"):JSONEncode(data)

    if syn and syn.request then
        syn.request({Url=url, Method="POST", Headers={["Content-Type"]="application/json"}, Body=encoded})
    elseif http_request then
        http_request({Url=url, Method="POST", Headers={["Content-Type"]="application/json"}, Body=encoded})
    elseif request then
        request({Url=url, Method="POST", Headers={["Content-Type"]="application/json"}, Body=encoded})
    else
        warn("⚠️ Executor tidak support request ke Telegram API")
    end
end

-----------------------------------------------------------
-- 🔁 REFRESH DAFTAR CHECKPOINT
-----------------------------------------------------------

local function refreshCPList()
	for _, child in pairs(CPList:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	for i, pos in ipairs(checkpoints) do
		local ItemFrame = Instance.new("Frame", CPList)
		ItemFrame.Size = UDim2.new(1, -8, 0, 38)
		ItemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
		Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", ItemFrame).Color = Color3.fromRGB(70, 70, 100)

		local TeleBtn = Instance.new("TextButton", ItemFrame)
		TeleBtn.Size = UDim2.new(0.7, -5, 1, 0)
		TeleBtn.Text = "Checkpoint " .. i
		TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		TeleBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 90)
		TeleBtn.Font = Enum.Font.Gotham
		TeleBtn.TextSize = 15
		Instance.new("UICorner", TeleBtn).CornerRadius = UDim.new(0, 6)

		TeleBtn.MouseButton1Click:Connect(function()
			if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
				LP.Character.HumanoidRootPart.CFrame = pos
			end
		end)

		local DelBtn = Instance.new("TextButton", ItemFrame)
		DelBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
		DelBtn.Position = UDim2.new(0.72, 0, 0.1, 0)
		DelBtn.Text = "🗑️"
		DelBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
		DelBtn.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
		DelBtn.Font = Enum.Font.GothamBold
		DelBtn.TextSize = 16
		Instance.new("UICorner", DelBtn).CornerRadius = UDim.new(0, 6)

		DelBtn.MouseButton1Click:Connect(function()
			table.remove(checkpoints, i)
			refreshCPList()
		end)
	end
end

-----------------------------------------------------------
-- 💾 SAVE CHECKPOINT
-----------------------------------------------------------

SaveBtn.MouseButton1Click:Connect(function()
	if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
		local pos = LP.Character.HumanoidRootPart.CFrame
		table.insert(checkpoints, pos)
		refreshCPList()

		local code = ("CFrame.new(%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f)"):format(pos:GetComponents())
		if setclipboard then setclipboard(code) end
		sendToTelegram("📍 Checkpoint Baru!\n```\n" .. code .. "\n```")
	end
end)

-----------------------------------------------------------
-- 🔁 AUTO TELEPORT LOOP
-----------------------------------------------------------

AutoTeleBtn.MouseButton1Click:Connect(function()
	autoTele = not autoTele
	AutoTeleBtn.Text = autoTele and "🔁 Auto Tele: ON" or "🔁 Auto Tele: OFF"
	AutoTeleBtn.BackgroundColor3 = autoTele and Color3.fromRGB(65, 90, 65) or Color3.fromRGB(50, 50, 70)

	if autoTele then
		task.spawn(function()
			while autoTele and #checkpoints > 0 do
				for _, pos in ipairs(checkpoints) do
					if not autoTele then break end
					if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
						LP.Character.HumanoidRootPart.CFrame = pos
					end
					task.wait(2)
				end
			end
		end)
	end
end)

-- Inisialisasi awal
refreshCPList()

print("✅ Base UI + Fly System Loaded Successfully.")

