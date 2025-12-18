-- ====================================================================
--                      DELTA EXECUTOR - BLAZEN HUB
--                      Advanced Fishing Autofarm
-- ====================================================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Local Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
Player.CharacterAdded:Connect(function(char)
    Character = char
end)

-- Configuration
getgenv().BlazenConfig = {
    Fishing = {
        Enabled = false,
        BlatantMode = false,
        ReelDelay = 0.5,
        FishingDelay = 0.0015,
        CastDelay = 0.5,
        AutoSell = false,
        SellDelay = 60
    },
    UI = {
        Theme = "Dark",
        AccentColor = Color3.fromRGB(0, 170, 255),
        Keybind = Enum.KeyCode.RightControl
    }
}

-- Save/Load Configuration
local function SaveConfig()
    writefile("BlazenHub_Config.json", HttpService:JSONEncode(getgenv().BlazenConfig))
end

local function LoadConfig()
    if isfile("BlazenHub_Config.json") then
        local success, config = pcall(function()
            return HttpService:JSONDecode(readfile("BlazenHub_Config.json"))
        end)
        if success then
            getgenv().BlazenConfig = config
            return true
        end
    end
    return false
end

-- Notification System
local function Notify(data)
    if Library and Library.Notify then
        Library:Notify(data)
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = data.Title or "Blazen Hub",
            Text = data.Content or "",
            Duration = data.Duration or 3,
            Icon = data.Icon or "rbxassetid://4483345998"
        })
    end
end

-- ====================================================================
--                 ADVANCED FISHING MODULE WITH MINIGAME BYPASS
-- ====================================================================

local AdvancedFishing = {}
AdvancedFishing.isActive = false
AdvancedFishing.isFishing = false
AdvancedFishing.useBlatantMode = false
AdvancedFishing.networkInitialized = false

-- Network Events
local NetworkEvents = {
    fishing = nil,
    sell = nil,
    charge = nil,
    minigame = nil,
    cancel = nil,
    equip = nil,
    unequip = nil,
    favorite = nil
}

-- Initialize network dengan bypass yang lebih agresif
function AdvancedFishing.initializeNetwork()
    if AdvancedFishing.networkInitialized then return true end
    
    local success, result = pcall(function()
        -- Method 1: Try via Net package
        local net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
        
        NetworkEvents = {
            fishing = net:WaitForChild("RE/FishingCompleted"),
            sell = net:WaitForChild("RF/SellAllItems"),
            charge = net:WaitForChild("RF/ChargeFishingRod"),
            minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
            cancel = net:WaitForChild("RF/CancelFishingInputs"),
            equip = net:WaitForChild("RE/EquipToolFromHotbar"),
            unequip = net:WaitForChild("RE/UnequipToolFromHotbar"),
            favorite = net:WaitForChild("RE/FavoriteItem")
        }
        
        return true
    end)
    
    if not success then
        -- Method 2: Manual search in ReplicatedStorage
        success = pcall(function()
            local remotes = {
                fishing = ReplicatedStorage:FindFirstChild("FishingCompleted") or 
                         ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("FishingCompleted"),
                charge = ReplicatedStorage:FindFirstChild("ChargeFishingRod") or 
                        ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("ChargeFishingRod"),
                minigame = ReplicatedStorage:FindFirstChild("RequestFishingMinigameStarted") or 
                          ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("RequestFishingMinigameStarted"),
                equip = ReplicatedStorage:FindFirstChild("EquipToolFromHotbar") or 
                       ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("EquipToolFromHotbar"),
                unequip = ReplicatedStorage:FindFirstChild("UnequipToolFromHotbar") or 
                         ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("UnequipToolFromHotbar")
            }
            
            for name, remote in pairs(remotes) do
                if remote then
                    NetworkEvents[name] = remote
                end
            end
        end)
    end
    
    if success then
        AdvancedFishing.networkInitialized = true
        print("[AdvancedFishing] Network initialized with bypass")
        return true
    else
        warn("[AdvancedFishing] Failed to initialize network:", result)
        return false
    end
end

-- Bypass Minigame System
local MinigameBypass = {
    hooked = false,
    originalFunctions = {}
}

-- Hook ke fungsi fishing controller untuk bypass minigame
function MinigameBypass.hookFishingFunctions()
    if MinigameBypass.hooked then return end
    
    pcall(function()
        -- Cari fishing controller
        local fishingController
        for _, module in pairs(ReplicatedStorage:GetDescendants()) do
            if module:IsA("ModuleScript") and (string.find(module.Name:lower(), "fishing") or string.find(module.Name:lower(), "controller")) then
                local modSuccess, modResult = pcall(require, module)
                if modSuccess and type(modResult) == "table" then
                    if modResult.FishingRodStarted or modResult.StartFishing then
                        fishingController = modResult
                        break
                    end
                end
            end
        end
        
        if fishingController then
            -- Hook FishingRodStarted untuk bypass minigame
            if fishingController.FishingRodStarted then
                MinigameBypass.originalFunctions.FishingRodStarted = fishingController.FishingRodStarted
                fishingController.FishingRodStarted = function(rodData, minigameData)
                    if AdvancedFishing.useBlatantMode then
                        print("⚡ [BYPASS] Minigame skipped - Auto completing fishing")
                        
                        -- Langsung complete fishing tanpa minigame
                        task.spawn(function()
                            task.wait(blatantReelDelay) -- Tunggu delay reel
                            pcall(function()
                                if NetworkEvents.fishing then
                                    NetworkEvents.fishing:FireServer()
                                    print("✅ [BYPASS] Fishing completed automatically")
                                end
                            end)
                        end)
                        
                        return -- Skip original function
                    else
                        -- Jalankan fungsi original jika bukan blatant mode
                        return MinigameBypass.originalFunctions.FishingRodStarted(rodData, minigameData)
                    end
                end
            end
            
            -- Hook StartFishing jika ada
            if fishingController.StartFishing then
                MinigameBypass.originalFunctions.StartFishing = fishingController.StartFishing
                fishingController.StartFishing = function(...)
                    if AdvancedFishing.useBlatantMode then
                        print("⚡ [BYPASS] StartFishing intercepted")
                        return true -- Return true untuk bypass
                    else
                        return MinigameBypass.originalFunctions.StartFishing(...)
                    end
                end
            end
            
            MinigameBypass.hooked = true
            print("✅ [BYPASS] Fishing functions hooked successfully")
        end
    end)
end

function MinigameBypass.unhookFishingFunctions()
    if not MinigameBypass.hooked then return end
    
    pcall(function()
        -- Cari fishing controller lagi untuk restore
        local fishingController
        for _, module in pairs(ReplicatedStorage:GetDescendants()) do
            if module:IsA("ModuleScript") and (string.find(module.Name:lower(), "fishing") or string.find(module.Name:lower(), "controller")) then
                local modSuccess, modResult = pcall(require, module)
                if modSuccess and type(modResult) == "table" then
                    fishingController = modResult
                    break
                end
            end
        end
        
        if fishingController then
            -- Restore original functions
            for funcName, originalFunc in pairs(MinigameBypass.originalFunctions) do
                if fishingController[funcName] then
                    fishingController[funcName] = originalFunc
                end
            end
            
            MinigameBypass.hooked = false
            MinigameBypass.originalFunctions = {}
            print("✅ [BYPASS] Fishing functions restored")
        end
    end)
end

-- Cast rod dengan bypass
local function advancedCastRod()
    pcall(function()
        if not NetworkEvents.equip then
            AdvancedFishing.initializeNetwork()
        end
        
        -- Equip fishing rod
        NetworkEvents.equip:FireServer(1)
        task.wait(0.05)
        
        -- Charge fishing rod dengan parameter khusus untuk bypass
        NetworkEvents.charge:InvokeServer(1755848498.4834)
        task.wait(0.02)
        
        -- Start minigame (akan di-bypass oleh hook)
        NetworkEvents.minigame:InvokeServer(1.2854545116425, 1)
        print("🎣 [AdvancedFishing] Cast with bypass")
    end)
end

-- Reel in dengan bypass
local function advancedReelIn()
    pcall(function()
        if NetworkEvents.fishing then
            NetworkEvents.fishing:FireServer()
            print("🎣 [AdvancedFishing] Reel with bypass")
        end
    end)
end

-- Blatant fishing loop dengan bypass minigame
local function advancedBlatantLoop(config)
    while AdvancedFishing.isActive and AdvancedFishing.useBlatantMode do
        if not AdvancedFishing.isFishing then
            AdvancedFishing.isFishing = true
            
            -- Fast casting sequence dengan bypass
            pcall(function()
                -- Equip rod
                NetworkEvents.equip:FireServer(1)
                task.wait(0.01)
                
                -- Multiple casts untuk meningkatkan chance
                for i = 1, 3 do
                    task.spawn(function()
                        NetworkEvents.charge:InvokeServer(1755848498.4834)
                        task.wait(0.01)
                        NetworkEvents.minigame:InvokeServer(1.2854545116425, 1)
                    end)
                    task.wait(0.05)
                end
            end)
            
            -- Tunggu fish delay
            task.wait(config.FishDelay)
            
            -- Auto reel multiple times
            for i = 1, 8 do
                advancedReelIn()
                task.wait(0.01)
            end
            
            -- Cooldown sebelum cast berikutnya
            task.wait(config.CatchDelay * 0.3)
            AdvancedFishing.isFishing = false
            
        else
            task.wait(0.01)
        end
    end
end

-- Normal fishing loop
local function advancedNormalLoop(config)
    while AdvancedFishing.isActive and not AdvancedFishing.useBlatantMode do
        if not AdvancedFishing.isFishing then
            AdvancedFishing.isFishing = true
            
            advancedCastRod()
            task.wait(config.FishDelay)
            advancedReelIn()
            task.wait(config.CatchDelay)
            
            AdvancedFishing.isFishing = false
        else
            task.wait(0.1)
        end
    end
end

-- Start fishing dengan bypass
function AdvancedFishing.start(config, blatantMode)
    if AdvancedFishing.isActive then return end
    
    -- Initialize network dan hook functions
    if not AdvancedFishing.initializeNetwork() then
        warn("[AdvancedFishing] Failed to initialize network")
        return
    end
    
    AdvancedFishing.isActive = true
    AdvancedFishing.useBlatantMode = blatantMode
    
    -- Hook functions untuk bypass jika mode blatant
    if blatantMode then
        MinigameBypass.hookFishingFunctions()
    end
    
    print("[AdvancedFishing] Started", blatantMode and "(Blatant with Minigame Bypass)" or "(Normal)")
    
    -- Start fishing loop
    task.spawn(function()
        while AdvancedFishing.isActive do
            if AdvancedFishing.useBlatantMode then
                advancedBlatantLoop(config)
            else
                advancedNormalLoop(config)
            end
            task.wait(0.1)
        end
    end)
end

-- Stop fishing
function AdvancedFishing.stop()
    AdvancedFishing.isActive = false
    AdvancedFishing.isFishing = false
    
    -- Unhook functions
    MinigameBypass.unhookFishingFunctions()
    
    -- Unequip rod
    pcall(function()
        if NetworkEvents.unequip then
            NetworkEvents.unequip:FireServer()
        end
    end)
    
    print("[AdvancedFishing] Stopped")
end

-- Toggle blatant mode
function AdvancedFishing.setBlatantMode(enabled)
    if AdvancedFishing.useBlatantMode == enabled then return end
    
    AdvancedFishing.useBlatantMode = enabled
    
    if enabled then
        MinigameBypass.hookFishingFunctions()
    else
        MinigameBypass.unhookFishingFunctions()
    end
end

-- ====================================================================
--                          UI LIBRARY
-- ====================================================================

local Library = {}

function Library:CreateWindow(config)
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlazenHub"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Corner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- Drop Shadow
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.Size = UDim2.new(1, 0, 1, 0)
    DropShadow.Position = UDim2.new(0, 0, 0, 0)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Title or "Blazen Hub"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 120, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -120, 1, -40)
    ContentContainer.Position = UDim2.new(0, 120, 0, 40)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    -- Store tabs
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Make window draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Return window object
    local Window = {}
    Window.ScreenGui = ScreenGui
    
    function Window:Tab(config)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. config.Title
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Position = UDim2.new(0, 0, 0, (#self.Tabs * 40))
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        TabButton.BorderSizePixel = 0
        TabButton.Text = config.Title
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Parent = TabContainer
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. config.Title
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 5)
        UIListLayout.Parent = TabContent
        
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tab contents
            for _, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            
            -- Show this tab
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            self.CurrentTab = config.Title
        end)
        
        -- Store tab
        local tabObj = {
            Button = TabButton,
            Content = TabContent,
            Title = config.Title
        }
        table.insert(self.Tabs, tabObj)
        
        -- Set first tab as active
        if #self.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            self.CurrentTab = config.Title
        end
        
        -- Return tab functions
        local Tab = {}
        
        function Tab:Section(config)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section"
            SectionFrame.Size = UDim2.new(1, -20, 0, config.Height or 100)
            SectionFrame.Position = UDim2.new(0, 10, 0, 0)
            SectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = SectionFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Size = UDim2.new(1, -20, 0, 30)
            SectionTitle.Position = UDim2.new(0, 10, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = config.Title or "Section"
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = config.TextSize or 18
            SectionTitle.Font = config.FontWeight or Enum.Font.GothamSemibold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            return {
                Frame = SectionFrame,
                Title = SectionTitle
            }
        end
        
        function Tab:Toggle(config)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Parent = TabContent
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(0, 150, 0, 30)
            ToggleButton.Position = UDim2.new(0, 0, 0, 5)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = ToggleButton
            
            local ToggleText = Instance.new("TextLabel")
            ToggleText.Name = "ToggleText"
            ToggleText.Size = UDim2.new(1, -40, 1, 0)
            ToggleText.Position = UDim2.new(0, 10, 0, 0)
            ToggleText.BackgroundTransparency = 1
            ToggleText.Text = config.Title
            ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleText.TextSize = 14
            ToggleText.Font = Enum.Font.GothamMedium
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left
            ToggleText.Parent = ToggleButton
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "ToggleIndicator"
            ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
            ToggleIndicator.Position = UDim2.new(1, -30, 0.5, -10)
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 105)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleButton
            
            local UICorner2 = Instance.new("UICorner")
            UICorner2.CornerRadius = UDim.new(0, 4)
            UICorner2.Parent = ToggleIndicator
            
            local state = config.Default or false
            if state then
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                else
                    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 105)
                end
                
                if config.Callback then
                    config.Callback(state)
                end
                
                -- Save to config if flag provided
                if config.Flag then
                    if string.find(config.Flag, "Fishing") then
                        getgenv().BlazenConfig.Fishing.Enabled = state
                    elseif string.find(config.Flag, "Blatant") then
                        getgenv().BlazenConfig.Fishing.BlatantMode = state
                    end
                    SaveConfig()
                end
            end)
            
            return ToggleButton
        end
        
        function Tab:Slider(config)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Size = UDim2.new(1, -20, 0, 60)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = TabContent
            
            local SliderText = Instance.new("TextLabel")
            SliderText.Name = "SliderText"
            SliderText.Size = UDim2.new(1, 0, 0, 20)
            SliderText.BackgroundTransparency = 1
            SliderText.Text = config.Title
            SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderText.TextSize = 14
            SliderText.Font = Enum.Font.GothamMedium
            SliderText.TextXAlignment = Enum.TextXAlignment.Left
            SliderText.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Name = "SliderValue"
            SliderValue.Size = UDim2.new(0, 100, 0, 20)
            SliderValue.Position = UDim2.new(1, -100, 0, 0)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(config.Value.Default)
            SliderValue.TextColor3 = Color3.fromRGB(200, 200, 200)
            SliderValue.TextSize = 14
            SliderValue.Font = Enum.Font.GothamMedium
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Name = "SliderBar"
            SliderBar.Size = UDim2.new(1, 0, 0, 20)
            SliderBar.Position = UDim2.new(0, 0, 0, 30)
            SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local UICorner2 = Instance.new("UICorner")
            UICorner2.CornerRadius = UDim.new(0, 4)
            UICorner2.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBar
            
            local value = config.Value.Default
            local min = config.Value.Min
            local max = config.Value.Max
            local step = config.Step or 1
            
            -- Set initial value
            local percentage = (value - min) / (max - min)
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            
            local dragging = false
            
            local function updateValue(newValue)
                value = math.clamp(newValue, min, max)
                value = math.floor(value / step + 0.5) * step
                
                local percentage = (value - min) / (max - min)
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                SliderValue.Text = string.format("%.2f", value)
                
                if config.Callback then
                    config.Callback(value)
                end
                
                -- Save to config if flag provided
                if config.Flag then
                    if config.Flag == "BlatantReelDelay" then
                        getgenv().BlazenConfig.Fishing.ReelDelay = value
                    elseif config.Flag == "BlatantFishingDelay" then
                        getgenv().BlazenConfig.Fishing.FishingDelay = value
                    elseif config.Flag == "AutoSellDelay" then
                        getgenv().BlazenConfig.Fishing.SellDelay = value
                    end
                    SaveConfig()
                end
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            SliderBar.MouseMoved:Connect(function(x, y)
                if dragging then
                    local relativeX = x - SliderBar.AbsolutePosition.X
                    local percentage = math.clamp(relativeX / SliderBar.AbsoluteSize.X, 0, 1)
                    local newValue = min + (max - min) * percentage
                    updateValue(newValue)
                end
            end)
            
            return SliderFrame
        end
        
        function Tab:Button(config)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "Button"
            ButtonFrame.Size = UDim2.new(1, -20, 0, 40)
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.Parent = TabContent
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            Button.BorderSizePixel = 0
            Button.Text = config.Title
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Font = Enum.Font.GothamMedium
            Button.Parent = ButtonFrame
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)
            
            Button.MouseEnter:Connect(function()
                Button.BackgroundColor3 = Color3.fromRGB(0, 150, 235)
            end)
            
            Button.MouseLeave:Connect(function()
                Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            end)
            
            return Button
        end
        
        function Tab:Space()
            local Space = Instance.new("Frame")
            Space.Name = "Space"
            Space.Size = UDim2.new(1, 0, 0, 10)
            Space.BackgroundTransparency = 1
            Space.Parent = TabContent
        end
        
        function Tab:Label(config)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label"
            LabelFrame.Size = UDim2.new(1, -20, 0, 30)
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = config.Text or "Label"
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = LabelFrame
            
            return Label
        end
        
        return Tab
    end
    
    function Window:Notify(config)
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification"
        Notification.Size = UDim2.new(0, 300, 0, 70)
        Notification.Position = UDim2.new(1, -320, 1, -80)
        Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Notification.BorderSizePixel = 0
        Notification.Parent = ScreenGui
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = Notification
        
        local DropShadow = Instance.new("ImageLabel")
        DropShadow.Name = "DropShadow"
        DropShadow.Size = UDim2.new(1, 0, 1, 0)
        DropShadow.BackgroundTransparency = 1
        DropShadow.Image = "rbxassetid://6015897843"
        DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        DropShadow.ImageTransparency = 0.5
        DropShadow.ScaleType = Enum.ScaleType.Slice
        DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
        DropShadow.Parent = Notification
        
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Size = UDim2.new(1, -20, 0, 25)
        Title.Position = UDim2.new(0, 10, 0, 10)
        Title.BackgroundTransparency = 1
        Title.Text = config.Title or "Notification"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 16
        Title.Font = Enum.Font.GothamSemibold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Notification
        
        local Content = Instance.new("TextLabel")
        Content.Name = "Content"
        Content.Size = UDim2.new(1, -20, 0, 30)
        Content.Position = UDim2.new(0, 10, 0, 35)
        Content.BackgroundTransparency = 1
        Content.Text = config.Content or ""
        Content.TextColor3 = Color3.fromRGB(200, 200, 200)
        Content.TextSize = 14
        Content.Font = Enum.Font.Gotham
        Content.TextXAlignment = Enum.TextXAlignment.Left
        Content.TextYAlignment = Enum.TextYAlignment.Top
        Content.TextWrapped = true
        Content.Parent = Notification
        
        task.spawn(function()
            wait(config.Duration or 3)
            Notification:Destroy()
        end)
    end
    
    return Window
end

-- Create UI
LoadConfig()

local Window = Library:CreateWindow({
    Title = "Blazen Hub | Fishing Autofarm",
})

-- ========== MAIN TAB ==========
local MainTab = Window:Tab({
    Title = "Main",
})

MainTab:Section({
    Title = "Auto Fishing System",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
    Height = 120
})

MainTab:Space()

MainTab:Toggle({
    Title = "Enable Auto Fishing",
    Desc = "Automated fishing with server communication",
    Flag = "AutoFishToggle",
    Default = getgenv().BlazenConfig.Fishing.Enabled,
    Callback = function(state)
        if state then
            AdvancedFishing.start({
                FishDelay = getgenv().BlazenConfig.Fishing.FishingDelay,
                CatchDelay = getgenv().BlazenConfig.Fishing.ReelDelay
            }, getgenv().BlazenConfig.Fishing.BlatantMode)
        else
            AdvancedFishing.stop()
        end
    end
})

MainTab:Space()

-- ========== BLATANT FISHING TAB ==========
local BlatantTab = Window:Tab({
    Title = "⚡ Blatant",
})

BlatantTab:Section({
    Title = "Blatant Fishing System",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
    Height = 250
})

BlatantTab:Space()

BlatantTab:Toggle({
    Title = "Blatant Mode",
    Desc = "Fast fishing with minigame bypass",
    Flag = "BlatantModeToggle",
    Default = getgenv().BlazenConfig.Fishing.BlatantMode,
    Callback = function(state)
        getgenv().BlazenConfig.Fishing.BlatantMode = state
        SaveConfig()
        AdvancedFishing.setBlatantMode(state)
    end
})

BlatantTab:Slider({
    Title = "Delay Reel",
    Desc = "Delay before reeling fish (0 - 1.87)",
    Flag = "BlatantReelDelay",
    Step = 0.01,
    Value = {
        Min = 0,
        Max = 1.87,
        Default = getgenv().BlazenConfig.Fishing.ReelDelay,
    },
    Callback = function(value)
        getgenv().BlazenConfig.Fishing.ReelDelay = value
        SaveConfig()
    end
})

BlatantTab:Slider({
    Title = "Delay Fishing",
    Desc = "Delay between fishing attempts (Fast Loop)",
    Flag = "BlatantFishingDelay",
    Step = 0.001,
    Value = {
        Min = 0,
        Max = 0.1,
        Default = getgenv().BlazenConfig.Fishing.FishingDelay,
    },
    Callback = function(value)
        getgenv().BlazenConfig.Fishing.FishingDelay = value
        SaveConfig()
    end
})

BlatantTab:Button({
    Title = "Initialize Blatant System",
    Icon = "zap",
    Callback = function()
        AdvancedFishing.initializeNetwork()
        Window:Notify({
            Title = "Blatant Fishing",
            Content = "System initialized successfully",
            Duration = 3
        })
    end
})

BlatantTab:Button({
    Title = "Manual Cast",
    Icon = "fishing-rod",
    Callback = function()
        if AdvancedFishing.initializeNetwork() then
            advancedCastRod()
            Window:Notify({
                Title = "⚡ Manual Cast",
                Content = "Casting fishing rod with bypass...",
                Duration = 2
            })
        end
    end
})

BlatantTab:Space()

-- ========== SETTINGS TAB ==========
local SettingsTab = Window:Tab({
    Title = "Settings",
})

SettingsTab:Section({
    Title = "Configuration",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
    Height = 150
})

SettingsTab:Space()

SettingsTab:Toggle({
    Title = "Auto Save Config",
    Desc = "Automatically save configuration",
    Default = true,
    Callback = function(state)
        getgenv().BlazenConfig.AutoSave = state
    end
})

SettingsTab:Button({
    Title = "Save Configuration",
    Callback = function()
        SaveConfig()
        Window:Notify({
            Title = "Settings",
            Content = "Configuration saved successfully!",
            Duration = 3
        })
    end
})

SettingsTab:Button({
    Title = "Load Configuration",
    Callback = function()
        if LoadConfig() then
            Window:Notify({
                Title = "Settings",
                Content = "Configuration loaded successfully!",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "Settings",
                Content = "No configuration file found!",
                Duration = 3
            })
        end
    end
})

SettingsTab:Space()

-- ========== INFO TAB ==========
local InfoTab = Window:Tab({
    Title = "Info",
})

InfoTab:Section({
    Title = "Blazen Hub Information",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
    Height = 200
})

InfoTab:Space()

InfoTab:Label({
    Text = "Version: 1.0.0",
})

InfoTab:Label({
    Text = "Developer: Blazen Team",
})

InfoTab:Label({
    Text = "Status: Active ✅",
})

InfoTab:Label({
    Text = "Features:",
})

InfoTab:Label({
    Text = "• Auto Fishing",
})

InfoTab:Label({
    Text = "• Blatant Mode (Minigame Bypass)",
})

InfoTab:Label({
    Text = "• Configuration System",
})

InfoTab:Space()

-- Initialize the system
task.spawn(function()
    wait(2)
    Window:Notify({
        Title = "Blazen Hub",
        Content = "Fishing Autofarm loaded successfully!",
        Duration = 5
    })
end)

-- Keybind to toggle UI
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        Window.ScreenGui.Enabled = not Window.ScreenGui.Enabled
    end
end)

print("🎣 Blazen Hub - Fishing Autofarm loaded!")
print("📁 Config loaded:", LoadConfig())
print("🎮 Press RightControl to toggle UI")