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
Title.Text = "🏔️ SUMMIT PRO PANEL"
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

-- Default Page
local HomePage = createTab("Home","🏠")
local Welcome = Instance.new("TextLabel", HomePage)
Welcome.Size = UDim2.new(1,0,0,30)
Welcome.Text = "Selamat datang di Panel Summit!"
Welcome.TextColor3 = Color3.fromRGB(255,255,255)
Welcome.Font = Enum.Font.GothamBold
Welcome.TextSize = 16
Welcome.BackgroundTransparency = 1
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
