--[[
    ================================================================
    Base UI Script (Menggunakan Rayfield UI Library)
    ================================================================
    
    Ini adalah template dasar untuk Rayfield.
    Script ini sudah menyertakan:
    1.  Window (Jendela utama)
    2.  Tab (Untuk memilah fitur)
    3.  Button (Tombol)
    4.  Toggle (Tombol On/Off)
    5.  Slider (Penggeser nilai)
    6.  Input (Kotak teks)
    
    Dokumentasi resmi: https://github.com/shlexware/Rayfield
]]

-- 1. Memuat Library Rayfield
-- Ini adalah baris wajib untuk mengunduh dan menjalankan library-nya
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- 2. Membuat Jendela (Window) Utama
local Window = Rayfield:CreateWindow({
    Name = "Nama Script Anda v1.0",
    LoadingTitle = "Memuat Script...",
    LoadingSubtitle = "oleh [Nama Anda]",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "ConfigScriptSaya" -- Nama file untuk menyimpan setelan (toggle, slider)
    },
    KeySystem = false -- Ganti ke 'true' jika Anda ingin menggunakan sistem kunci
})

-- 3. Membuat Tab
-- Anda bisa membuat beberapa tab jika fiturnya banyak
local MainTab = Window:CreateTab("Fitur Utama", "rbxassetid://4483345998") -- Ganti ikon jika mau
local MiscTab = Window:CreateTab("Lain-lain", "rbxassetid://4483345998") -- Contoh tab kedua

-- 4. Menambahkan Komponen (Elemen UI) ke 'MainTab'

--- Contoh Tombol (Button)
MainTab:CreateButton({
    Name = "Cetak Pesan",
    Description = "Mencetak 'Tombol Ditekan!' di konsol (F9).",
    Callback = function()
        -- Kode yang dijalankan saat tombol diklik:
        print("Tombol Ditekan!")
        Rayfield:Notify({
            Title = "Notifikasi",
            Content = "Anda baru saja menekan tombol!",
            Duration = 5
        })
    end
})

--- Contoh Toggle (Tombol On/Off)
MainTab:CreateToggle({
    Name = "Auto Farm",
    Description = "Aktifkan untuk farming otomatis (contoh).",
    Default = false, -- Nilai awal (false = mati)
    Callback = function(state)
        -- 'state' adalah true (jika ON) atau false (jika OFF)
        if state then
            print("Auto Farm DIAKTIFKAN")
            -- Masukkan fungsi untuk MEMULAI auto farm di sini
        else
            print("Auto Farm DIMATIKAN")
            -- Masukkan fungsi untuk MENGHENTIKAN auto farm di sini
        end
    end
})

--- Contoh Slider
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Description = "Mengatur kecepatan berjalan karakter.",
    Min = 16,      -- Nilai minimum
    Max = 200,     -- Nilai maksimum
    Default = 16,  -- Nilai saat UI pertama kali dimuat
    Callback = function(value)
        -- 'value' adalah angka yang dipilih dari slider
        print("WalkSpeed diatur ke: " .. value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

--- Contoh Text Input (Kotak Teks)
MainTab:CreateInput({
    Name = "Teleport ke Player",
    Description = "Masukkan nama lengkap player yang ingin Anda tuju.",
    PlaceholderText = "Ketik nama di sini...",
    Callback = function(text)
        -- 'text' adalah apa yang diketik oleh pengguna
        print("Mencoba teleport ke: " .. text)
        
        -- Contoh fungsi teleport sederhana:
        local targetPlayer = game.Players:FindFirstChild(text)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({ Title = "Teleport", Content = "Berhasil teleport ke " .. text, Duration = 5 })
        else
            Rayfield:Notify({ Title = "Error", Content = "Player '" .. text .. "' tidak ditemukan!", Duration = 5 })
        end
    end
})

-- 5. Menambahkan Komponen ke 'MiscTab' (Contoh Tab Kedua)

MiscTab:CreateButton({
    Name = "Reset Karakter",
    Description = "Membuat karakter Anda reset.",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

-- 6. (Opsional) Mengatur Tombol Buka/Tutup UI
-- 'RightControl' (Ctrl Kanan) adalah tombol yang umum digunakan.
Window:ToggleKey(Enum.KeyCode.RightControl)

-- 7. Konfirmasi
print("Rayfield UI Berhasil Dimuat!")
print("Tekan 'RightControl' (Ctrl Kanan) untuk membuka/menutup UI.")
