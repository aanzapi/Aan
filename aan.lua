--[[
    ================================================================
    Base UI Script (DrRay UI + Fix Android + Teleport)
    ================================================================
]]

-- 1. Memuat Library (versi mobile friendly)
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/BatusaBoy/DrRay-UI-Library/main/DrRay.lua"))()

-- 2. Membuat Window
local window = DrRayLibrary:Load("Script Teleport GUI", "Default")
task.wait(1) -- Delay agar UI render dengan sempurna

-- 3. Membuat Tab
local mainTab = window:newTab("Main", "rbxassetid://13511613008")

-- 4. Tambahkan Elemen UI

mainTab:newButton("Klik Saya!", "Tombol contoh.", function()
    print("Tombol diklik!")
end)

mainTab:newToggle("Auto Farm", "Aktifkan auto farm.", false, function(state)
    if state then
        print("Auto Farm ON")
    else
        print("Auto Farm OFF")
    end
end)

mainTab:newSlider("WalkSpeed", "Atur kecepatan jalan.", 250, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    print("WalkSpeed diatur ke: " .. value)
end)

mainTab:newInput("Teleport ke Player", "Masukkan nama player.", function(text)
    local player = game.Players.LocalPlayer
    local target = game.Players:FindFirstChild(text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0,3,0))
        print("✅ Teleport ke " .. target.Name)
    else
        warn("⚠️ Player tidak ditemukan!")
    end
end)

-- 5. Toggle Key
window:ToggleKey(Enum.KeyCode.RightShift)

print("✅ GUI Siap! Tekan 'RightShift' untuk buka/tutup.")
