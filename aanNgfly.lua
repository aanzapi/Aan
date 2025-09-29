----------------------------------------------------------------
-- 🌌 ELEGANT SUMMIT GUI (Dark + Rainbow Border + Resize)
----------------------------------------------------------------

-- Services
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProGUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,550,0,330)
MainFrame.Position = UDim2.new(0.25,0,0.25,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,18)

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

-- Sidebar (Tab Menu)
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0,130,1,-40)
SideBar.Position = UDim2.new(0,0,0,40)
SideBar.BackgroundColor3 = Color3.fromRGB(25,25,30)
SideBar.BorderSizePixel = 0
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0,12)

local UIList = Instance.new("UIListLayout", SideBar)
UIList.Padding = UDim.new(0,6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Container untuk Pages
local PageContainer = Instance.new("Frame", MainFrame)
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
    Btn.Size = UDim2.new(1,0,0,30)
    Btn.Text = (icon or "📌").." "..name
    Btn.TextColor3 = Color3.fromRGB(200,200,200)
    Btn.BackgroundColor3 = Color3.fromRGB(40,40,55)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

    local Page = Instance.new("ScrollingFrame", PageContainer)
    Page.Size = UDim2.new(1,0,1,0)
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.BackgroundTransparency = 1

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

-- ID Card Frame
local Card = Instance.new("Frame", HomePage)
Card.Size = UDim2.new(0.9,0,0,150)
Card.Position = UDim2.new(0.05,0,0.05,0)
Card.BackgroundColor3 = Color3.fromRGB(35,35,50)
Card.BorderSizePixel = 0
Instance.new("UICorner", Card).CornerRadius = UDim.new(0,12)
Card.ClipsDescendants = true

-- 🌈 Rainbow Stroke
local Stroke = Instance.new("UIStroke", Card)
Stroke.Thickness = 3
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.Color = Color3.fromRGB(255,0,0) -- awal merah

-- 👤 Username
local User = Instance.new("TextLabel", Card)
User.Size = UDim2.new(1,0,0,30)
User.Position = UDim2.new(0,0,0,0)
User.Text = "👤 User: "..LP.Name
User.TextColor3 = Color3.fromRGB(255,255,255)
User.BackgroundTransparency = 1
User.Font = Enum.Font.GothamBold
User.TextSize = 16
User.TextXAlignment = Enum.TextXAlignment.Left

-- 🎮 Device Info
local DeviceLabel = Instance.new("TextLabel", Card)
DeviceLabel.Size = UDim2.new(1,0,0,25)
DeviceLabel.Position = UDim2.new(0,0,0.2,0)
DeviceLabel.Text = "📱 Device: "..UserInputService:GetPlatform().Name
DeviceLabel.TextColor3 = Color3.fromRGB(200,200,255)
DeviceLabel.BackgroundTransparency = 1
DeviceLabel.Font = Enum.Font.GothamBold
DeviceLabel.TextSize = 16
DeviceLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ⚡ FPS
local FPSLabel = Instance.new("TextLabel", Card)
FPSLabel.Size = UDim2.new(1,0,0,25)
FPSLabel.Position = UDim2.new(0,0,0.4,0)
FPSLabel.Text = "⚡ FPS: 0"
FPSLabel.TextColor3 = Color3.fromRGB(0,255,0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 16
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 📶 Ping
local PingLabel = Instance.new("TextLabel", Card)
PingLabel.Size = UDim2.new(1,0,0,25)
PingLabel.Position = UDim2.new(0,0,0.6,0)
PingLabel.Text = "📶 Ping: -- ms"
PingLabel.TextColor3 = Color3.fromRGB(200,200,255)
PingLabel.BackgroundTransparency = 1
PingLabel.Font = Enum.Font.GothamBold
PingLabel.TextSize = 16
PingLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 📡 Data Usage
local DataLabel = Instance.new("TextLabel", Card)
DataLabel.Size = UDim2.new(1,0,0,25)
DataLabel.Position = UDim2.new(0,0,0.8,0)
DataLabel.Text = "📡 Data Used: 0 MB"
DataLabel.TextColor3 = Color3.fromRGB(255,200,200)
DataLabel.BackgroundTransparency = 1
DataLabel.Font = Enum.Font.GothamBold
DataLabel.TextSize = 16
DataLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 📷 IG Developer
local IG = Instance.new("TextLabel", HomePage)
IG.Size = UDim2.new(1,0,0,25)
IG.Position = UDim2.new(0,0,0.95,0)
IG.Text = "📷 Follow: @frkhnsptra__"
IG.TextColor3 = Color3.fromRGB(255,255,255)
IG.BackgroundTransparency = 1
IG.Font = Enum.Font.GothamBold
IG.TextSize = 14
IG.TextXAlignment = Enum.TextXAlignment.Center

-- ⚙️ Logic Update FPS + Ping + Data Usage
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- FPS Update
local frames, lastTime = 0, tick()
RunService.RenderStepped:Connect(function()
    frames += 1
    local now = tick()
    if now - lastTime >= 1 then
        local fps = frames / (now - lastTime)
        frames = 0
        lastTime = now
        FPSLabel.Text = "⚡ FPS: "..math.floor(fps)
        if fps >= 50 then
            FPSLabel.TextColor3 = Color3.fromRGB(0,255,0)
        elseif fps >= 30 then
            FPSLabel.TextColor3 = Color3.fromRGB(255,255,0)
        else
            FPSLabel.TextColor3 = Color3.fromRGB(255,0,0)
        end
    end
end)

-- Ping Update
task.spawn(function()
    while task.wait(1) do
        local pingStat = Stats.Network.ServerStatsItem["Data Ping"]
        if pingStat then
            PingLabel.Text = "📶 Ping: "..math.floor(pingStat:GetValue()).." ms"
        end
    end
end)

-- Data Usage (simulasi)
local dataUsed = 0
task.spawn(function()
    while task.wait(2) do
        dataUsed += math.random(1,3) -- simulasi naik 1-3 MB
        DataLabel.Text = "📡 Data Used: "..dataUsed.." MB"
    end
end)

-- 🌈 Rainbow Border Animation
task.spawn(function()
    local hue = 0
    while task.wait(0.05) do
        hue = (hue + 2) % 360
        Stroke.Color = Color3.fromHSV(hue/360,1,1)
    end
end)
Pages["Home"].Visible = true
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