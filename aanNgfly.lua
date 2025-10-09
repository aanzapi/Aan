----------------------------------------------------------------
-- 🌌 ELEGANT SUMMIT GUI (Dark + Rainbow Border + Resize)
----------------------------------------------------------------

-- Services
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AanUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

---------------------------------------------------------------------
-- 🔹 Intro Animation: A A N transparan (tanpa background hitam)
---------------------------------------------------------------------
local IntroFrame = Instance.new("Frame", ScreenGui)
IntroFrame.Size = UDim2.new(1,0,1,0)
IntroFrame.BackgroundTransparency = 1
IntroFrame.ZIndex = 10

local AANLabel = Instance.new("TextLabel", IntroFrame)
AANLabel.Size = UDim2.new(1,0,1,0)
AANLabel.Text = ""
AANLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AANLabel.Font = Enum.Font.GothamBlack
AANLabel.TextScaled = true
AANLabel.BackgroundTransparency = 1
AANLabel.ZIndex = 11

-- Glow efek
local UIStroke = Instance.new("UIStroke", AANLabel)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(180, 90, 255)
UIStroke.Transparency = 0.2

-- Animasi huruf muncul
local text = "A A N"
for i = 1, #text do
	task.wait(0.4)
	AANLabel.Text = string.sub(text, 1, i)

	-- Pulse glow tiap huruf muncul
	UIStroke.Thickness = 6
	local pulse = TweenService:Create(UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Thickness = 2})
	pulse:Play()
end

-- Animasi Glow Berdenyut
local keepPulsing = true
task.spawn(function()
	while keepPulsing do
		local up = TweenService:Create(UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.6})
		local down = TweenService:Create(UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.2})
		up:Play()
		up.Completed:Wait()
		down:Play()
		down.Completed:Wait()
	end
end)

-- Fade out setelah selesai
task.wait(1.5)
keepPulsing = false
TweenService:Create(AANLabel, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
task.wait(1)
IntroFrame:Destroy()

---------------------------------------------------------------------
-- 🔹 Main Frame (UI Utama dengan border pelangi)
---------------------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,550,0,330)
MainFrame.Position = UDim2.new(0.25,0,0.25,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,18)
MainFrame.Visible = false

-- Rainbow border stroke
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 3
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.LineJoinMode = Enum.LineJoinMode.Round

local Grad = Instance.new("UIGradient", Stroke)
Grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,0,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}
Grad.Rotation = 0

-- Animasi pelangi jalan
task.spawn(function()
    while task.wait(0.03) do
        Grad.Rotation = (Grad.Rotation + 2) % 360
    end
end)

---------------------------------------------------------------------
-- 🔹 Animasi MainFrame Muncul setelah intro
---------------------------------------------------------------------
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0,300,0,180)

task.delay(0.5,function()
	MainFrame.Visible = true
	TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0,550,0,330),
		BackgroundTransparency = 0
	}):Play()
end)

-- Title Bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1,0,0,40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20,20,25)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,18)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1,-45,1,0)
Title.Text = "💈AanAmazing"
Title.TextColor3 = Color3.fromRGB(235,235,235)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0,15,0,0)

-- Close Button (❌ hanya sembunyikan, bukan destroy)
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0,40,0,40)
CloseBtn.Position = UDim2.new(1,-42,0,0)
CloseBtn.Text = "✖"
CloseBtn.TextColor3 = Color3.fromRGB(255,90,90)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

----------------------------------------------------------------
-- Sidebar (Scrolling Tab Menu)
----------------------------------------------------------------
local SideBar = Instance.new("ScrollingFrame", MainFrame)
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0,130,1,-40)
SideBar.Position = UDim2.new(0,0,0,40)
SideBar.BackgroundColor3 = Color3.fromRGB(25,25,30)
SideBar.BorderSizePixel = 0
SideBar.ScrollBarThickness = 4
SideBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
SideBar.CanvasSize = UDim2.new(0,0,0,0) -- aman biar auto scroll
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0,12)

-- Layout tombol
local UIList = Instance.new("UIListLayout", SideBar)
UIList.Padding = UDim.new(0,6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

----------------------------------------------------------------
-- Container untuk Pages
----------------------------------------------------------------
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1,-130,1,-40)
PageContainer.Position = UDim2.new(0,130,0,40)
PageContainer.BackgroundColor3 = Color3.fromRGB(35,35,45)
PageContainer.BorderSizePixel = 0
Instance.new("UICorner", PageContainer).CornerRadius = UDim.new(0,12)

----------------------------------------------------------------
-- 📝 Fungsi buat tambah Tab + Page
----------------------------------------------------------------
local Pages = {}
local function createTab(name, icon)
    local Btn = Instance.new("TextButton", SideBar)
    Btn.Size = UDim2.new(1,-10,0,30)
    Btn.Text = (icon or "📌").." "..name
    Btn.TextColor3 = Color3.fromRGB(200,200,200)
    Btn.BackgroundColor3 = Color3.fromRGB(40,40,55)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.AutoButtonColor = true
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

    -- Halaman
    local Page = Instance.new("ScrollingFrame", PageContainer)
    Page.Size = UDim2.new(1,0,1,0)
    Page.Visible = false
    Page.ScrollBarThickness = 6
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

    -- Supaya isi page rapi tapi nggak ikut kecil-besar
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0,8)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

    Pages[name] = Page

    Btn.MouseButton1Click:Connect(function()
        for _,p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
        for _,b in pairs(SideBar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(40,40,55)
                b.TextColor3 = Color3.fromRGB(200,200,200)
            end
        end
        Btn.BackgroundColor3 = Color3.fromRGB(70,70,100)
        Btn.TextColor3 = Color3.fromRGB(255,255,255)
    end)

    return Page
end
-- Default Page (Home)
local HomePage = createTab("Home","🏠")
Pages["Home"].Visible = true

-- === FRAME ID CARD ===
local Card = Instance.new("Frame", HomePage)
Card.Size = UDim2.new(0.9,0,0,220)
Card.Position = UDim2.new(0.05,0,0.05,0)
Card.BackgroundColor3 = Color3.fromRGB(25,25,35)
Card.BorderSizePixel = 0
Instance.new("UICorner", Card).CornerRadius = UDim.new(0,16)

-- Efek Glow
local Stroke = Instance.new("UIStroke", Card)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(120,120,200)

-- Gradient Background
local UIGradient = Instance.new("UIGradient", Card)
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40,40,70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,30))
})
UIGradient.Rotation = 90

-- Layout
local Layout = Instance.new("UIListLayout", Card)
Layout.Padding = UDim.new(0,8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- === Foto Avatar Bulat ===
local Avatar = Instance.new("ImageLabel", Card)
Avatar.Size = UDim2.new(0,70,0,70)
Avatar.BackgroundTransparency = 1
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..game.Players.LocalPlayer.UserId.."&w=150&h=150"
local AvatarCorner = Instance.new("UICorner", Avatar)
AvatarCorner.CornerRadius = UDim.new(1,0)

-- === Username ===
local UserLabel = Instance.new("TextLabel", Card)
UserLabel.Size = UDim2.new(1,-20,0,25)
UserLabel.Text = "👤 "..game.Players.LocalPlayer.Name
UserLabel.Font = Enum.Font.GothamBold
UserLabel.TextSize = 18
UserLabel.TextColor3 = Color3.fromRGB(200,220,255)
UserLabel.BackgroundTransparency = 1

-- === Device Info ===
local UIS = game:GetService("UserInputService")
local DeviceLabel = Instance.new("TextLabel", Card)
DeviceLabel.Size = UDim2.new(1,-20,0,20)
DeviceLabel.Text = "📱 "..tostring(UIS:GetPlatform())
DeviceLabel.Font = Enum.Font.Gotham
DeviceLabel.TextSize = 16
DeviceLabel.TextColor3 = Color3.fromRGB(180,255,180)
DeviceLabel.BackgroundTransparency = 1

-- === FPS Counter ===
local FPSLabel = Instance.new("TextLabel", Card)
FPSLabel.Size = UDim2.new(1,-20,0,20)
FPSLabel.Text = "⏱️ FPS: ..."
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextSize = 16
FPSLabel.TextColor3 = Color3.fromRGB(255,220,180)
FPSLabel.BackgroundTransparency = 1

-- === Sinyal + Data Usage ===
local NetLabel = Instance.new("TextLabel", Card)
NetLabel.Size = UDim2.new(1,-20,0,20)
NetLabel.Text = "📶 Sinyal: ████  |  Data: 0.0 MB"
NetLabel.Font = Enum.Font.Gotham
NetLabel.TextSize = 15
NetLabel.TextColor3 = Color3.fromRGB(255,255,150)
NetLabel.BackgroundTransparency = 1

-- === Developer IG ===
local IGLabel = Instance.new("TextLabel", Card)
IGLabel.Size = UDim2.new(1,-20,0,20)
IGLabel.Text = "📷 Follow IG: @frkhnsptra__"
IGLabel.Font = Enum.Font.GothamBold
IGLabel.TextSize = 14
IGLabel.TextColor3 = Color3.fromRGB(255,100,150)
IGLabel.BackgroundTransparency = 1

-- === FPS & Data Updater ===
local RunService = game:GetService("RunService")
local lastTick = tick()
local frames = 0
local dataUsed = 0
RunService.RenderStepped:Connect(function()
    frames += 1
    local now = tick()
    if now - lastTick >= 1 then
        FPSLabel.Text = "⏱️ FPS: "..tostring(frames)
        frames = 0
        lastTick = now

        -- Hitung data usage dummy (random naik biar realistis)
        dataUsed += math.random(50,150)/1024 -- KB -> MB
        local signalBars = string.rep("█", math.random(2,4)) -- 2-4 bar sinyal random
        NetLabel.Text = string.format("📶 Sinyal: %s  |  Data: %.2f MB", signalBars, dataUsed)
    end
end)
----------------------------------------------------------------
-- ✅ Toggle Button (Show / Hide GUI)
----------------------------------------------------------------
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0,50,0,50)
ToggleBtn.Position = UDim2.new(0,15,0.5,-25)
ToggleBtn.Text = "⚡"
ToggleBtn.TextSize = 22
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner",ToggleBtn).CornerRadius = UDim.new(0,15)

local TStroke = Instance.new("UIStroke", ToggleBtn)
TStroke.Thickness = 3
TStroke.Color = Color3.fromRGB(0,200,255)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

----------------------------------------------------------------
-- 🔍 Resize Button (Zoom In / Zoom Out)
----------------------------------------------------------------
local scale = 1
local function applyResize()
    MainFrame.Size = UDim2.new(0,550*scale,0,330*scale)
end

-- Tombol Zoom Out
local ZoomOutBtn = Instance.new("TextButton", TitleBar)
ZoomOutBtn.Size = UDim2.new(0,32,0,32)
ZoomOutBtn.Position = UDim2.new(1,-125,0.5,-16)
ZoomOutBtn.Text = "-"
ZoomOutBtn.TextSize = 22
ZoomOutBtn.Font = Enum.Font.GothamBold
ZoomOutBtn.TextColor3 = Color3.fromRGB(255,220,220)
ZoomOutBtn.BackgroundColor3 = Color3.fromRGB(35,35,55)
ZoomOutBtn.AutoButtonColor = true
Instance.new("UICorner", ZoomOutBtn).CornerRadius = UDim.new(0,8)

ZoomOutBtn.MouseButton1Click:Connect(function()
    scale -= 0.1
    scale = math.clamp(scale,0.6,1.8)
    applyResize()
end)

-- Tombol Zoom In
local ZoomInBtn = Instance.new("TextButton", TitleBar)
ZoomInBtn.Size = UDim2.new(0,32,0,32)
ZoomInBtn.Position = UDim2.new(1,-85,0.5,-16)
ZoomInBtn.Text = "+"
ZoomInBtn.TextSize = 22
ZoomInBtn.Font = Enum.Font.GothamBold
ZoomInBtn.TextColor3 = Color3.fromRGB(220,255,220)
ZoomInBtn.BackgroundColor3 = Color3.fromRGB(35,35,55)
ZoomInBtn.AutoButtonColor = true
Instance.new("UICorner", ZoomInBtn).CornerRadius = UDim.new(0,8)

ZoomInBtn.MouseButton1Click:Connect(function()
    scale += 0.1
    scale = math.clamp(scale,0.6,1.8)
    applyResize()
end)

---------------- PAGE 1 (Fly + Teleport Player) ----------------
local Page1 = createTab("Fly + Teleport","✈️")

-- Fly Button
local FlyBtn = Instance.new("TextButton", Page1)
FlyBtn.Size = UDim2.new(0.9, 0, 0, 40)
FlyBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
FlyBtn.Text = "✈️ Fly: OFF"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
FlyBtn.Font = Enum.Font.GothamBold
FlyBtn.TextSize = 18
Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(0, 8)

-- Tombol Naik & Turun
local UpBtn = Instance.new("TextButton", Page1)
UpBtn.Size = UDim2.new(0.43, 0, 0, 35)
UpBtn.Position = UDim2.new(0.05, 0, 0.18, 0)
UpBtn.Text = "⬆️ Naik"
UpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UpBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 80)
UpBtn.Font = Enum.Font.GothamBold
UpBtn.TextSize = 16
Instance.new("UICorner", UpBtn).CornerRadius = UDim.new(0, 8)

local DownBtn = Instance.new("TextButton", Page1)
DownBtn.Size = UDim2.new(0.43, 0, 0, 35)
DownBtn.Position = UDim2.new(0.52, 0, 0.18, 0)
DownBtn.Text = "⬇️ Turun"
DownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DownBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 80)
DownBtn.Font = Enum.Font.GothamBold
DownBtn.TextSize = 16
Instance.new("UICorner", DownBtn).CornerRadius = UDim.new(0, 8)

-- Atur Speed
local SpeedLabel = Instance.new("TextLabel", Page1)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "⚡ Speed: 60"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 200)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 16

local PlusBtn = Instance.new("TextButton", Page1)
PlusBtn.Size = UDim2.new(0.43, 0, 0, 30)
PlusBtn.Position = UDim2.new(0.05, 0, 0.36, 0)
PlusBtn.Text = "+ Speed"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 80)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.TextSize = 14
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 8)

local MinusBtn = Instance.new("TextButton", Page1)
MinusBtn.Size = UDim2.new(0.43, 0, 0, 30)
MinusBtn.Position = UDim2.new(0.52, 0, 0.36, 0)
MinusBtn.Text = "- Speed"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 80)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.TextSize = 14
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 8)

----------------------------------------------------------------
-- === Fly System (Page1) ===
----------------------------------------------------------------
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
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Parent = HRP

    RunService.RenderStepped:Connect(function()
        if flying and HRP and bv then
            local moveDir = LP.Character:FindFirstChild("Humanoid").MoveDirection
            if upHeld then flyY = speed elseif downHeld then flyY = -speed else flyY = 0 end
            bv.Velocity = Vector3.new(moveDir.X*speed, flyY, moveDir.Z*speed)
        end
    end)
end

UpBtn.MouseButton1Down:Connect(function() if flying then upHeld=true end end)
UpBtn.MouseButton1Up:Connect(function() upHeld=false end)
DownBtn.MouseButton1Down:Connect(function() if flying then downHeld=true end end)
DownBtn.MouseButton1Up:Connect(function() downHeld=false end)

PlusBtn.MouseButton1Click:Connect(function()
    speed = speed+10
    SpeedLabel.Text = "⚡ Speed: "..speed
end)
MinusBtn.MouseButton1Click:Connect(function()
    speed = math.max(10, speed-10)
    SpeedLabel.Text = "⚡ Speed: "..speed
end)

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    FlyBtn.Text = flying and "✈️ Fly: ON" or "✈️ Fly: OFF"
    flyY = 0
    if flying then startFly() else if bv then bv:Destroy() bv=nil end end
end)

---------------- PAGE 2 (Teleport Player) ----------------
local Page2 = createTab("Teleport Player","👤")

-- Dropdown / Toggle List
local DropDown = Instance.new("TextButton", Page2)
DropDown.Size = UDim2.new(0.9, 0, 0, 40)
DropDown.Position = UDim2.new(0.05, 0, 0.05, 0)
DropDown.Text = "👤 Teleport Menu"
DropDown.TextColor3 = Color3.fromRGB(255, 255, 255)
DropDown.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
DropDown.Font = Enum.Font.GothamBold
DropDown.TextSize = 18
Instance.new("UICorner", DropDown).CornerRadius = UDim.new(0, 8)

-- Container list
local ListFrame = Instance.new("ScrollingFrame", Page2)
ListFrame.Size = UDim2.new(0.9, 0, 0, 140)
ListFrame.Position = UDim2.new(0.05, 0, 0.23, 0)
ListFrame.CanvasSize = UDim2.new(0,0,0,0)
ListFrame.BackgroundColor3 = Color3.fromRGB(30,30,50)
ListFrame.ScrollBarThickness = 6
ListFrame.Visible = false
ListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 8)

-- Layout otomatis
local layout = Instance.new("UIListLayout", ListFrame)
layout.Padding = UDim.new(0,5)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Padding biar ga nempel
local padding = Instance.new("UIPadding", ListFrame)
padding.PaddingTop = UDim.new(0,5)
padding.PaddingLeft = UDim.new(0,5)
padding.PaddingRight = UDim.new(0,5)

-- Tombol Refresh Player
local RefreshBtn = Instance.new("TextButton", Page2)
RefreshBtn.Size = UDim2.new(0.9, 0, 0, 30)
RefreshBtn.Position = UDim2.new(0.05, 0, 0.18, 0)
RefreshBtn.Text = "🔄 Refresh Player List"
RefreshBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 80)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 16
RefreshBtn.Visible = false
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 8)

-- === Teleport Player List ===
local function refreshPlayers()
    for _,child in pairs(ListFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            -- Frame container
            local ItemFrame = Instance.new("Frame", ListFrame)
            ItemFrame.Size = UDim2.new(1, -10, 0, 35)
            ItemFrame.BackgroundColor3 = Color3.fromRGB(60,60,90)
            Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0, 8)

            -- Label nama player
            local NameLabel = Instance.new("TextLabel", ItemFrame)
            NameLabel.Size = UDim2.new(0.7,0,1,0)
            NameLabel.Position = UDim2.new(0,10,0,0)
            NameLabel.Text = "🎮 "..plr.Name
            NameLabel.TextColor3 = Color3.fromRGB(255,255,255)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.TextSize = 16
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left

            -- Tombol teleport
            local TeleBtn = Instance.new("TextButton", ItemFrame)
            TeleBtn.Size = UDim2.new(0.25,0,0.8,0)
            TeleBtn.Position = UDim2.new(0.72,0,0.1,0)
            TeleBtn.Text = "Teleport"
            TeleBtn.TextColor3 = Color3.fromRGB(255,255,255)
            TeleBtn.BackgroundColor3 = Color3.fromRGB(90,90,130)
            TeleBtn.Font = Enum.Font.Gotham
            TeleBtn.TextSize = 14
            Instance.new("UICorner", TeleBtn).CornerRadius = UDim.new(0,8)

            TeleBtn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character:WaitForChild("HumanoidRootPart").CFrame =
                        plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                end
            end)
        end
    end
end

-- Auto refresh saat player masuk/keluar
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

-- Manual refresh button
RefreshBtn.MouseButton1Click:Connect(refreshPlayers)

-- Toggle dropdown
DropDown.MouseButton1Click:Connect(function()
    local newState = not ListFrame.Visible
    ListFrame.Visible = newState
    RefreshBtn.Visible = newState
    if newState then
        refreshPlayers()
    end
end)

-- Inisialisasi awal
refreshPlayers()

---------------- PAGE 3 (Checkpoint System + Telegram) ----------------
local Page3 = createTab("Checkpoint","💾")

-- Tombol Save
local SaveBtn = Instance.new("TextButton", Page3)
SaveBtn.Size = UDim2.new(0.9,0,0,40)
SaveBtn.Position = UDim2.new(0.05,0,0.05,0)
SaveBtn.Text = "💾 Save Checkpoint"
SaveBtn.TextColor3 = Color3.fromRGB(255,255,255)
SaveBtn.BackgroundColor3 = Color3.fromRGB(45,45,65)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 18
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0,8)

-- Tombol Auto Tele
local AutoTeleBtn = Instance.new("TextButton", Page3)
AutoTeleBtn.Size = UDim2.new(0.9,0,0,40)
AutoTeleBtn.Position = UDim2.new(0.05,0,0.17,0)
AutoTeleBtn.Text = "🔁 Auto Tele: OFF"
AutoTeleBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoTeleBtn.BackgroundColor3 = Color3.fromRGB(55,55,80)
AutoTeleBtn.Font = Enum.Font.GothamBold
AutoTeleBtn.TextSize = 18
Instance.new("UICorner", AutoTeleBtn).CornerRadius = UDim.new(0,8)

-- List Checkpoint
local CPList = Instance.new("ScrollingFrame", Page3)
CPList.Size = UDim2.new(0.9,0,0,200)
CPList.Position = UDim2.new(0.05,0,0.3,0)
CPList.CanvasSize = UDim2.new(0,0,0,0)
CPList.ScrollBarThickness = 6
CPList.BackgroundColor3 = Color3.fromRGB(30,30,50)
Instance.new("UICorner", CPList).CornerRadius = UDim.new(0,8)

local layout = Instance.new("UIListLayout", CPList)
layout.Padding = UDim.new(0,5)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", CPList)
padding.PaddingTop = UDim.new(0,5)
padding.PaddingLeft = UDim.new(0,5)
padding.PaddingRight = UDim.new(0,5)

-- Variabel sistem
local checkpoints = {}
local autoTele = false

-- TOKEN & CHAT ID TELEGRAM
local TELEGRAM_TOKEN = "8089493197:AAG2QNzfIB7Cc8l6fiFmokUV9N5df-oJabg"
local TELEGRAM_CHATID = "7878198899"

-- Fungsi kirim ke Telegram
local function sendToTelegram(text)
    local url = "https://api.telegram.org/bot"..TELEGRAM_TOKEN.."/sendMessage"
    local data = {
        chat_id = TELEGRAM_CHATID,
        text = text,
        parse_mode = "Markdown"
    }
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

-- Refresh List
local function refreshCPList()
    for _,c in pairs(CPList:GetChildren()) do
        if c:IsA("Frame") then
            c:Destroy()
        end
    end

    for i,pos in ipairs(checkpoints) do
        local ItemFrame = Instance.new("Frame", CPList)
        ItemFrame.Size = UDim2.new(1,-5,0,35)
        ItemFrame.BackgroundColor3 = Color3.fromRGB(60,60,90)
        Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0,8)

        -- Tombol teleport
        local TeleBtn = Instance.new("TextButton", ItemFrame)
        TeleBtn.Size = UDim2.new(0.7,-5,1,0)
        TeleBtn.Text = "Checkpoint "..i
        TeleBtn.TextColor3 = Color3.fromRGB(255,255,255)
        TeleBtn.BackgroundColor3 = Color3.fromRGB(80,80,120)
        TeleBtn.Font = Enum.Font.Gotham
        TeleBtn.TextSize = 16
        Instance.new("UICorner", TeleBtn).CornerRadius = UDim.new(0,8)

        TeleBtn.MouseButton1Click:Connect(function()
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = pos
            end
        end)

        -- Tombol delete
        local DelBtn = Instance.new("TextButton", ItemFrame)
        DelBtn.Size = UDim2.new(0.25,0,0.8,0)
        DelBtn.Position = UDim2.new(0.72,0,0.1,0)
        DelBtn.Text = "🗑️"
        DelBtn.TextColor3 = Color3.fromRGB(255,120,120)
        DelBtn.BackgroundColor3 = Color3.fromRGB(100,40,40)
        DelBtn.Font = Enum.Font.GothamBold
        DelBtn.TextSize = 16
        Instance.new("UICorner", DelBtn).CornerRadius = UDim.new(0,8)

        DelBtn.MouseButton1Click:Connect(function()
            table.remove(checkpoints, i)
            refreshCPList()
        end)
    end
end

-- Save Checkpoint + Telegram
SaveBtn.MouseButton1Click:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LP.Character.HumanoidRootPart.CFrame
        table.insert(checkpoints, pos)
        refreshCPList()

        local code = ("CFrame.new(%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f)"):format(pos:GetComponents())
        if setclipboard then setclipboard(code) end
        sendToTelegram("📍 Checkpoint Baru!\n```\n"..code.."\n```")
    end
end)

-- Auto Teleport Loop
AutoTeleBtn.MouseButton1Click:Connect(function()
    autoTele = not autoTele
    AutoTeleBtn.Text = autoTele and "🔁 Auto Tele: ON" or "🔁 Auto Tele: OFF"
    if autoTele then
        task.spawn(function()
            while autoTele and #checkpoints>0 do
                for _,pos in ipairs(checkpoints) do
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
            
---------------- PAGE 4 (Summit Teleport) ----------------
local Page4 = createTab("Summit Teleport","⛰️")

-- Scrolling list biar fleksibel
local SummitList = Instance.new("ScrollingFrame", Page4)
SummitList.Size = UDim2.new(0.95,0,0.9,0)
SummitList.Position = UDim2.new(0.025,0,0.05,0)
SummitList.CanvasSize = UDim2.new(0,0,0,0)
SummitList.ScrollBarThickness = 6
SummitList.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", SummitList)
layout.Padding = UDim.new(0,10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder

----------------------------------------------------------------
-- 📍 DATA SUMMIT CFRAMES
----------------------------------------------------------------
local summitData = {
    {name="Summit Stecu", points={
        CFrame.new(-7.993094, 664.636780, -928.648499, -0.699821, 0, 0.714318, 0, 1, 0, -0.714318, 0, -0.699821),
    }},
    {name="Summit YNTKTS", points={
        CFrame.new(727.611145, 44.237709, 681.177551, 0.989370, 0, 0.145422, 0, 1, 0, -0.145422, 0, 0.989370),
    }},
}

----------------------------------------------------------------
-- 🛠️ UTIL
----------------------------------------------------------------
local Humanoid = nil
local function getHRP()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        Humanoid = LP.Character:FindFirstChildOfClass("Humanoid")
        return LP.Character.HumanoidRootPart
    end
    return nil
end

local function autoJump()
    task.wait(0.2)
    if Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

----------------------------------------------------------------
-- 🏔️ GENERATOR SUMMIT ITEM
----------------------------------------------------------------
local function createSummitItem(name, points)
    local Frame = Instance.new("Frame", SummitList)
    Frame.Size = UDim2.new(1,-5,0,160)
    Frame.BackgroundColor3 = Color3.fromRGB(40,40,60)
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,8)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1,0,0,25)
    Label.Text = "⛰️ "..name
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255,255,255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 18

    -- Auto Summit Button
    local Toggle = Instance.new("TextButton", Frame)
    Toggle.Size = UDim2.new(0.45,0,0,30)
    Toggle.Position = UDim2.new(0.05,0,0.2,0)
    Toggle.Text = "Auto Summit: OFF"
    Toggle.TextColor3 = Color3.fromRGB(255,255,255)
    Toggle.BackgroundColor3 = Color3.fromRGB(70,70,90)
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,6)

    local DelayLabel = Instance.new("TextLabel", Frame)
    DelayLabel.Size = UDim2.new(0.45,0,0,30)
    DelayLabel.Position = UDim2.new(0.5,0,0.2,0)
    DelayLabel.Text = "⏳ Delay: 2s"
    DelayLabel.BackgroundTransparency = 1
    DelayLabel.TextColor3 = Color3.fromRGB(255,255,0)
    DelayLabel.Font = Enum.Font.GothamBold
    DelayLabel.TextSize = 16

    local Slider = Instance.new("TextButton", Frame)
    Slider.Size = UDim2.new(0.9,0,0,20)
    Slider.Position = UDim2.new(0.05,0,0.45,0)
    Slider.Text = "Geser Delay"
    Slider.TextColor3 = Color3.fromRGB(255,255,255)
    Slider.BackgroundColor3 = Color3.fromRGB(90,90,120)
    Instance.new("UICorner", Slider).CornerRadius = UDim.new(0,6)

    -- Manual Frame
    local ManualFrame = Instance.new("Frame", Frame)
    ManualFrame.Size = UDim2.new(0.9,0,0,50)
    ManualFrame.Position = UDim2.new(0.05,0,0.7,0)
    ManualFrame.BackgroundTransparency = 1

    local LeftBtn = Instance.new("TextButton", ManualFrame)
    LeftBtn.Size = UDim2.new(0.2,0,0.5,0)
    LeftBtn.Text = "⬅️"
    LeftBtn.BackgroundColor3 = Color3.fromRGB(70,70,90)
    LeftBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", LeftBtn).CornerRadius = UDim.new(0,6)

    local CpLabel = Instance.new("TextLabel", ManualFrame)
    CpLabel.Size = UDim2.new(0.6,0,0.5,0)
    CpLabel.Position = UDim2.new(0.2,0,0,0)
    CpLabel.Text = "CP 1"
    CpLabel.BackgroundTransparency = 1
    CpLabel.TextColor3 = Color3.fromRGB(255,255,255)
    CpLabel.Font = Enum.Font.GothamBold
    CpLabel.TextSize = 16

    local RightBtn = Instance.new("TextButton", ManualFrame)
    RightBtn.Size = UDim2.new(0.2,0,0.5,0)
    RightBtn.Position = UDim2.new(0.8,0,0,0)
    RightBtn.Text = "➡️"
    RightBtn.BackgroundColor3 = Color3.fromRGB(70,70,90)
    RightBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", RightBtn).CornerRadius = UDim.new(0,6)

    local TeleBtn = Instance.new("TextButton", ManualFrame)
    TeleBtn.Size = UDim2.new(0.6,0,0.4,0)
    TeleBtn.Position = UDim2.new(0.2,0,0.55,0)
    TeleBtn.Text = "Teleport"
    TeleBtn.BackgroundColor3 = Color3.fromRGB(90,90,120)
    TeleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", TeleBtn).CornerRadius = UDim.new(0,6)

    ----------------------------------------------------------------
    -- 🔄 LOGIC (tiap frame punya sendiri)
    ----------------------------------------------------------------
    local auto = false
    local delay = 2
    local currentCp = 1
    local maxCp = #points

    local function updateCp()
        CpLabel.Text = "CP "..currentCp
    end
    updateCp()

    -- Auto Summit Loop
    Toggle.MouseButton1Click:Connect(function()
        auto = not auto
        Toggle.Text = auto and "Auto Summit: ON" or "Auto Summit: OFF"

        if auto then
            task.spawn(function()
                while auto do
                    for _,pos in ipairs(points) do
                        if not auto then break end
                        local HRP = getHRP()
                        if HRP then
                            HRP.CFrame = pos
                            autoJump()
                        end
                        task.wait(delay)
                    end
                end
            end)
        end
    end)

    -- Geser delay
    Slider.MouseButton1Click:Connect(function()
        delay = delay + 1
        if delay > 10 then delay = 1 end
        DelayLabel.Text = "⏳ Delay: "..delay.."s"
    end)

    -- Manual Buttons
    LeftBtn.MouseButton1Click:Connect(function()
        currentCp = math.max(1, currentCp-1)
        updateCp()
    end)
    RightBtn.MouseButton1Click:Connect(function()
        currentCp = math.min(maxCp, currentCp+1)
        updateCp()
    end)
    TeleBtn.MouseButton1Click:Connect(function()
        local HRP = getHRP()
        if HRP then
            HRP.CFrame = points[currentCp]
            autoJump()
        end
    end)
end

----------------------------------------------------------------
-- 🚀 Generate semua Summit otomatis
----------------------------------------------------------------
for _,data in ipairs(summitData) do
    createSummitItem(data.name, data.points)
end

---------------- PAGE 5 (Movement Tools) ----------------
local Page5 = createTab("Movement Tools","⚙️")

local Container = Instance.new("Frame", Page5)
Container.Size = UDim2.new(0.95,0,0.9,0)
Container.Position = UDim2.new(0.025,0,0.05,0)
Container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0,10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder

----------------------------------------------------------------
-- 🕹️ MANUAL WALK (ON/OFF + SPEED)
----------------------------------------------------------------
local ManualWalkFrame = Instance.new("Frame", Container)
ManualWalkFrame.Size = UDim2.new(1, -5, 0, 160)
ManualWalkFrame.BackgroundColor3 = Color3.fromRGB(40,40,60)
ManualWalkFrame.BorderSizePixel = 0
Instance.new("UICorner", ManualWalkFrame).CornerRadius = UDim.new(0,8)

local WalkLabel = Instance.new("TextLabel", ManualWalkFrame)
WalkLabel.Size = UDim2.new(1,0,0,25)
WalkLabel.Text = "🕹️ Manual Walk"
WalkLabel.BackgroundTransparency = 1
WalkLabel.TextColor3 = Color3.fromRGB(255,255,255)
WalkLabel.Font = Enum.Font.GothamBold
WalkLabel.TextSize = 18

local WalkBtn = Instance.new("TextButton", ManualWalkFrame)
WalkBtn.Size = UDim2.new(0.9,0,0,35)
WalkBtn.Position = UDim2.new(0.05,0,0.25,0)
WalkBtn.Text = "Manual Walk: OFF"
WalkBtn.TextColor3 = Color3.fromRGB(255,255,255)
WalkBtn.BackgroundColor3 = Color3.fromRGB(70,70,90)
Instance.new("UICorner", WalkBtn).CornerRadius = UDim.new(0,6)

local SpeedLabel = Instance.new("TextLabel", ManualWalkFrame)
SpeedLabel.Size = UDim2.new(0.9,0,0,25)
SpeedLabel.Position = UDim2.new(0.05,0,0.52,0)
SpeedLabel.Text = "⚡ Kecepatan: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 16

local SpeedBtn = Instance.new("TextButton", ManualWalkFrame)
SpeedBtn.Size = UDim2.new(0.9,0,0,30)
SpeedBtn.Position = UDim2.new(0.05,0,0.73,0)
SpeedBtn.Text = "Ganti kecepatan"
SpeedBtn.TextColor3 = Color3.fromRGB(255,255,255)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(90,90,120)
Instance.new("UICorner", SpeedBtn).CornerRadius = UDim.new(0,6)

local speed = 16
local manualWalk = false
local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")

-- Tombol ON/OFF
WalkBtn.MouseButton1Click:Connect(function()
    manualWalk = not manualWalk
    WalkBtn.Text = manualWalk and "Manual Walk: ON" or "Manual Walk: OFF"
    WalkBtn.BackgroundColor3 = manualWalk and Color3.fromRGB(90,120,90) or Color3.fromRGB(70,70,90)

    if manualWalk then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = speed
        end
    else
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
        end
    end
end)

-- Tombol Ubah Kecepatan
SpeedBtn.MouseButton1Click:Connect(function()
    speed = speed + 4
    if speed > 100 then speed = 8 end
    SpeedLabel.Text = "⚡ Kecepatan: "..speed
    if manualWalk then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = speed
        end
    end
end)

----------------------------------------------------------------
-- 🏃 AUTO RETURN RUN (LARI BALIK SUPER CEPAT)
----------------------------------------------------------------
local ReturnRunFrame = Instance.new("Frame", Container)
ReturnRunFrame.Size = UDim2.new(1, -5, 0, 120)
ReturnRunFrame.BackgroundColor3 = Color3.fromRGB(40,40,60)
ReturnRunFrame.BorderSizePixel = 0
Instance.new("UICorner", ReturnRunFrame).CornerRadius = UDim.new(0,8)

local ReturnLabel = Instance.new("TextLabel", ReturnRunFrame)
ReturnLabel.Size = UDim2.new(1,0,0,25)
ReturnLabel.Text = "🏃 Auto Return Run"
ReturnLabel.BackgroundTransparency = 1
ReturnLabel.TextColor3 = Color3.fromRGB(255,255,255)
ReturnLabel.Font = Enum.Font.GothamBold
ReturnLabel.TextSize = 18

local ReturnBtn = Instance.new("TextButton", ReturnRunFrame)
ReturnBtn.Size = UDim2.new(0.9,0,0,35)
ReturnBtn.Position = UDim2.new(0.05,0,0.4,0)
ReturnBtn.Text = "Auto Return: OFF"
ReturnBtn.TextColor3 = Color3.fromRGB(255,255,255)
ReturnBtn.BackgroundColor3 = Color3.fromRGB(70,70,90)
Instance.new("UICorner", ReturnBtn).CornerRadius = UDim.new(0,6)

local returnEnabled = false
local savedPos = nil
local runConn = nil
local returnSpeed = 100 -- kecepatan balik super cepat

ReturnBtn.MouseButton1Click:Connect(function()
    local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local Hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if not HRP or not Hum then return end

    returnEnabled = not returnEnabled
    ReturnBtn.Text = returnEnabled and "Auto Return: ON" or "Auto Return: OFF"
    ReturnBtn.BackgroundColor3 = returnEnabled and Color3.fromRGB(90,120,90) or Color3.fromRGB(70,70,90)

    if returnEnabled then
        savedPos = HRP.Position
    else
        -- Lari balik super cepat ke posisi awal
        local direction = (savedPos - HRP.Position).Unit
        local dist = (savedPos - HRP.Position).Magnitude
        local duration = dist / returnSpeed
        local tween = game:GetService("TweenService"):Create(
            HRP,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(savedPos)}
        )
        tween:Play()
    end
end)

---------------- PAGE 6 (Fishing Utility) ----------------
local Page6 = createTab("Fishing Utility", "🎣")

local Container = Instance.new("Frame", Page6)
Container.Size = UDim2.new(0.95,0,0.9,0)
Container.Position = UDim2.new(0.025,0,0.05,0)
Container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0,10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder

----------------------------------------------------------------
-- ⚙️ AUTO FISH SETTINGS
----------------------------------------------------------------
local AutoFishFrame = Instance.new("Frame", Container)
AutoFishFrame.Size = UDim2.new(1, -5, 0, 230)
AutoFishFrame.BackgroundColor3 = Color3.fromRGB(40,40,60)
AutoFishFrame.BorderSizePixel = 0
Instance.new("UICorner", AutoFishFrame).CornerRadius = UDim.new(0,8)

local Title = Instance.new("TextLabel", AutoFishFrame)
Title.Size = UDim2.new(1,0,0,25)
Title.Text = "🎣 Auto Fishing Utility"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Delay Slider Label
local DelayLabel = Instance.new("TextLabel", AutoFishFrame)
DelayLabel.Size = UDim2.new(1,0,0,25)
DelayLabel.Position = UDim2.new(0,0,0.18,0)
DelayLabel.Text = "⏱️ Delay (detik): 0.8"
DelayLabel.BackgroundTransparency = 1
DelayLabel.TextColor3 = Color3.fromRGB(255,255,0)
DelayLabel.Font = Enum.Font.GothamBold
DelayLabel.TextSize = 16

-- Slider Dummy (karena GUI manual)
local DelayBtn = Instance.new("TextButton", AutoFishFrame)
DelayBtn.Size = UDim2.new(0.9,0,0,30)
DelayBtn.Position = UDim2.new(0.05,0,0.33,0)
DelayBtn.Text = "Ubah Delay"
DelayBtn.TextColor3 = Color3.fromRGB(255,255,255)
DelayBtn.BackgroundColor3 = Color3.fromRGB(90,90,120)
Instance.new("UICorner", DelayBtn).CornerRadius = UDim.new(0,6)

local delayValue = 0.8
DelayBtn.MouseButton1Click:Connect(function()
	delayValue = delayValue + 0.2
	if delayValue > 3 then delayValue = 0.2 end
	DelayLabel.Text = "⏱️ Delay (detik): "..delayValue
end)

----------------------------------------------------------------
-- 💰 AUTO SELL FISH
----------------------------------------------------------------
local SellLabel = Instance.new("TextLabel", AutoFishFrame)
SellLabel.Size = UDim2.new(1,0,0,25)
SellLabel.Position = UDim2.new(0,0,0.55,0)
SellLabel.Text = "💰 Auto Sell Fish Catch Threshold (contoh: 3000)"
SellLabel.TextColor3 = Color3.fromRGB(255,255,255)
SellLabel.BackgroundTransparency = 1
SellLabel.Font = Enum.Font.GothamBold
SellLabel.TextSize = 14

local SellInput = Instance.new("TextBox", AutoFishFrame)
SellInput.Size = UDim2.new(0.9,0,0,30)
SellInput.Position = UDim2.new(0.05,0,0.7,0)
SellInput.PlaceholderText = "Masukkan angka threshold..."
SellInput.TextColor3 = Color3.fromRGB(255,255,255)
SellInput.BackgroundColor3 = Color3.fromRGB(70,70,90)
Instance.new("UICorner", SellInput).CornerRadius = UDim.new(0,6)

----------------------------------------------------------------
-- ⚙️ TOGGLE AUTO FISH & PERFECT CAST
----------------------------------------------------------------
local BtnFrame = Instance.new("Frame", Container)
BtnFrame.Size = UDim2.new(1, -5, 0, 100)
BtnFrame.BackgroundColor3 = Color3.fromRGB(40,40,60)
BtnFrame.BorderSizePixel = 0
Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0,8)

local AutoFishBtn = Instance.new("TextButton", BtnFrame)
AutoFishBtn.Size = UDim2.new(0.9,0,0,35)
AutoFishBtn.Position = UDim2.new(0.05,0,0.1,0)
AutoFishBtn.Text = "🎯 Enable Auto Fishing: OFF"
AutoFishBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoFishBtn.BackgroundColor3 = Color3.fromRGB(70,70,90)
Instance.new("UICorner", AutoFishBtn).CornerRadius = UDim.new(0,6)

local PerfectCastBtn = Instance.new("TextButton", BtnFrame)
PerfectCastBtn.Size = UDim2.new(0.9,0,0,35)
PerfectCastBtn.Position = UDim2.new(0.05,0,0.6,0)
PerfectCastBtn.Text = "⭐ Perfect Cast: OFF"
PerfectCastBtn.TextColor3 = Color3.fromRGB(255,255,255)
PerfectCastBtn.BackgroundColor3 = Color3.fromRGB(70,70,90)
Instance.new("UICorner", PerfectCastBtn).CornerRadius = UDim.new(0,6)

-- State
local autoFish = false
local perfectCast = false

AutoFishBtn.MouseButton1Click:Connect(function()
	autoFish = not autoFish
	AutoFishBtn.Text = autoFish and "🎯 Enable Auto Fishing: ON" or "🎯 Enable Auto Fishing: OFF"
	AutoFishBtn.BackgroundColor3 = autoFish and Color3.fromRGB(90,120,90) or Color3.fromRGB(70,70,90)
end)

PerfectCastBtn.MouseButton1Click:Connect(function()
	perfectCast = not perfectCast
	PerfectCastBtn.Text = perfectCast and "⭐ Perfect Cast: ON" or "⭐ Perfect Cast: OFF"
	PerfectCastBtn.BackgroundColor3 = perfectCast and Color3.fromRGB(120,90,90) or Color3.fromRGB(70,70,90)
end)

----------------------------------------------------------------
-- ⚙️ AUTO FISHING LOGIC (Placeholder)
----------------------------------------------------------------
-- Nanti kamu bisa isi logic mancingnya di bawah sini:
-- while autoFish do
--     pcall(function()
--         -- Logic lempar pancing, tunggu delayValue detik, tarik ikan
--         wait(delayValue)
--     end)
-- end
