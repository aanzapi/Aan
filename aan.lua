--[[
    ================================================================
    Base UI Script (Versi Auto Open)
    Menggunakan DrRay-UI-Library
    ================================================================
    ✅ Fitur:
    - UI langsung muncul tanpa tekan tombol
    - Tab, Tombol, Toggle, Slider, Input sudah siap
    - Bisa kamu edit dan tambah fitur sendiri
]]

-- 1. Memuat Library UI
local success, DrRayLibrary = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/aanzapi/DrRay-UI-Library/main/DrRay.lua"))()
end)

if not success or not DrRayLibrary then
    warn("❌ Gagal memuat UI Library! Cek koneksi atau executor kamu.")
    return
end

-- 2. Membuat Jendela (Window) Utama
local window = DrRayLibrary:Load("🚀 Aanz Base UI", "Dark")

-- 3. Membuat Tab Utama
local mainTab = window:newTab("Main", "rbxassetid://13511613008")

-- 4. Tambahkan Komponen / Fitur

--- Tombol (Button)
mainTab:newButton("Klik Saya!", "Contoh tombol yang bisa kamu ubah.", function()
    print("✅ Tombol diklik!")
end)

--- Toggle (On/Off)
mainTab:newToggle("Auto Farm", "Aktifkan untuk farming otomatis.", false, function(state)
    if state then
        print("⚙️ Auto Farm: AKTIF")
    else
        print("❌ Auto Farm: MATI")
    end
end)

--- Slider
mainTab:newSlider("WalkSpeed", "Atur kecepatan jalan.", 250, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    print("🚶 WalkSpeed diatur ke:", value)
end)

--- Input Box
mainTab:newInput("Nama Player", "Masukkan nama player tujuan.", function(text)
    print("🎯 Input player:", text)
end)

-- 5. Buka UI secara otomatis (tanpa tombol)
-- Fungsi ini membuka UI langsung setelah script dijalankan
task.defer(function()
    window:Open()
end)

print("✅ UI berhasil dimuat & langsung dibuka!")
