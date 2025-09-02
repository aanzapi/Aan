--// Advanced Mobile GUI Script by AanZAPI
-- Bisa dipindah-pindah (draggable)

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "🔥 AanZAPI Super GUI 🔥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Tombol Close
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Parent = MainFrame
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Layout
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = MainFrame

-- WalkSpeed Slider
local WalkLabel = Instance.new("TextLabel")
WalkLabel.Size = UDim2.new(1, -10, 0, 20)
WalkLabel.Text = "WalkSpeed"
WalkLabel.TextColor3 = Color3.fromRGB(255,255,255)
WalkLabel.BackgroundTransparency = 1
WalkLabel.Parent = MainFrame

local WalkBox = Instance.new("TextBox")
WalkBox.Size = UDim2.new(1, -10, 0, 25)
WalkBox.Text = "16"
WalkBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
WalkBox.TextColor3 = Color3.fromRGB(255,255,255)
WalkBox.Parent = MainFrame

WalkBox.FocusLost:Connect(function()
    local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = tonumber(WalkBox.Text) or 16
    end
end)

-- JumpPower Slider
local JumpLabel = WalkLabel:Clone()
JumpLabel.Text = "JumpPower"
JumpLabel.Parent = MainFrame

local JumpBox = WalkBox:Clone()
JumpBox.Text = "50"
JumpBox.Parent = MainFrame

JumpBox.FocusLost:Connect(function()
    local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = tonumber(JumpBox.Text) or 50
    end
end)

-- Fly Toggle
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(1, -10, 0, 30)
FlyBtn.Text = "✈️ Fly (OFF)"
FlyBtn.BackgroundColor3 = Color3.fromRGB(50,100,200)
FlyBtn.TextColor3 = Color3.fromRGB(255,255,255)
FlyBtn.Parent = MainFrame

local flying = false
local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    FlyBtn.Text = flying and "✈️ Fly (ON)" or "✈️ Fly (OFF)"
    if flying then
        task.spawn(function()
            while flying do
                hrp.Velocity = Vector3.new(0,50,0)
                task.wait()
            end
        end)
    end
end)

-- NoClip Toggle
local NoClipBtn = FlyBtn:Clone()
NoClipBtn.Text = "🚪 NoClip (OFF)"
NoClipBtn.Parent = MainFrame

local noclip = false
NoClipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoClipBtn.Text = noclip and "🚪 NoClip (ON)" or "🚪 NoClip (OFF)"
    task.spawn(function()
        while noclip do
            for _,v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
            task.wait()
        end
    end)
end)

-- ESP Toggle
local ESPBtn = FlyBtn:Clone()
ESPBtn.Text = "👁️ ESP (OFF)"
ESPBtn.Parent = MainFrame

local esp = false
ESPBtn.MouseButton1Click:Connect(function()
    esp = not esp
    ESPBtn.Text = esp and "👁️ ESP (ON)" or "👁️ ESP (OFF)"
    if esp then
        for _,plr in pairs(game.Players:GetPlayers()) do
            if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Head") then
                local Billboard = Instance.new("BillboardGui", plr.Character.Head)
                Billboard.Size = UDim2.new(0,100,0,20)
                Billboard.Adornee = plr.Character.Head
                Billboard.AlwaysOnTop = true
                local Name = Instance.new("TextLabel", Billboard)
                Name.Size = UDim2.new(1,0,1,0)
                Name.Text = plr.Name
                Name.TextColor3 = Color3.fromRGB(255,0,0)
                Name.BackgroundTransparency = 1
            end
        end
    else
        for _,plr in pairs(game.Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                for _,gui in pairs(head:GetChildren()) do
                    if gui:IsA("BillboardGui") then gui:Destroy() end
                end
            end
        end
    end
end)
