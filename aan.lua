--[[==========================================================
 Base UI Template (OrionLib)
 Dibuat oleh AanzAI - versi dasar untuk executor Roblox
==========================================================]]

-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Buat Window Utama
local Window = OrionLib:MakeWindow({
    Name = "🔥 Aanz Hub - Base UI 🔥", 
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AanzHubConfig"
})

--[[======================
         TAB 1
======================]]
local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddParagraph("Welcome!", "Gunakan tombol di bawah untuk mengaktifkan fitur.")

Tab:AddButton({
	Name = "Aktifkan Fitur 1",
	Callback = function()
       print("Fitur 1 diaktifkan!")
       OrionLib:MakeNotification({
           Name = "✅ Fitur Aktif",
           Content = "Fitur 1 berhasil diaktifkan!",
           Image = "rbxassetid://4483345998",
           Time = 3
       })
   end    
})

Tab:AddToggle({
	Name = "Mode Otomatis",
	Default = false,
	Callback = function(Value)
		print("Mode Otomatis:", Value)
	end    
})

Tab:AddSlider({
	Name = "Kecepatan",
	Min = 1,
	Max = 100,
	Default = 50,
	Color = Color3.fromRGB(255,0,0),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		print("Kecepatan diatur ke:", Value)
	end    
})

Tab:AddTextbox({
	Name = "Masukkan Nama",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		print("Nama:", Value)
	end	  
})

--[[======================
         TAB 2
======================]]
local Tab2 = Window:MakeTab({
	Name = "Extra",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab2:AddParagraph("Info", "Tab tambahan untuk fitur lain.")
Tab2:AddButton({
	Name = "Teleport ke Spawn",
	Callback = function()
		game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
	end    
})

-- Inisialisasi UI
OrionLib:Init()
