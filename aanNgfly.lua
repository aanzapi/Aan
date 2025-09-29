---------------- UI BASE (Abu Elegan + Rainbow Border) ----------------

-- Services
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProGUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,550,0,330)
MainFrame.Position = UDim2.new(0.25,0,0.25,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40) -- abu gelap
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,15)

-- Rainbow Stroke (pinggir pelangi berjalan)
local RainbowStroke = Instance.new("UIStroke", MainFrame)
RainbowStroke.Thickness = 3

local Grad = Instance.new("UIGradient", RainbowStroke)
Grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,0,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}
Grad.Rotation = 0

-- Animasi rainbow jalan
task.spawn(function()
    while task.wait(0.05) do
        Grad.Rotation = (Grad.Rotation + 1) % 360
    end
end)

-- Title Bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1,0,0,40)
TitleBar.BackgroundColor3 = Color3.fromRGB(60,60,60)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,15)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1,0,1,0)
Title.Text = "⚡ SUMMIT PRO GUI"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- Close Button (❌)
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0,40,0,40)
CloseBtn.Position = UDim2.new(1,-45,0,0)
CloseBtn.Text = "✖"
CloseBtn.TextColor3 = Color3.fromRGB(200,80,80)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20

-- Sidebar (Tab Menu)
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0,140,1,-40)
SideBar.Position = UDim2.new(0,0,0,40)
SideBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
SideBar.BorderSizePixel = 0
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0,10)

local UIList = Instance.new("UIListLayout", SideBar)
UIList.Padding = UDim.new(0,8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Page Container
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1,-140,1,-40)
PageContainer.Position = UDim2.new(0,140,0,40)
PageContainer.BackgroundColor3 = Color3.fromRGB(35,35,35)
PageContainer.BorderSizePixel = 0
Instance.new("UICorner", PageContainer).CornerRadius = UDim.new(0,10)

----------------------------------------------------------------
-- Fungsi Tab + Page
----------------------------------------------------------------
local Pages = {}
local function createTab(name, icon)
    local Btn = Instance.new("TextButton", SideBar)
    Btn.Size = UDim2.new(1,0,0,35)
    Btn.Text = (icon or "📌").." "..name
    Btn.TextColor3 = Color3.fromRGB(200,200,200)
    Btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 15
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

    local Page = Instance.new("ScrollingFrame", PageContainer)
    Page.Size = UDim2.new(1,0,1,0)
    Page.Visible = false
    Page.ScrollBarThickness = 6
    Page.BackgroundTransparency = 1

    Pages[name] = Page

    Btn.MouseButton1Click:Connect(function()
        for _,p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
        for _,b in pairs(SideBar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(70,70,70)
                b.TextColor3 = Color3.fromRGB(200,200,200)
            end
        end
        Btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        Btn.TextColor3 = Color3.fromRGB(255,255,255)
    end)

    return Page
end

----------------------------------------------------------------
-- Contoh Page
----------------------------------------------------------------
local Page1 = createTab("Home","🏠")
local Label1 = Instance.new("TextLabel", Page1)
Label1.Size = UDim2.new(1,0,0,30)
Label1.Text = "Welcome to Summit GUI"
Label1.TextColor3 = Color3.fromRGB(255,255,255)
Label1.Font = Enum.Font.GothamBold
Label1.TextSize = 18
Label1.BackgroundTransparency = 1

Pages["Home"].Visible = true

----------------------------------------------------------------
-- ✅ Toggle Button (Show/Hide GUI)
----------------------------------------------------------------
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0,50,0,50)
ToggleBtn.Position = UDim2.new(0,15,0.5,-25)
ToggleBtn.Text = "⚡"
ToggleBtn.TextSize = 24
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",ToggleBtn).CornerRadius = UDim.new(0,15)

local UIStroke = Instance.new("UIStroke", ToggleBtn)
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(150,150,150)

-- Logic show/hide
local guiVisible = true
local function toggleGUI(state)
    guiVisible = state
    MainFrame.Visible = guiVisible
    if guiVisible then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        UIStroke.Color = Color3.fromRGB(0,255,100)
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(80,30,30)
        UIStroke.Color = Color3.fromRGB(255,80,80)
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    toggleGUI(not guiVisible)
end)

-- ❌ Close hanya hide, bukan destroy
CloseBtn.MouseButton1Click:Connect(function()
    toggleGUI(false)
end)
