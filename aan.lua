--[[
    Script ini membuat basis GUI (Graphical User Interface) di Roblox
    berdasarkan desain yang diberikan.

    Cara Menggunakan:
    1. Buka Roblox Studio.
    2. Buat sebuah 'LocalScript' di dalam 'StarterPlayer' -> 'StarterPlayerScripts'.
    3. Salin dan tempel semua kode ini ke dalam 'LocalScript' tersebut.
    4. Jalankan game untuk melihat hasilnya.
]]

-- Menunggu layanan PlayerGui
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Hapus GUI lama jika ada untuk menghindari duplikasi saat reset
if PlayerGui:FindFirstChild("MainUI") then
    PlayerGui.MainUI:Destroy()
end

-- Wadah utama untuk semua elemen UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainUI"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false -- Agar GUI tidak hilang saat karakter mati

-- Frame utama window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 650, 0, 400)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0

-- Membuat sudut frame menjadi tumpul
local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 8)
mainFrameCorner.Parent = mainFrame

-- Title Bar (Bagian atas window)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
titleBar.BorderSizePixel = 0

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 8)
titleBarCorner.Parent = titleBar

-- Judul
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
titleLabel.Position = UDim2.new(0.02, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.Text = "Waivy Community - Fish It"
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Close
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.Size = UDim2.new(0, 40, 1, 0)
closeButton.Position = UDim2.new(1, 0, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
closeButton.BorderSizePixel = 0
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(220, 220, 220)
closeButton.TextSize = 18

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 8)
closeButtonCorner.Parent = closeButton

-- Aksi untuk tombol close
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Kontainer untuk konten utama (sidebar dan panel kanan)
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Parent = mainFrame
contentContainer.Size = UDim2.new(1, 0, 1, -40)
contentContainer.Position = UDim2.new(0, 0, 0, 40)
contentContainer.BackgroundTransparency = 1

-- Sidebar Navigasi (kiri)
local sidebar = Instance.new("ScrollingFrame")
sidebar.Name = "Sidebar"
sidebar.Parent = contentContainer
sidebar.Size = UDim2.new(0, 150, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
sidebar.BorderSizePixel = 0
sidebar.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
sidebar.ScrollBarThickness = 5

-- Layout untuk menata tombol di sidebar secara otomatis
local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Parent = sidebar
sidebarLayout.Padding = UDim.new(0, 5)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Fungsi untuk membuat tombol navigasi di sidebar
local function createNavButton(text)
    local navButton = Instance.new("TextButton")
    navButton.Name = text
    navButton.Parent = sidebar
    navButton.Size = UDim2.new(1, -10, 0, 35)
    navButton.Position = UDim2.new(0, 5, 0, 0)
    navButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    navButton.BorderSizePixel = 0
    navButton.AutoButtonColor = false
    
    navButton.Font = Enum.Font.Gotham
    navButton.Text = "  " .. text
    navButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    navButton.TextSize = 14
    navButton.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = navButton

    -- Efek hover
    navButton.MouseEnter:Connect(function()
        navButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    end)
    navButton.MouseLeave:Connect(function()
        navButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    end)
    
    return navButton
end

-- Membuat tombol-tombol di sidebar
local autoFarmBtn = createNavButton("Auto Farm")
autoFarmBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 200) -- Tombol aktif
createNavButton("Teleport")
createNavButton("Shop")
createNavButton("User")
createNavButton("Utility")
createNavButton("Webhook")
createNavButton("Settings")


-- Panel Konten (kanan)
local contentPanel = Instance.new("ScrollingFrame")
contentPanel.Name = "ContentPanel"
contentPanel.Parent = contentContainer
contentPanel.Size = UDim2.new(1, -160, 1, -10)
contentPanel.Position = UDim2.new(0, 155, 0, 5)
contentPanel.BackgroundTransparency = 1
contentPanel.BorderSizePixel = 0
contentPanel.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
contentPanel.ScrollBarThickness = 5

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = contentPanel
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Judul di dalam panel konten
local contentTitle = Instance.new("TextLabel")
contentTitle.Name = "ContentTitle"
contentTitle.Parent = contentPanel
contentTitle.Size = UDim2.new(1, 0, 0, 30)
contentTitle.BackgroundTransparency = 1
contentTitle.Font = Enum.Font.GothamBold
contentTitle.Text = "Auto Farm"
contentTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
contentTitle.TextSize = 20
contentTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Fungsi untuk membuat opsi dengan toggle
local function createOption(title, description)
    local optionFrame = Instance.new("Frame")
    optionFrame.Name = title
    optionFrame.Parent = contentPanel
    optionFrame.Size = UDim2.new(1, 0, 0, 70)
    optionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    optionFrame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = optionFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = optionFrame
    titleLabel.Size = UDim2.new(0.7, 0, 0, 30)
    titleLabel.Position = UDim2.new(0.05, 0, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = optionFrame
    descLabel.Size = UDim2.new(0.7, 0, 0, 20)
    descLabel.Position = UDim2.new(0.05, 0, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    descLabel.TextSize = 12
    descLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Membuat Toggle Switch palsu
    local toggleBg = Instance.new("Frame")
    toggleBg.Parent = optionFrame
    toggleBg.AnchorPoint = Vector2.new(1, 0.5)
    toggleBg.Position = UDim2.new(0.95, 0, 0.5, 0)
    toggleBg.Size = UDim2.new(0, 50, 0, 26)
    toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    
    local toggleBgCorner = Instance.new("UICorner")
    toggleBgCorner.CornerRadius = UDim.new(1, 0)
    toggleBgCorner.Parent = toggleBg

    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = toggleBg
    toggleButton.AnchorPoint = Vector2.new(0, 0.5)
    toggleButton.Position = UDim2.new(0, 3, 0.5, 0)
    toggleButton.Size = UDim2.new(0, 20, 0, 20)
    toggleButton.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0

    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(1, 0)
    toggleButtonCorner.Parent = toggleButton
    
    local isToggled = false
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            toggleButton:TweenPosition(UDim2.new(1, -23, 0.5, 0), "Out", "Quad", 0.2, true)
            toggleBg.BackgroundColor3 = Color3.fromRGB(80, 60, 200)
        else
            toggleButton:TweenPosition(UDim2.new(0, 3, 0.5, 0), "Out", "Quad", 0.2, true)
            toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        end
    end)
    
    return optionFrame
end

-- Membuat contoh opsi di panel konten
createOption("Auto Fishing V1", "Automatically fish with animations & instant catch")
createOption("Auto Fishing V2 (No Anim)", "Automatically fish without any animation")
createOption("Auto Sell", "Please be careful when using auto sell")


-- Fungsionalitas untuk membuat window bisa digerakkan
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.Y < titleBar.AbsolutePosition.Y + titleBar.AbsoluteSize.Y then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end)
