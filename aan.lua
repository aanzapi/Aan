--[[
    ================================================================
    Base UI Script (Versi Lengkap)
    Menggunakan DrRay-UI-Library (by .chill.z.)
    ================================================================
    Fitur:
    - UI langsung terbuka otomatis
    - 2 Tab (Main & Settings)
    - Contoh Button, Toggle, Input, Dropdown, Slider, Keybind
    - Tema warna custom (Dark Blue Style)
]]

-- 1. Muat Library DrRay
local success, DrRayLibrary = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
end)

if not success or not DrRayLibrary then
    warn("❌ Gagal memuat DrRay UI Library. Pastikan koneksi dan executor support HTTP!")
    return
end

-- 2. Buat Window Utama
local window = DrRayLibrary:Load("🚀 Aanz Base UI", "Default")

-- (Opsional) Ubah Tema Warna
local mainColor = Color3.fromRGB(20, 25, 45)
local secondColor = Color3.fromRGB(0, 120, 255)
window:SetTheme(mainColor, secondColor)

-- 3. Buat Tab
local mainTab = DrRayLibrary.newTab("Main", "rbxassetid://13511613008")
local settingsTab = DrRayLibrary.newTab("Settings", "rbxassetid://4483345998")

-- =============================
-- 🔹 TAB 1: MAIN
-- =============================

-- Tombol
mainTab.newButton("Say Hello", "Menampilkan pesan di console", function()
    print("👋 Hello from Aanz Base UI!")
end)

-- Toggle
mainTab.newToggle("Auto Farm", "Aktifkan mode farming otomatis", false, function(state)
    if state then
        print("⚙️ Auto Farm AKTIF")
    else
        print("❌ Auto Farm MATI")
    end
end)

-- Input
mainTab.newInput("Nama Player", "Masukkan nama target untuk teleport", function(text)
    print("🎯 Target player:", text)
end)

-- Slider
mainTab.newSlider("WalkSpeed", "Atur kecepatan jalan", 250, false, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    print("🚶 WalkSpeed diatur ke:", value)
end)

-- Dropdown
mainTab.newDropdown("Pilih Senjata", "Pilih senjata favoritmu!", {"Sword", "Gun", "Bow", "Magic"}, function(selected)
    print("🔫 Senjata terpilih:", selected)
end)

-- Keybind
mainTab.newKeybind("Keybind Test", "Tekan tombol apa pun!", function(key)
    print("⌨️ Kamu menekan tombol:", key)
end)

-- =============================
-- 🔧 TAB 2: SETTINGS
-- =============================

-- Tombol Tutup
settingsTab.newButton("Tutup UI", "Menutup tampilan UI", function()
    window:Close()
    print("❌ UI ditutup.")
end)

-- Tombol Buka Lagi
settingsTab.newButton("Buka UI", "Membuka kembali UI", function()
    window:Open()
    print("✅ UI dibuka kembali.")
end)

-- Toggle Tema
settingsTab.newToggle("Tema Gelap", "Ubah ke warna gelap/terang", false, function(state)
    if state then
        window:SetTheme(Color3.fromRGB(20, 20, 20), Color3.fromRGB(255, 85, 0))
        print("🌑 Tema gelap diaktifkan.")
    else
        window:SetTheme(mainColor, secondColor)
        print("🌕 Tema default dikembalikan.")
    end
end)

-- 4. Buka UI secara otomatis
task.defer(function()
    window:Open()
end)

print("✅ DrRay Base UI berhasil dimuat dan ditampilkan!")
