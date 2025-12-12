-- UI dengan efek visual
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI/main/Library.lua"))()
local Window = Library.CreateLib("Delta Pro UI", "Sentinel")

-- Home Section
local Home = Window:NewTab("Home")
local HomeSection = Home:NewSection("Welcome")

HomeSection:NewButton("Rejoin Server", "Rejoin current server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

HomeSection:NewToggle("Fly (E)", "Press E to fly", function(state)
    getgenv().FlyEnabled = state
    if state then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end
end)

-- Visuals Section
local Visuals = Window:NewTab("Visuals")
local ESP = Visuals:NewSection("ESP Settings")

ESP:NewToggle("Box ESP", "Draw box around players", function(state)
    -- ESP function here
    print("Box ESP:", state)
end)

ESP:NewColorPicker("ESP Color", "Choose ESP color", Color3.fromRGB(255,0,0), function(color)
    print("Color changed to:", color)
end)

-- Settings
local Settings = Window:NewTab("Settings")
local UI = Settings:NewSection("UI Customization")

UI:NewKeybind("Toggle UI", "Show/Hide UI", Enum.KeyCode.RightShift, function()
	Library:ToggleUI()
end)

UI:NewButton("Save Settings", "Save current config", function()
    Library:SaveConfig("DeltaConfig")
end)

UI:NewButton("Destroy UI", "Remove UI", function()
    Library:Destroy()
end)
