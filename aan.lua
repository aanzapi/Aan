--[[
    ================================================================
    CUSTOM UI SCRIPT V2.0: MODERN DARK MODE (10x UPGRADE)
    ================================================================
    
    Fitur Utama:
    1.  Desain Modern Dark Mode dengan sudut melengkung.
    2.  Pembagian fitur menggunakan TabSystem sederhana.
    3.  Animasi hover pada tombol.
    4.  Logika Toggle & Button yang bersih.
    
    CATATAN: Di Roblox Studio, CoreGui dan fitur Blur tidak selalu
             berfungsi sama seperti di executor. Hasil terbaik
             akan terlihat saat dieksekusi.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ====================================================================
-- 1. SETUP DASAR GUI
-- ====================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomModernUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.4, 0, 0.6, 0) -- Ukuran lebih besar
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24) -- Background lebih gelap
MainFrame.BorderSizePixel = 0
MainFrame.Active = true -- Diperlukan untuk dragging
MainFrame.ZIndex = 100 -- Pastikan selalu di atas
MainFrame.Parent = ScreenGui

-- Efek Sudut Melengkung (Rounded Corners)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- ====================================================================
-- 2. TITLE BAR & CLOSE BUTTON
-- ====================================================================

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0.08, 0) -- Lebih tipis
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Warna Title Bar
TitleBar.BorderSizePixel = 0
TitleBar.Active = true
TitleBar.Draggable = true -- Aktifkan Draggable
TitleBar.Parent = MainFrame

-- Label Judul
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.9, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Text = "CUSTOM MODERN UI | V2.0"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.Parent = TitleBar

-- Tombol Tutup (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0.08, 0, 1, 0)
CloseButton.Position = UDim2.new(0.92, 0, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Merah
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

-- Logika Tombol Tutup
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ====================================================================
-- 3. CONTAINER DAN TAB SYSTEM
-- ====================================================================

local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0.2, 0, 0.92, 0) -- 20% Lebar untuk Tab
TabBar.Position = UDim2.new(0, 0, 0.08, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Warna Tab Bar
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0.8, 0, 0.92, 0) -- 80% Lebar untuk Konten
ContentFrame.Position = UDim2.new(0.2, 0, 0.08, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Layout untuk Tab Bar
local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Tabs = {}
local CurrentTab = nil

-- Fungsi untuk membuat Tab
local function CreateTab(name, order)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Button"
    tabButton.Text = name
    tabButton.Size = UDim2.new(1, 0, 0, 40) -- Tinggi 40px
    tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabButton.TextColor3 = Color3.fromRGB(150, 150, 150) -- Teks abu-abu
    tabButton.Font = Enum.Font.SourceSansBold
    tabButton.TextSize = 14
    tabButton.LayoutOrder = order
    tabButton.Parent = TabBar

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Position = UDim2.new(0, 0, 0, 0)
    tabContent.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 6
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0) -- Disesuaikan nanti
    tabContent.Visible = false
    tabContent.Parent = ContentFrame
    
    -- Layout untuk konten tab
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Name = "ListLayout"
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = tabContent
    
    -- Tambahkan Padding (Penyangga)
    Instance.new("UIPadding", tabContent).Padding = UDim.new(0, 10)
    
    Tabs[name] = {Button = tabButton, Content = tabContent, Layout = ContentLayout}
    
    -- Logika Klik Tab
    tabButton.MouseButton1Click:Connect(function()
        if CurrentTab then
            -- Nonaktifkan Tab sebelumnya
            Tabs[CurrentTab].Content.Visible = false
            Tabs[CurrentTab].Button.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        
        -- Aktifkan Tab baru
        CurrentTab = name
        tabContent.Visible = true
        tabButton.TextColor3 = Color3.fromRGB(0, 191, 255) -- Warna biru cerah
    end)
    
    return tabContent
end

-- ====================================================================
-- 4. FUNGSIONALITAS KOMPONEN (BUTTON, TOGGLE)
-- ====================================================================

-- Fungsi untuk membuat Button (dengan efek Hover)
local function CreateButton(tabContent, name, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = name
    button.Size = UDim2.new(1, 0, 0, 30) -- Lebar 100%, Tinggi 30px
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.Parent = tabContent
    
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)

    -- Animasi Hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)

    -- Logika Klik
    button.MouseButton1Click:Connect(callback)
    
    -- Sesuaikan CanvasSize (penting untuk ScrollingFrame)
    local listLayout = tabContent:FindFirstChild("ListLayout")
    if listLayout then
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end)
    end
end

-- Fungsi untuk membuat Toggle (dengan visual feedback)
local function CreateToggle(tabContent, name, defaultState, callback)
    local state = defaultState
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = tabContent
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 4)

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Text = name
    toggleButton.TextXAlignment = Enum.TextXAlignment.Left
    toggleButton.TextLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleButton.BackgroundTransparency = 1
    toggleButton.Font = Enum.Font.SourceSans
    toggleButton.TextSize = 14
    toggleButton.Parent = toggleFrame
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 15, 0, 15)
    Indicator.Position = UDim2.new(1, -25, 0.5, -7.5)
    Indicator.BackgroundColor3 = state and Color3.fromRGB(0, 191, 255) or Color3.fromRGB(60, 60, 60)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = toggleFrame
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 7.5) -- Lingkaran

    local function updateVisuals()
        local color = state and Color3.fromRGB(0, 191, 255) or Color3.fromRGB(60, 60, 60)
        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end
    
    -- Logika Klik
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        updateVisuals()
        callback(state)
    end)
    
    -- Animasi Hover Frame Luar
    toggleFrame.MouseEnter:Connect(function()
        TweenService:Create(toggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    toggleFrame.MouseLeave:Connect(function()
        TweenService:Create(toggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)

    -- Sesuaikan CanvasSize
    local listLayout = tabContent:FindFirstChild("ListLayout")
    if listLayout then
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end)
    end
    
    updateVisuals() -- Inisialisasi visual awal
end


-- ====================================================================
-- 5. IMPLEMENTASI FITUR (CONTOH)
-- ====================================================================

-- Buat Tab
local MainContent = CreateTab("PLAYER", 1)
local CombatContent = CreateTab("COMBAT", 2)
local MiscContent = CreateTab("MISC", 3)

-- Tab PLAYER
CreateToggle(MainContent, "Anti-AFK", false, function(state)
    if state then
        -- Logika Anti-AFK
        print("Anti-AFK Aktif")
    else
        print("Anti-AFK Non-Aktif")
    end
end)

CreateButton(MainContent, "Set WalkSpeed ke 50", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
        print("WalkSpeed diatur ke 50")
    end
end)

-- Tab COMBAT
CreateToggle(CombatContent, "Aimbot (Toggle)", false, function(state)
    if state then
        print("Aimbot Aktif")
    else
        print("Aimbot Non-Aktif")
    end
end)

CreateButton(CombatContent, "Insta-Kill Boss", function()
    print("Mencoba Insta-Kill...")
end)

-- Tab MISC
CreateButton(MiscContent, "Reset Character", function()
    LocalPlayer.Character:BreakJoints()
end)

-- ====================================================================
-- 6. INISIALISASI
-- ====================================================================

-- Aktifkan Tab pertama secara default
Tabs["PLAYER"].Button.MouseButton1Click:Fire()

-- Logika Toggle UI dengan hotkey (misalnya, Insert)
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Insert and not gameProcessedEvent then
        MainFrame.Visible = not MainFrame.Visible
        print("UI Toggled: " .. tostring(MainFrame.Visible))
    end
end)

print("Custom Modern UI V2.0 (10x Upgrade) Loaded! Press INSERT to Toggle.")
