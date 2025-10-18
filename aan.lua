--[[
    ================================================================
    Base UI Script (Menggunakan DrRay-UI-Library)
    ================================================================
    
    Ini adalah template dasar untuk membuat GUI (Graphical User Interface)
    di dalam executor. Anda bisa menambahkan lebih banyak tab, tombol,
    slider, dan fungsi lainnya sesuai kebutuhan.
]]

-- 1. Memuat Library UI
-- Baris ini mengunduh dan menjalankan kode library dari GitHub.
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()

-- 2. Membuat Jendela (Window) Utama
-- "Nama Script Anda" = Judul jendela
-- "Default" = Tema (bisa juga "Dark", "Light", "Minimal", dll. tergantung library)
local window = DrRayLibrary:Load("Nama Script Anda", "Default")

-- 3. Membuat Tab
-- Anda bisa membuat beberapa tab untuk mengorganisir fitur.
local mainTab = window:newTab("Main", "rbxassetid://13511613008") -- Ganti ID ikon jika mau

-- 4. Menambahkan Komponen (Elemen UI)

--- Contoh Tombol (Button)
mainTab:newButton("Klik Saya!", "Ini adalah deskripsi tombol.", function()
    -- Kode yang akan dijalankan saat tombol diklik:
    print("Tombol telah diklik!")
    
    -- Contoh: Memberikan item ke pemain
    -- game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.ReplicatedStorage.Tools.Sword)
end)

--- Contoh Toggle (Tombol On/Off)
mainTab:newToggle("Auto Farm", "Aktifkan untuk farming otomatis.", false, function(state)
    -- 'state' akan bernilai 'true' jika ON dan 'false' jika OFF.
    if state then
        print("Auto Farm DIAKTIFKAN")
        -- Masukkan fungsi untuk memulai auto farm di sini
    else
        print("Auto Farm DIMATIKAN")
        -- Masukkan fungsi untuk menghentikan auto farm di sini
    end
end)

--- Contoh Slider
mainTab:newSlider("WalkSpeed", "Mengatur kecepatan berjalan.", 250, 16, function(value)
    -- 'value' adalah angka yang dipilih slider (antara 16 dan 250).
    print("WalkSpeed diatur ke: " .. value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

--- Contoh Text Input (Kotak Teks)
mainTab:newInput("Nama Player", "Masukkan nama player yang dituju.", function(text)
    -- 'text' adalah apa yang diketik oleh pengguna.
    print("Teks yang dimasukkan: " .. text)
    
    -- Contoh: Teleport ke player
    -- local targetPlayer = game.Players:FindFirstChild(text)
    -- if targetPlayer and targetPlayer.Character then
    --     game.Players.LocalPlayer.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
    -- end
end)

-- 5. (Opsional) Membuka/Menutup UI
-- Anda bisa mengatur tombol untuk membuka/menutup UI.
-- Contoh: Menggunakan tombol RightShift (Tombol Shift Kanan)
window:ToggleKey(Enum.KeyCode.RightShift)

print("UI Berhasil Dimuat! Tekan 'RightShift' untuk membuka/menutup.")
