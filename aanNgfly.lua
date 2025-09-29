---------------- UI BASE (Mentahan) ----------------

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
MainFrame.Size = UDim2.new(0,500,0,300)
MainFrame.Position = UDim2.new(0.25,0,0.25,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)

-- Title Bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1,0,0,40)
TitleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1,0,1,0)
Title.Text = "🔥 PRO GUI BASE"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

-- Close Button
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0,40,0,40)
CloseBtn.Position = UDim2.new(1,-40,0,0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,100,100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sidebar (Tab Menu)
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0,120,1,-40)
SideBar.Position = UDim2.new(0,0,0,40)
SideBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
SideBar.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout", SideBar)
UIList.Padding = UDim.new(0,5)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Container untuk Pages
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1,-120,1,-40)
PageContainer.Position = UDim2.new(0,120,0,40)
PageContainer.BackgroundColor3 = Color3.fromRGB(45,45,45)
PageContainer.BorderSizePixel = 0
Instance.new("UICorner", PageContainer).CornerRadius = UDim.new(0,8)

----------------------------------------------------------------
-- 📝 Fungsi buat tambah Tab + Page
----------------------------------------------------------------
local Pages = {}
local function createTab(name)
    local Btn = Instance.new("TextButton", SideBar)
    Btn.Size = UDim2.new(1,0,0,30)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 16
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)

    local Page = Instance.new("ScrollingFrame", PageContainer)
    Page.Size = UDim2.new(1,0,1,0)
    Page.Visible = false
    Page.ScrollBarThickness = 6
    Page.BackgroundTransparency = 1

    Pages[name] = Page

    Btn.MouseButton1Click:Connect(function()
        for _,p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)

    return Page
end

----------------------------------------------------------------
-- 📌 Contoh Page
----------------------------------------------------------------
local Page1 = createTab("🏠 Home")
local Label1 = Instance.new("TextLabel", Page1)
Label1.Size = UDim2.new(1,0,0,30)
Label1.Text = "Selamat datang di GUI base!"
Label1.TextColor3 = Color3.fromRGB(255,255,255)
Label1.Font = Enum.Font.SourceSansBold
Label1.TextSize = 18
Label1.BackgroundTransparency = 1

local Page2 = createTab("⚙️ Settings")
local Label2 = Instance.new("TextLabel", Page2)
Label2.Size = UDim2.new(1,0,0,30)
Label2.Text = "Atur konfigurasi disini."
Label2.TextColor3 = Color3.fromRGB(255,255,255)
Label2.Font = Enum.Font.SourceSansBold
Label2.TextSize = 18
Label2.BackgroundTransparency = 1

-- Buka Page1 default
Pages["🏠 Home"].Visible = true
