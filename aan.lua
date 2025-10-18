--[[
    ================================================================
    Base UI Script (Full Kode Buatan Sendiri - Tanpa Library)
    ================================================================
    
    Kode ini membuat GUI dasar yang:
    1.  Dapat dipindahkan (Drag & Drop)
    2.  Memiliki Title Bar
    3.  Memiliki Tombol Tutup (X)
    
    Anda harus menambahkan elemen (tombol, toggle) secara manual
    ke dalam Frame "MainFrame".
]]

-- 1. Setup Dasar GUI

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomExecutorUI"
ScreenGui.Parent = game:GetService("CoreGui") -- Tempatkan di CoreGui agar tidak terpengaruh menu game

-- 2. Membuat Jendela Utama (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.3, 0, 0.4, 0) -- Ukuran: 30% lebar, 40% tinggi layar
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0) -- Posisi: Tengah (kurang lebih)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Warna dasar gelap
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true -- Penting untuk Dragging
MainFrame.Draggable = true -- Aktifkan Draggable
MainFrame.Parent = ScreenGui

-- 3. Menambahkan Title Bar
local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0.1, 0) -- 10% tinggi Frame
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Warna Title Bar
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextScaled = true
TitleBar.Text = "Nama Script Anda | Custom Base UI"
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.Parent = MainFrame

-- 4. Menambahkan Tombol Tutup (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0.1, 0, 1, 0) -- 10% lebar Title Bar
CloseButton.Position = UDim2.new(0.9, 0, 0, 0) -- Di sudut kanan
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Merah
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = TitleBar

-- Logika Tombol Tutup
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy() -- Menghapus seluruh UI
end)

-- 5. Membuat Container untuk Fitur (Tempat untuk Tombol, dll.)
local FeatureContainer = Instance.new("Frame")
FeatureContainer.Name = "FeatureContainer"
FeatureContainer.Size = UDim2.new(1, 0, 0.9, 0) -- Sisa 90% dari MainFrame
FeatureContainer.Position = UDim2.new(0, 0, 0.1, 0) -- Di bawah Title Bar
FeatureContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Sama dengan MainFrame
FeatureContainer.BackgroundTransparency = 1 -- Transparan
FeatureContainer.Parent = MainFrame

-- Tambahkan UIListLayout untuk menata elemen secara otomatis
local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = FeatureContainer
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Padding = UDim.new(0, 5) -- Jarak antar elemen 5 pixel
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 6. Contoh Menambahkan Elemen Fungsional (Button)

local ExampleButton = Instance.new("TextButton")
ExampleButton.Name = "ExampleButton"
ExampleButton.Size = UDim2.new(0.9, 0, 0, 30) -- Lebar 90%, Tinggi 30 pixel
ExampleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ExampleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExampleButton.Text = "Klik Me (Full Script)"
ExampleButton.Font = Enum.Font.SourceSans
ExampleButton.TextScaled = true
ExampleButton.LayoutOrder = 1 -- Urutan pertama di ListLayout
ExampleButton.Parent = FeatureContainer

ExampleButton.MouseButton1Click:Connect(function()
    print("Tombol Buatan Sendiri Ditekan!")
    -- Tambahkan fungsi script Anda di sini, misalnya:
    -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100 
end)

-- 7. Contoh Menambahkan Elemen Fungsional (Toggle)

local ExampleToggle = Instance.new("TextButton")
ExampleToggle.Name = "ExampleToggle"
ExampleToggle.Size = UDim2.new(0.9, 0, 0, 30) -- Lebar 90%, Tinggi 30 pixel
ExampleToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ExampleToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ExampleToggle.Text = "Toggle: OFF"
ExampleToggle.Font = Enum.Font.SourceSans
ExampleToggle.TextScaled = true
ExampleToggle.LayoutOrder = 2 -- Urutan kedua
ExampleToggle.Parent = FeatureContainer

local isToggled = false

ExampleToggle.MouseButton1Click:Connect(function()
    isToggled = not isToggled -- Balikkan status
    
    if isToggled then
        ExampleToggle.Text = "Toggle: ON"
        ExampleToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 50) -- Hijau (ON)
        print("Toggle DIAKTIFKAN")
        -- Masukkan fungsi ON di sini
    else
        ExampleToggle.Text = "Toggle: OFF"
        ExampleToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Abu-abu (OFF)
        print("Toggle DIMATIKAN")
        -- Masukkan fungsi OFF di sini
    end
end)

print("Base UI Full Kode Buatan Sendiri telah dimuat di CoreGui.")
