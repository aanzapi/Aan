--[[
    ================================================================
    Base UI Script (Menggunakan DrRay-UI-Library)
    ================================================================
    
    Template dasar GUI + Fitur Teleport ke Player
]]

-- 1. Memuat Library UI
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()

-- 2. Membuat Jendela (Window) Utama
local window = DrRayLibrary:Load("Script Teleport GUI", "Default")

-- 3. Membuat Tab
local mainTab = window:newTab("Main", "rbxassetid://13511613008")

-- 4. Komponen Utama

--- Tombol Contoh
mainTab:newButton("Klik Saya!", "Tombol contoh biasa.", function()
    print("Tombol telah diklik!")
end)

--- Toggle Auto Farm (contoh)
mainTab:newToggle("Auto Farm", "Aktifkan untuk farming otomatis.", false, function(state)
    if state then
        print("Auto Farm DIAKTIFKAN")
    else
        print("Auto Farm DIMATIKAN")
    end
end)

--- Slider WalkSpeed
mainTab:newSlider("WalkSpeed", "Mengatur kecepatan berjalan.", 250, 16, function(value)
    print("WalkSpeed diatur ke: " .. value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

--- Input Nama Player untuk Teleport
mainTab:newInput("Teleport ke Player", "Masukkan nama player yang ingin dikunjungi.", function(text)
    local player = game.Players.LocalPlayer
    local target = game.Players:FindFirstChild(text)

    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
        print("✅ Teleport berhasil ke " .. target.Name)
    else
        warn("⚠️ Player tidak ditemukan atau belum spawn.")
    end
end)

-- 5. Toggle Key untuk membuka / menutup UI
window:ToggleKey(Enum.KeyCode.RightShift)

print("✅ UI Berhasil Dimuat! Tekan 'RightShift' untuk membuka/menutup.")
