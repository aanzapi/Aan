-- Script UI dengan Tab - Dibuat oleh Grok (xAI)
-- Pastikan ini adalah LocalScript di StarterGui

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Buat ScreenGui utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomUITabs"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame utama (background UI)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.8, 0, 0.7, 0)  -- 80% lebar, 70% tinggi layar
mainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)  -- Posisi di tengah
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  -- Abu-abu gelap
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Tambahkan shadow untuk tampilan bagus
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- Frame untuk tab buttons (di atas)
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0.1, 0)  -- 10% tinggi dari mainFrame
tabFrame.Position = UDim2.new(0, 0, 0, 0)
tabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

-- Frame untuk konten tab (di bawah)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 0.9, 0)  -- 90% sisanya
contentFrame.Position = UDim2.new(0, 0, 0.1, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Fungsi untuk membuat tab button
local function createTabButton(name, position, tabIndex)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.2, 0, 1, 0)  -- 20% lebar tabFrame
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.BorderSizePixel = 0
    button.Parent = tabFrame
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    
    -- Klik untuk switch tab
    button.MouseButton1Click:Connect(function()
        switchToTab(tabIndex)
    end)
    
    return button
end

-- Fungsi untuk membuat konten tab
local function createTabContent(tabIndex)
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 10
    content.CanvasSize = UDim2.new(0, 0, 2, 0)  -- Scrollable
    content.Parent = contentFrame
    
    -- Contoh konten: Label dan Button
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.2, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Konten Tab " .. tabIndex
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 24
    label.Parent = content
    
    local exampleButton = Instance.new("TextButton")
    exampleButton.Size = UDim2.new(0.5, 0, 0.1, 0)
    exampleButton.Position = UDim2.new(0.25, 0, 0.3, 0)
    exampleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    exampleButton.Text = "Klik Saya!"
    exampleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    exampleButton.Font = Enum.Font.SourceSansBold
    exampleButton.TextSize = 16
    exampleButton.Parent = content
    
    exampleButton.MouseButton1Click:Connect(function()
        print("Tombol di Tab " .. tabIndex .. " diklik!")
    end)
    
    return content
end

-- Array untuk menyimpan tab contents
local tabContents = {}

-- Fungsi untuk switch tab
local currentTab = 1
local function switchToTab(tabIndex)
    for i, content in ipairs(tabContents) do
        content.Visible = (i == tabIndex)
    end
    currentTab = tabIndex
end

-- Buat 5 tab buttons
createTabButton("Tab 1", UDim2.new(0, 0, 0, 0), 1)
createTabButton("Tab 2", UDim2.new(0.2, 0, 0, 0), 2)
createTabButton("Tab 3", UDim2.new(0.4, 0, 0, 0), 3)
createTabButton("Tab 4", UDim2.new(0.6, 0, 0, 0), 4)
createTabButton("Tab 5", UDim2.new(0.8, 0, 0, 0), 5)

-- Buat konten untuk setiap tab
for i = 1, 5 do
    tabContents[i] = createTabContent(i)
end

-- Set tab pertama sebagai default
switchToTab(1)

-- Tambahkan close button di kanan atas
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.05, 0, 0.05, 0)
closeButton.Position = UDim2.new(0.95, 0, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 14
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()  -- Tutup UI
end)
