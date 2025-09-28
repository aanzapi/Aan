-- // AanZAPI GUI with Tab Menu + Hover Effect + Fade In/Out

local TweenService = game:GetService("TweenService")

-- ScreenGui & Main Frame
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Mulai Transparan
MainFrame.BackgroundTransparency = 1

-- Fade Function
local function fade(obj, dur, mode, onFinish)
    for _,v in pairs(obj:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            if mode == "in" then v.TextTransparency = 1 else v.TextTransparency = 0 end
        elseif v:IsA("Frame") then
            if mode == "in" then v.BackgroundTransparency = 1 else v.BackgroundTransparency = 0 end
        end
    end

    task.wait(0.05)

    for _,v in pairs(obj:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            TweenService:Create(v, TweenInfo.new(dur), {
                TextTransparency = (mode == "in") and 0 or 1
            }):Play()
        elseif v:IsA("Frame") then
            TweenService:Create(v, TweenInfo.new(dur), {
                BackgroundTransparency = (mode == "in") and 0 or 1
            }):Play()
        end
    end

    TweenService:Create(obj, TweenInfo.new(dur), {
        BackgroundTransparency = (mode == "in") and 0 or 1
    }):Play()

    if onFinish then
        task.delay(dur, onFinish)
    end
end

-- Stroke
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 1
stroke.Transparency = 0.8

-- Title Bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30,30,40)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,8)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "🚀 AanZAPI GUI"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-35,0,0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,100,100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.MouseButton1Click:Connect(function()
    fade(MainFrame, 0.6, "out", function()
        ScreenGui:Destroy()
    end)
end)

-- Tab Bar
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1,0,0,30)
TabBar.Position = UDim2.new(0,0,0,30)
TabBar.BackgroundColor3 = Color3.fromRGB(25,25,35)
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0,6)

-- Button Styling Function
local function StyleButton(btn)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Thickness = 1
    stroke.Transparency = 0.8

    -- Hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70,70,90)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,60)}):Play()
    end)
end

-- Create Tab Button
local function makeTabBtn(txt, pos)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0.5,0,1,0)
    btn.Position = UDim2.new(pos,0,0,0)
    btn.Text = txt
    StyleButton(btn)
    return btn
end

local Tab1Btn = makeTabBtn("✈️ Fly / Teleport", 0)
local Tab2Btn = makeTabBtn("💾 Checkpoint", 0.5)

-- Pages
local Page1 = Instance.new("Frame", MainFrame)
Page1.Size = UDim2.new(1,0,1,-60)
Page1.Position = UDim2.new(0,0,0,60)
Page1.BackgroundTransparency = 1

local Page2 = Instance.new("Frame", MainFrame)
Page2.Size = UDim2.new(1,0,1,-60)
Page2.Position = UDim2.new(0,0,0,60)
Page2.BackgroundTransparency = 1
Page2.Visible = false

-- Switch Tab Function
local function switchPage(pg)
    if pg == 1 then
        Page1.Visible = true
        Page2.Visible = false
        Tab1Btn.BackgroundColor3 = Color3.fromRGB(70,70,90)
        Tab2Btn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    else
        Page1.Visible = false
        Page2.Visible = true
        Tab1Btn.BackgroundColor3 = Color3.fromRGB(50,50,60)
        Tab2Btn.BackgroundColor3 = Color3.fromRGB(70,70,90)
    end
end

Tab1Btn.MouseButton1Click:Connect(function() switchPage(1) end)
Tab2Btn.MouseButton1Click:Connect(function() switchPage(2) end)

-- ========= PAGE 1 =========
local FlyBtn = Instance.new("TextButton", Page1)
FlyBtn.Size = UDim2.new(1,-20,0,30)
FlyBtn.Position = UDim2.new(0,10,0,10)
FlyBtn.Text = "✈️ Toggle Fly"
StyleButton(FlyBtn)

local TeleportBtn = Instance.new("TextButton", Page1)
TeleportBtn.Size = UDim2.new(1,-20,0,30)
TeleportBtn.Position = UDim2.new(0,10,0,50)
TeleportBtn.Text = "🌀 Teleport to Player"
StyleButton(TeleportBtn)

-- ========= PAGE 2 =========
local SaveBtn = Instance.new("TextButton", Page2)
SaveBtn.Size = UDim2.new(1,-20,0,30)
SaveBtn.Position = UDim2.new(0,10,0,10)
SaveBtn.Text = "💾 Save Checkpoint"
StyleButton(SaveBtn)

local LoadBtn = Instance.new("TextButton", Page2)
LoadBtn.Size = UDim2.new(1,-20,0,30)
LoadBtn.Position = UDim2.new(0,10,0,50)
LoadBtn.Text = "📍 Load Checkpoint"
StyleButton(LoadBtn)

-- Jalankan Fade-in
fade(MainFrame, 0.8, "in")
