--[[
    ================================================================
    Base UI Script (Menggunakan Fluxus/V3rmillion UI Library)
    ================================================================
    
    Library ini sangat bagus, sering diperbarui, dan kompatibel
    dengan banyak executor, termasuk di Android (Delta).
]]

-- 1. Memuat Library UI
-- Ini adalah versi terbaru dari script loader (mungkin perlu disesuaikan jika library diperbarui)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/v3rmillion-ui/main/source.lua"))()

-- 2. Membuat Jendela (Window) Utama
local Window = Library:CreateWindow("Nama Script Anda ✨")

-- 3. Membuat Tab
local CombatTab = Window:AddTab("Combat ⚔️")
local PlayerTab = Window:AddTab("Player 🏃")

-- 4. Menambahkan Komponen ke 'CombatTab'

--- Contoh Tombol (Button)
CombatTab:AddButton("Execute Aimbot", function()
    print("Aimbot script executed!")
    -- Masukkan kode untuk menjalankan fungsi Aimbot/Aimlock di sini
end)

--- Contoh Toggle (Tombol On/Off)
CombatTab:AddToggle("Kill Aura", false, function(state)
    -- 'state' adalah true (ON) atau false (OFF)
    if state then
        print("Kill Aura: ON")
        -- Mulai fungsi Kill Aura
    else
        print("Kill Aura: OFF")
        -- Hentikan fungsi Kill Aura
    end
end)

-- 5. Menambahkan Komponen ke 'PlayerTab'

--- Contoh Slider
PlayerTab:AddSlider("Jump Power", 50, 50, 100, function(value)
    -- 'value' adalah nilai angka dari slider
    print("Jump Power diatur ke: " .. value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

--- Contoh Dropdown
PlayerTab:AddDropdown("Teleport Lokasi", {"Lobby", "Arena A", "Shop"}, function(location)
    -- 'location' adalah string yang dipilih dari menu dropdown
    print("Teleporting ke: " .. location)
    if location == "Lobby" then
        -- Masukkan koordinat atau fungsi teleport ke Lobby
        -- game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    elseif location == "Arena A" then
        -- Masukkan koordinat atau fungsi teleport ke Arena A
    end
end)

-- 6. Mengatur Hotkey (Opsional)
-- Tombol yang umum digunakan: Insert, RightControl, RightShift
Window:SetKey(Enum.KeyCode.Insert) -- Tekan 'Insert' untuk membuka/menutup UI

print("Fluxus/V3rmillion UI Berhasil Dimuat! Tekan 'Insert' untuk Toggle.")
