-- Services
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AanGUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0,40,0,40)
ToggleBtn.Position = UDim2.new(0,10,0.5,-20)
ToggleBtn.Text = "✅"
ToggleBtn.TextSize = 22
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner",ToggleBtn).CornerRadius = UDim.new(0,10)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 400)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Toggle logic
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Title Bar (Neon Glow + Gradient + Blink)
local TweenService = game:GetService("TweenService")

-- Main Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🚀 AanZAPI GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.Parent = MainFrame

-- Glow effect (clone behind Title)
local Glow = Title:Clone()
Glow.TextColor3 = Color3.fromRGB(0, 255, 200) -- Neon cyan
Glow.TextTransparency = 0.6
Glow.ZIndex = Title.ZIndex - 1 -- Supaya di belakang
Glow.Parent = MainFrame

-- Gradient untuk teks utama
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 200)), 
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)), 
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 200))
}
gradient.Rotation = 0
gradient.Parent = Title

-- Animasi Glow (nyala-mati + gradient jalan)
task.spawn(function()
    while true do
        -- Gerak gradient
        TweenService:Create(gradient, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(1, 0)
        }):Play()

        -- Nyala
        TweenService:Create(Title, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextTransparency = 0
        }):Play()
        TweenService:Create(Glow, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextTransparency = 0.3
        }):Play()
        task.wait(1.2)

        -- Meredup
        TweenService:Create(Title, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextTransparency = 0.4
        }):Play()
        TweenService:Create(Glow, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextTransparency = 0.8
        }):Play()
        task.wait(0.8)
    end
end)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- PAGE SYSTEM
local currentPage = 1
local Page1 = Instance.new("Frame", MainFrame)
Page1.Size = UDim2.new(1,0,1,-30)
Page1.Position = UDim2.new(0,0,0,30)
Page1.BackgroundTransparency = 1

local Page2 = Instance.new("Frame", MainFrame)
Page2.Size = UDim2.new(1,0,1,-30)
Page2.Position = UDim2.new(0,0,0,30)
Page2.BackgroundTransparency = 1
Page2.Visible = false

-- Next Button
local NextBtn = Instance.new("TextButton")
NextBtn.Size = UDim2.new(0, 70, 0, 30)
NextBtn.Position = UDim2.new(1, -80, 1, -40) -- 🔽 dipindah ke bawah kanan
NextBtn.Text = "➡️"
NextBtn.TextColor3 = Color3.fromRGB(255,255,255)
NextBtn.Font = Enum.Font.GothamBold
NextBtn.TextSize = 16
NextBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
NextBtn.Parent = MainFrame
Instance.new("UICorner", NextBtn).CornerRadius = UDim.new(0,8)

-- Back Button
local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 70, 0, 30)
BackBtn.Position = UDim2.new(0, 10, 1, -40) -- 🔽 dipindah ke bawah kiri
BackBtn.Text = "⬅️"
BackBtn.TextColor3 = Color3.fromRGB(255,255,255)
BackBtn.Font = Enum.Font.GothamBold
BackBtn.TextSize = 16
BackBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
BackBtn.Parent = MainFrame
BackBtn.Visible = false
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0,8)

-- Switch Page Function
local function switchPage(pg)
    Page1.Visible = (pg == 1)
    Page2.Visible = (pg == 2)
    BackBtn.Visible = (pg == 2)
    NextBtn.Visible = (pg == 1)
    currentPage = pg
end
NextBtn.MouseButton1Click:Connect(function() switchPage(2) end)
BackBtn.MouseButton1Click:Connect(function() switchPage(1) end)

---------------- PAGE 1 (Fly + Teleport Player) ----------------
-- Fly Button
local FlyBtn = Instance.new("TextButton", Page1)
FlyBtn.Size = UDim2.new(0.9, 0, 0, 40)
FlyBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
FlyBtn.Text = "✈️ Fly: OFF"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FlyBtn.Font = Enum.Font.SourceSansBold
FlyBtn.TextSize = 18
Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(0, 6)

-- Tombol Naik & Turun
local UpBtn = Instance.new("TextButton", Page1)
UpBtn.Size = UDim2.new(0.43, 0, 0, 35)
UpBtn.Position = UDim2.new(0.05, 0, 0.18, 0)
UpBtn.Text = "⬆️ Naik"
UpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
UpBtn.Font = Enum.Font.SourceSansBold
UpBtn.TextSize = 16
Instance.new("UICorner", UpBtn).CornerRadius = UDim.new(0, 6)

local DownBtn = Instance.new("TextButton", Page1)
DownBtn.Size = UDim2.new(0.43, 0, 0, 35)
DownBtn.Position = UDim2.new(0.52, 0, 0.18, 0)
DownBtn.Text = "⬇️ Turun"
DownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DownBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
DownBtn.Font = Enum.Font.SourceSansBold
DownBtn.TextSize = 16
Instance.new("UICorner", DownBtn).CornerRadius = UDim.new(0, 6)

-- Atur Speed
local SpeedLabel = Instance.new("TextLabel", Page1)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "⚡ Speed: 60"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextSize = 16

local PlusBtn = Instance.new("TextButton", Page1)
PlusBtn.Size = UDim2.new(0.43, 0, 0, 30)
PlusBtn.Position = UDim2.new(0.05, 0, 0.36, 0)
PlusBtn.Text = "+ Speed"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
PlusBtn.Font = Enum.Font.SourceSansBold
PlusBtn.TextSize = 14
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 6)

local MinusBtn = Instance.new("TextButton", Page1)
MinusBtn.Size = UDim2.new(0.43, 0, 0, 30)
MinusBtn.Position = UDim2.new(0.52, 0, 0.36, 0)
MinusBtn.Text = "- Speed"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MinusBtn.Font = Enum.Font.SourceSansBold
MinusBtn.TextSize = 14
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 6)

-- === Dropdown Teleport Player ===
local DropDown = Instance.new("TextButton", Page1)
DropDown.Size = UDim2.new(0.9, 0, 0, 40)
DropDown.Position = UDim2.new(0.05, 0, 0.48, 0)
DropDown.Text = "👤 Teleport Menu"
DropDown.TextColor3 = Color3.fromRGB(255, 255, 255)
DropDown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DropDown.Font = Enum.Font.SourceSansBold
DropDown.TextSize = 18
Instance.new("UICorner", DropDown).CornerRadius = UDim.new(0, 6)

-- Container list
local ListFrame = Instance.new("ScrollingFrame", Page1)
ListFrame.Size = UDim2.new(0.9, 0, 0, 140)
ListFrame.Position = UDim2.new(0.05, 0, 0.65, 0)
ListFrame.CanvasSize = UDim2.new(0,0,0,0)
ListFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
ListFrame.ScrollBarThickness = 4
ListFrame.Visible = false
Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 6)

-- Tombol Refresh Player
local RefreshBtn = Instance.new("TextButton", Page1)
RefreshBtn.Size = UDim2.new(0.9, 0, 0, 30)
RefreshBtn.Position = UDim2.new(0.05, 0, 0.60, 0)
RefreshBtn.Text = "🔄 Refresh Player List"
RefreshBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 16
RefreshBtn.Visible = false
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 6)


---------------- PAGE 2 (Checkpoint System) ----------------
-- BUTTON SAVE
local SaveBtn = Instance.new("TextButton", Page2)
SaveBtn.Size = UDim2.new(0.9,0,0,40)
SaveBtn.Position = UDim2.new(0.05,0,0.05,0)
SaveBtn.Text = "💾 Save Checkpoint"
SaveBtn.TextColor3 = Color3.fromRGB(255,255,255)
SaveBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
SaveBtn.Font = Enum.Font.SourceSansBold
SaveBtn.TextSize = 18
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0,6)

-- BUTTON AUTO TELE
local AutoTeleBtn = Instance.new("TextButton", Page2)
AutoTeleBtn.Size = UDim2.new(0.9,0,0,40)
AutoTeleBtn.Position = UDim2.new(0.05,0,0.17,0)
AutoTeleBtn.Text = "🔁 Auto Tele: OFF"
AutoTeleBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoTeleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
AutoTeleBtn.Font = Enum.Font.SourceSansBold
AutoTeleBtn.TextSize = 18
Instance.new("UICorner", AutoTeleBtn).CornerRadius = UDim.new(0,6)

-- LIST CHECKPOINT
local CPList = Instance.new("ScrollingFrame", Page2)
CPList.Size = UDim2.new(0.9,0,0,200)
CPList.Position = UDim2.new(0.05,0,0.35,0)
CPList.CanvasSize = UDim2.new(0,0,0,0)
CPList.BackgroundColor3 = Color3.fromRGB(30,30,30)
CPList.ScrollBarThickness = 4
Instance.new("UICorner", CPList).CornerRadius = UDim.new(0,6)

-- SYSTEM VARIABLES
local checkpoints = {}
local autoTele = false

-- REFRESH LIST
local function refreshCPList()
    for _,c in pairs(CPList:GetChildren()) do
        if not c:IsA("UIListLayout") then
            c:Destroy()
        end
    end

    local y = 0
    for i,pos in ipairs(checkpoints) do
        -- Frame container
        local ItemFrame = Instance.new("Frame", CPList)
        ItemFrame.Size = UDim2.new(1,-5,0,30)
        ItemFrame.Position = UDim2.new(0,0,0,y)
        ItemFrame.BackgroundTransparency = 1

        -- Tombol teleport
        local TeleBtn = Instance.new("TextButton", ItemFrame)
        TeleBtn.Size = UDim2.new(0.7,-5,1,0)
        TeleBtn.Position = UDim2.new(0,0,0,0)
        TeleBtn.Text = "Checkpoint "..i
        TeleBtn.TextColor3 = Color3.fromRGB(255,255,255)
        TeleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        Instance.new("UICorner", TeleBtn).CornerRadius = UDim.new(0,6)

        TeleBtn.MouseButton1Click:Connect(function()
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = pos
            end
        end)

        -- Tombol delete
        local DelBtn = Instance.new("TextButton", ItemFrame)
        DelBtn.Size = UDim2.new(0.3,0,1,0)
        DelBtn.Position = UDim2.new(0.7,5,0,0)
        DelBtn.Text = "🗑️"
        DelBtn.TextColor3 = Color3.fromRGB(255,100,100)
        DelBtn.BackgroundColor3 = Color3.fromRGB(80,30,30)
        Instance.new("UICorner", DelBtn).CornerRadius = UDim.new(0,6)

        DelBtn.MouseButton1Click:Connect(function()
            table.remove(checkpoints, i)
            refreshCPList()
        end)

        y = y + 35
    end

    CPList.CanvasSize = UDim2.new(0,0,0,y)
end

-- SAVE CHECKPOINT + COPY KODE
SaveBtn.MouseButton1Click:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LP.Character.HumanoidRootPart.CFrame
        table.insert(checkpoints, pos)
        refreshCPList()

        -- Copy ke clipboard
        local code = ("CFrame.new(%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f)"):format(
            pos:GetComponents()
        )
        setclipboard(code) -- Roblox API buat copy text ke clipboard
    end
end)

-- AUTO TELEPORT
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
                    task.wait(2) -- ⏳ waktu jeda antar teleport
                end
            end
        end)
    end
end)

-- === Fly System (Page1) ===
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
-- === Teleport Player List ===
local function refreshPlayers()
    for _,child in pairs(ListFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end

    local y = 0
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            -- Frame container biar ga kaku
            local ItemFrame = Instance.new("Frame", ListFrame)
            ItemFrame.Size = UDim2.new(1,-5,0,35)
            ItemFrame.Position = UDim2.new(0,0,0,y)
            ItemFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
            Instance.new("UICorner", ItemFrame).CornerRadius = UDim.new(0,6)

            -- Label nama player
            local NameLabel = Instance.new("TextLabel", ItemFrame)
            NameLabel.Size = UDim2.new(0.7,0,1,0)
            NameLabel.Position = UDim2.new(0,10,0,0)
            NameLabel.Text = "🎮 "..plr.Name
            NameLabel.TextColor3 = Color3.fromRGB(255,255,255)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Font = Enum.Font.SourceSansBold
            NameLabel.TextSize = 16
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left

            -- Tombol teleport
            local TeleBtn = Instance.new("TextButton", ItemFrame)
            TeleBtn.Size = UDim2.new(0.25,0,0.8,0)
            TeleBtn.Position = UDim2.new(0.72,0,0.1,0)
            TeleBtn.Text = "Teleport"
            TeleBtn.TextColor3 = Color3.fromRGB(255,255,255)
            TeleBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
            TeleBtn.Font = Enum.Font.SourceSans
            TeleBtn.TextSize = 14
            Instance.new("UICorner", TeleBtn).CornerRadius = UDim.new(0,6)

            TeleBtn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character:WaitForChild("HumanoidRootPart").CFrame =
                        plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                end
            end)

            y = y + 40
        end
    end

    ListFrame.CanvasSize = UDim2.new(0,0,0,y)
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
