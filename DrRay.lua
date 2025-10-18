-- Load Library
local success, DrRayLibrary = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/aanzapi/DrRay-UI-Library/main/DrRay.lua"))()
end)

if not success then
    warn("Gagal memuat UI Library. Cek koneksi atau executor-mu.")
    return
end

-- Buat Window
local window = DrRayLibrary:Load("Demo UI Aanz", "Dark")

-- Buat Tab
local mainTab = window:newTab("Main")

-- Tombol
mainTab:newButton("Klik Saya!", "Tes tombol", function()
    print("Tombol ditekan!")
end)

-- Toggle
mainTab:newToggle("Auto Farm", "On/Off", false, function(state)
    print("Auto Farm:", state and "ON" or "OFF")
end)

-- Slider
mainTab:newSlider("WalkSpeed", "Atur kecepatan", 250, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- Input
mainTab:newInput("Nama Player", "Masukkan nama", function(text)
    print("Input:", text)
end)

-- Toggle UI dengan RightShift
window:ToggleKey(Enum.KeyCode.RightShift)

print("✅ UI berhasil dimuat! Tekan 'RightShift' untuk buka/tutup.")
