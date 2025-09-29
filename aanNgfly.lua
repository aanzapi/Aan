---------------- UI BASE (Glowing Neon Style) ----------------

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
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,50)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,20)

-- Gradient background
local UIGradient = Instance.new("UIGradient", MainFrame)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40,0,70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,100))
}
UIGradient.Rotation = 45

-- Title Bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1,0,0,45)
TitleBar.BackgroundColor3 = Color3.fromRGB(30,100,200)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,20)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1,0,1,0)
Title.Text = "⚡ PRO SUMMIT GUI"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

-- Close Button
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0,40,0,40)
CloseBtn.Position = UDim2.new(1,-45,0,2)
CloseBtn.Text = "✖"
CloseBtn.TextColor3 = Color3.fromRGB(255,80,80)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sidebar (Tab Menu)
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0,140,1,-45)
SideBar.Position = UDim2.new(0,0,0,45)
SideBar.BackgroundColor3 = Color3.fromRGB(15,15,35)
SideBar.BorderSizePixel = 0
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0,15)

local UIList = Instance.new("UIListLayout", SideBar)
UIList.Padding = UDim.new(0,8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Container untuk Pages
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1,-140,1,-45)
PageContainer.Position = UDim2.new(0,140,0,45)
PageContainer.BackgroundColor3 = Color3.fromRGB(25,25,60)
PageContainer.BorderSizePixel = 0
Instance.new("UICorner", PageContainer).CornerRadius = UDim.new(0,15)

-- Gradient untuk Page Container
local PGrad = Instance.new("UIGradient", PageContainer)
PGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,0,60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,30,90))
}
PGrad.Rotation = 45

----------------------------------------------------------------
-- 📝 Fungsi buat tambah Tab + Page
----------------------------------------------------------------
local Pages = {}
local function createTab(name, icon)
    local Btn = Instance.new("TextButton", SideBar)
    Btn.Size = UDim2.new(1,0,0,35)
    Btn.Text = (icon or "📌").." "..name
    Btn.TextColor3 = Color3.fromRGB(200,200,200)
    Btn.BackgroundColor3 = Color3.fromRGB(40,40,70)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 15
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,10)

    local Page = Instance.new("ScrollingFrame", PageContainer)
    Page.Size = UDim2.new(1,0,1,0)
    Page.Visible = false
    Page.ScrollBarThickness = 6
    Page.BackgroundTransparency = 1

    Pages[name] = Page

    Btn.MouseButton1Click:Connect(function()
        for _,p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
        -- highlight
        for _,b in pairs(SideBar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(40,40,70)
                b.TextColor3 = Color3.fromRGB(200,200,200)
            end
        end
        Btn.BackgroundColor3 = Color3.fromRGB(70,20,120)
        Btn.TextColor3 = Color3.fromRGB(255,255,255)
    end)

    return Page
end

----------------------------------------------------------------
-- 📌 Contoh Page
----------------------------------------------------------------
local Page1 = createTab("Home","🏠")
local Label1 = Instance.new("TextLabel", Page1)
Label1.Size = UDim2.new(1,0,0,30)
Label1.Text = "Selamat datang di GUI Summit!"
Label1.TextColor3 = Color3.fromRGB(255,255,255)
Label1.Font = Enum.Font.GothamBold
Label1.TextSize = 18
Label1.BackgroundTransparency = 1

local Page2 = createTab("Settings","⚙️")
local Label2 = Instance.new("TextLabel", Page2)
Label2.Size = UDim2.new(1,0,0,30)
Label2.Text = "Atur konfigurasi disini."
Label2.TextColor3 = Color3.fromRGB(255,255,255)
Label2.Font = Enum.Font.GothamBold
Label2.TextSize = 18
Label2.BackgroundTransparency = 1

-- Buka Page1 default
Pages["Home"].Visible = true

----------------------------------------------------------------
-- ✅ Toggle Button (Show / Hide GUI dengan Glow)
----------------------------------------------------------------
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0,50,0,50)
ToggleBtn.Position = UDim2.new(0,15,0.5,-25)
ToggleBtn.Text = "⚡"
ToggleBtn.TextSize = 24
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40,150,60)
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner",ToggleBtn).CornerRadius = UDim.new(0,15)

-- Glow effect
local UIStroke = Instance.new("UIStroke", ToggleBtn)
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(0,255,100)

local guiVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    MainFrame.Visible = guiVisible
    if guiVisible then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40,150,60)
        UIStroke.Color = Color3.fromRGB(0,255,100)
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150,40,40)
        UIStroke.Color = Color3.fromRGB(255,60,60)
    end
end)
