-- Orion Lib Base UI for Delta
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Delta Minimal UI",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "DeltaConfig"
})

-- Quick Actions Tab
local QuickTab = Window:MakeTab({
    Name = "Quick",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

QuickTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(Value)
        local Noclip = nil
        local Clip = nil
        
        if Value then
            Clip = false
            Noclip = game:GetService('RunService').Stepped:Connect(function()
                if Clip == false then
                    for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if child:IsA('BasePart') and child.CanCollide then
                            child.CanCollide = false
                        end
                    end
                end
            end)
            getgenv().NoclipLoop = Noclip
        else
            if NoclipLoop then
                NoclipLoop:Disconnect()
            end
        end
    end    
})

QuickTab:AddSlider({
    Name = "FOV Changer",
    Min = 70,
    Max = 120,
    Default = 70,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "FOV",
    Callback = function(Value)
        game:GetService("Workspace").CurrentCamera.FieldOfView = Value
    end    
})

-- Scripts Tab
local ScriptsTab = Window:MakeTab({
    Name = "Scripts",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

ScriptsTab:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end    
})

ScriptsTab:AddButton({
    Name = "CMD-X",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source"))()
    end
})

-- Info Tab
local InfoTab = Window:MakeTab({
    Name = "Info",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

InfoTab:AddParagraph("Welcome!", "This UI is optimized for Delta Executor")
InfoTab:AddLabel("Executor: Delta")
InfoTab:AddLabel("Status: Ready")
InfoTab:AddButton({
    Name = "Copy Discord",
    Callback = function()
        setclipboard("discord.gg/example")
        OrionLib:MakeNotification({
            Name = "Copied!",
            Content = "Discord link copied to clipboard",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end    
})

OrionLib:MakeNotification({
    Name = "UI Loaded!",
    Content = "Minimal UI loaded successfully",
    Image = "rbxassetid://4483345998",
    Time = 3
})

OrionLib:Init()
