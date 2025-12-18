-- CONFIG: ubah sesuai kebutuhan
local AUTO_FISH_REMOTE_NAME = "UpdateAutoFishingState"
local NET_PACKAGES_FOLDER = "Packages"

-- Services & Variables
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local LocalPlayer = Players.LocalPlayer

-- Import required modules
local success, Signal = pcall(require, ReplicatedStorage.Packages.Signal)
local success2, Trove = pcall(require, ReplicatedStorage.Packages.Trove)
local success3, Net = pcall(require, ReplicatedStorage.Packages.Net)
local success4, spr = pcall(require, ReplicatedStorage.Packages.spr)
local success5, Constants = pcall(require, ReplicatedStorage.Shared.Constants)
local success6, Soundbook = pcall(require, ReplicatedStorage.Shared.Soundbook)
local success7, GuiControl = pcall(require, ReplicatedStorage.Modules.GuiControl)
local success8, HUDController = pcall(require, ReplicatedStorage.Controllers.HUDController)
local success9, AnimationController = pcall(require, ReplicatedStorage.Controllers.AnimationController)
local success10, TextNotificationController = pcall(require, ReplicatedStorage.Controllers.TextNotificationController)
local success11, BlockedHumanoidStates = pcall(require, ReplicatedStorage.Shared.BlockedHumanoidStates)

-- UI Variables
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Charge_upvr = PlayerGui:WaitForChild("Charge")
local Fishing_upvr = PlayerGui:WaitForChild("Fishing")
local Main_upvr = Fishing_upvr:WaitForChild("Main")
local CanvasGroup_upvr = Main_upvr:WaitForChild("Display"):WaitForChild("CanvasGroup")

-- Fishing status variables
local var17_upvw = nil -- Player Data
local var32_upvw = false -- Charge Started
local var34_upvw = false -- Is Stopped/Closing
local var35_upvw = nil -- Charge Start Time
local var36_upvw = nil -- Minigame UUID
local var37_upvw = nil -- Minigame State / Data
local var38_upvw = 0 -- Cooldown Time
local var40_upvw = nil -- Reel Sound Track
local var109_upvw = false -- Is Charging flag

local autoFishEnabled = false
local autoFishLoopThread = nil
local coordinateGui = nil
local statusParagraph = nil
local currentSelectedMap = nil

-- Player Configuration Variables
local antiLagEnabled = false
local savePositionEnabled = false
local lockPositionEnabled = false
local lastSavedPosition = nil
local lockPositionLoop = nil
local originalGraphicsSettings = {}

-- Bypass Variables
local fishingRadarEnabled = false
local divingGearEnabled = false
local autoSellEnabled = false
local autoSellThreshold = 3
local autoSellLoop = nil

-- Weather System Variables
local selectedWeathers = {}
local availableWeathers = {}

-- Trick or Treat Variables
local autoTrickTreatEnabled = false
local trickTreatLoop = nil

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
        -- Method 1: Coba via Net package
        local net = require(ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net)
        
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
        -- Method 2: Cari manual di ReplicatedStorage
        success = pcall(function()
            local remotes = {
                fishing = ReplicatedStorage:FindFirstChild("FishingCompleted") or ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("FishingCompleted"),
                charge = ReplicatedStorage:FindFirstChild("ChargeFishingRod") or ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("ChargeFishingRod"),
                minigame = ReplicatedStorage:FindFirstChild("RequestFishingMinigameStarted") or ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("RequestFishingMinigameStarted"),
                equip = ReplicatedStorage:FindFirstChild("EquipToolFromHotbar") or ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("EquipToolFromHotbar"),
                unequip = ReplicatedStorage:FindFirstChild("UnequipToolFromHotbar") or ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("UnequipToolFromHotbar")
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

-- Blatant Fishing Configuration
local blatantReelDelay = 0.5  -- Default delay reel
local blatantFishingDelay = 0.5  -- Delay antara fishing attempts

-- UI Configuration
local COLOR_ENABLED = Color3.fromRGB(76, 175, 80)  -- Green
local COLOR_DISABLED = Color3.fromRGB(244, 67, 54) -- Red
local COLOR_PRIMARY = Color3.fromRGB(103, 58, 183) -- Purple
local COLOR_SECONDARY = Color3.fromRGB(30, 30, 46)  -- Dark

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

-- =============================================================================
-- WELCOME POPUP - Tampilkan saat pertama kali execute script
-- =============================================================================
task.spawn(function()
    task.wait(1) -- Tunggu sebentar agar UI siap
    WindUI:Popup({
        Title = "Welcome",
        Icon = "fish",
        Content = "Terima kasih telah menggunakan AanHub\n\n" ..
                  "Fish It Automation System\n" ..
                  "Dilengkapi dengan Advanced Minigame Bypass\n\n" ..
                  "Nikmati pengalaman auto fishing yang lebih cepat, stabil, dan efisien.",
        Buttons = {
            {
                Title = "Get Started",
                Icon = "check",
                Callback = function()
                    print("AanHub successfully activated!")
                end
            }
        }
    })
end)

-- =============================================================================
-- ANTI AFK SYSTEM
-- =============================================================================
local antiAFKEnabled = false

-- 🛡️ Anti Kick + Auto Reconnect Full System
function AntiKickReconnect()
    if getgenv().AntiKick_Started then return end
    getgenv().AntiKick_Started = true

    -- 🔹 Cegah AFK Kick
    LocalPlayer.Idled:Connect(function()
        task.wait(1)
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("[SYSTEM] Anti-AFK aktif, mengirim aktivitas virtual ✅")
    end)

    -- 🔹 Cegah manual kick
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            warn("[SYSTEM] Kick terdeteksi dan diblokir ❌")
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)

    print("[SYSTEM] Anti Kick + Auto Reconnect aktif sepenuhnya 🚀")
end

local function ToggleAntiAFK(state)
    if state then
        antiAFKEnabled = true
        AntiKickReconnect()
        Notify({
            Title = "Anti AFK System", 
            Content = "Anti Kick + Auto Reconnect activated",
            Duration = 3
        })
    else
        antiAFKEnabled = false
        Notify({
            Title = "Anti AFK System", 
            Content = "Basic protection remains active for safety",
            Duration = 3
        })
    end
end

-- Auto-clean money icons
task.spawn(function()
    while task.wait(1) do
        for _, obj in ipairs(CoreGui:GetDescendants()) do
            if obj and (obj:IsA("ImageLabel") or obj:IsA("ImageButton") or obj:IsA("TextLabel")) then
                local nameLower = (obj.Name or ""):lower()
                local textLower = (obj.Text or ""):lower()
                if string.find(nameLower, "money") or string.find(textLower, "money") or string.find(nameLower, "100") then
                    pcall(function()
                        obj.Visible = false
                        if obj:IsA("GuiObject") then
                            obj.Active = false
                            obj.ZIndex = 0
                        end
                    end)
                end
            end
        end
    end
end)

-- Notification System
local function Notify(opts)
    pcall(function()
        WindUI:Notify({
            Title = opts.Title or "Notification",
            Content = opts.Content or "",
            Duration = opts.Duration or 3,
            Icon = opts.Icon or "info"
        })
    end)
end

-- =============================================================================
-- BLATANT FISHING SYSTEM - STABLE & CLEAN VERSION
-- =============================================================================

-- Default delay values (safe)
local blatantReelDelay = 0.15
local blatantFishingDelay = 0.35

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

local function InitializeBlatantFishing()
    local success = false

    pcall(function()
        success = AdvancedFishing.initializeNetwork()
    end)

    if success then
        AdvancedFishing.networkInitialized = true
        Notify({
            Title = "⚡ Blatant Fishing",
            Content = "Network initialized successfully",
            Duration = 3
        })
        return true
    else
        Notify({
            Title = "❌ Blatant Fishing Error",
            Content = "Failed to initialize network",
            Duration = 4
        })
        return false
    end
end

-- =============================================================================
-- CONFIG SETTERS
-- =============================================================================

local function SetBlatantReelDelay(delay)
    if type(delay) ~= "number" then return false end
    if delay < 0 or delay > 1.87 then return false end

    blatantReelDelay = delay

    Notify({
        Title = "⚡ Blatant Fishing",
        Content = string.format("Reel delay set to %.3f seconds", delay),
        Duration = 3
    })

    return true
end

local function SetBlatantFishingDelay(delay)
    if type(delay) ~= "number" then return false end
    if delay < 0 or delay > 5 then return false end

    blatantFishingDelay = delay

    Notify({
        Title = "⚡ Blatant Fishing",
        Content = string.format("Fishing loop delay set to %.3f seconds", delay),
        Duration = 3
    })

    return true
end

-- =============================================================================
-- BLATANT MODE TOGGLE
-- =============================================================================

local function ToggleBlatantMode(enable)
    if enable == AdvancedFishing.useBlatantMode then
        return
    end

    if enable then
        -- Initialize network if needed
        if not AdvancedFishing.networkInitialized then
            if not InitializeBlatantFishing() then
                return false
            end
        end

        AdvancedFishing.useBlatantMode = true

        AdvancedFishing.start({
            FishDelay  = blatantFishingDelay,
            CatchDelay = blatantReelDelay
        }, true)

        Notify({
            Title = "⚡ Blatant Fishing ENABLED",
            Content = "Fast fishing active\nMinigame Bypass: ON",
            Duration = 3
        })

    else
        AdvancedFishing.useBlatantMode = false
        AdvancedFishing.stop()

        Notify({
            Title = "⚡ Blatant Fishing DISABLED",
            Content = "System stopped safely",
            Duration = 3
        })
    end

    return true
end

-- =============================================================================
-- MANUAL CAST (TESTING)
-- =============================================================================

local function ManualBlatantFish()
    if not AdvancedFishing.useBlatantMode then
        Notify({
            Title = "⚠ Blatant Fishing",
            Content = "Enable Blatant Mode first",
            Duration = 3
        })
        return
    end

    pcall(function()
        if typeof(advancedCastRod) == "function" then
            advancedCastRod()
            Notify({
                Title = "⚡ Manual Cast",
                Content = "Casting rod with bypass...",
                Duration = 2
            })
        end
    end)
end

-- =============================================================================
-- AUTO FISH NETWORK HANDLER (SAFE)
-- =============================================================================

local function GetAutoFishRemote()
    local ok, NetModule = pcall(function()
        local folder = ReplicatedStorage:WaitForChild(NET_PACKAGES_FOLDER, 5)
        if folder then
            local net = folder:FindFirstChild("Net")
            if net and net:IsA("ModuleScript") then
                return require(net)
            end
        end

        if ReplicatedStorage:FindFirstChild("Packages") then
            local net = ReplicatedStorage.Packages:FindFirstChild("Net")
            if net and net:IsA("ModuleScript") then
                return require(net)
            end
        end
    end)

    return ok and NetModule or nil
end

local function SafeInvokeAutoFishing(state)
    pcall(function()
        local Net = GetAutoFishRemote()

        if Net and type(Net.RemoteFunction) == "function" then
            local ok, rf = pcall(function()
                return Net:RemoteFunction(AUTO_FISH_REMOTE_NAME)
            end)
            if ok and rf then
                rf:InvokeServer(state)
                return
            end
        end

        local rfObj =
            ReplicatedStorage:FindFirstChild(AUTO_FISH_REMOTE_NAME)
            or (ReplicatedStorage:FindFirstChild("RemoteFunctions")
                and ReplicatedStorage.RemoteFunctions:FindFirstChild(AUTO_FISH_REMOTE_NAME))

        if rfObj and rfObj:IsA("RemoteFunction") then
            rfObj:InvokeServer(state)
        end
    end)
end

-- =============================================================================
-- WEATHER MACHINE SYSTEM
-- =============================================================================

local function LoadWeatherData()
    local success, result = pcall(function()
        -- Load required modules
        local EventUtility = require(ReplicatedStorage.Shared.EventUtility)
        local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
        local Events = require(ReplicatedStorage.Events)
        
        local weatherList = {}
        
        -- Iterate through all events to find weather machines
        for name, data in pairs(Events) do
            local event = EventUtility:GetEvent(name)
            if event and event.WeatherMachine and event.WeatherMachinePrice then
                table.insert(weatherList, {
                    Name = event.Name or name,
                    InternalName = name,
                    Price = event.WeatherMachinePrice,
                    DisplayName = string.format("%s - %s Coins", event.Name or name, StringLibrary:AddCommas(event.WeatherMachinePrice))
                })
            end
        end
        
        -- Sort by price (ascending)
        table.sort(weatherList, function(a, b)
            return a.Price < b.Price
        end)
        
        return weatherList
    end)
    
    if success then
        return result
    else
        warn("⚠️ Failed to load weather data:", result)
        return {}
    end
end

local function PurchaseWeather(weatherName)
    local success, result = pcall(function()
        -- Load required modules
        local Net = require(ReplicatedStorage.Packages.Net)
        local PurchaseWeatherEvent = Net:RemoteFunction("PurchaseWeatherEvent")
        
        -- Purchase the weather
        local purchaseResult = PurchaseWeatherEvent:InvokeServer(weatherName)
        return purchaseResult
    end)
    
    return success, result
end

local function BuySelectedWeathers()
    if not next(selectedWeathers) then
        Notify({
            Title = "Weather Purchase",
            Content = "No weathers selected!",
            Duration = 3
        })
        return
    end
    
    local totalPurchases = 0
    local successfulPurchases = 0
    
    Notify({
        Title = "Weather Purchase",
        Content = "Processing purchases...",
        Duration = 2
    })
    
    for weatherName, selected in pairs(selectedWeathers) do
        if selected then
            totalPurchases = totalPurchases + 1
            
            -- Find weather data
            local weatherData
            for _, weather in ipairs(availableWeathers) do
                if weather.InternalName == weatherName then
                    weatherData = weather
                    break
                end
            end
            
            if weatherData then
                local success, result = PurchaseWeather(weatherName)
                if success and result then
                    successfulPurchases = successfulPurchases + 1
                    Notify({
                        Title = "✅ Purchase Successful",
                        Content = string.format("Bought: %s", weatherData.Name),
                        Duration = 3
                    })
                else
                    Notify({
                        Title = "❌ Purchase Failed",
                        Content = string.format("Failed to buy: %s", weatherData.Name),
                        Duration = 4
                    })
                end
            end
            
            -- Small delay between purchases
            task.wait(0.5)
        end
    end
    
    -- Clear selection after purchase
    selectedWeathers = {}
    
    Notify({
        Title = "Purchase Complete",
        Content = string.format("Successfully purchased %d/%d weathers", successfulPurchases, totalPurchases),
        Duration = 4
    })
end

local function RefreshWeatherList()
    availableWeathers = LoadWeatherData()
    
    -- Create display options for dropdown
    local weatherOptions = {}
    for _, weather in ipairs(availableWeathers) do
        table.insert(weatherOptions, weather.DisplayName)
    end
    
    return weatherOptions, availableWeathers
end

local function ToggleWeatherSelection(weatherIndex, state)
    if availableWeathers[weatherIndex] then
        local weather = availableWeathers[weatherIndex]
        selectedWeathers[weather.InternalName] = state
        
        Notify({
            Title = state and "✅ Weather Selected" or "❌ Weather Deselected",
            Content = string.format("%s %s", weather.Name, state and "selected" or "deselected"),
            Duration = 2
        })
    end
end

-- =============================================================================
-- TRICK OR TREAT SYSTEM
-- =============================================================================

local function GetSpecialDialogueRemote()
    local success, result = pcall(function()
        local Net = require(ReplicatedStorage.Packages.Net)
        local SpecialDialogueEvent = Net:RemoteFunction("SpecialDialogueEvent")
        return SpecialDialogueEvent
    end)
    
    if success then
        return result
    else
        warn("❌ Failed to load SpecialDialogueEvent:", result)
        return nil
    end
end

local function FindTrickOrTreatDoors()
    local doors = {}
    
    for _, door in pairs(workspace:GetDescendants()) do
        if door:IsA("Model") and door:FindFirstChild("Root") and door:FindFirstChild("Door") and door.Name then
            if door:GetAttribute("TrickOrTreatDoor") or string.find(door.Name, "House") then
                table.insert(doors, door)
            end
        end
    end
    
    return doors
end

local function KnockDoor(door)
    local success, result = pcall(function()
        local SpecialDialogueEvent = GetSpecialDialogueRemote()
        if not SpecialDialogueEvent then
            return false, "Remote not found"
        end
        
        local success, reward = SpecialDialogueEvent:InvokeServer(door.Name, "TrickOrTreatHouse")
        return success, reward
    end)
    
    return success, result
end

local function StartAutoTrickTreat()
    if autoTrickTreatEnabled then return end
    autoTrickTreatEnabled = true
    
    Notify({
        Title = "🎃 Auto Trick or Treat",
        Content = "System activated - Knocking all doors...",
        Duration = 3
    })
    
    trickTreatLoop = task.spawn(function()
        while autoTrickTreatEnabled do
            local doors = FindTrickOrTreatDoors()
            
            if #doors > 0 then
                Notify({
                    Title = "🎃 Trick or Treat",
                    Content = string.format("Found %d doors, knocking...", #doors),
                    Duration = 2
                })
                
                for _, door in ipairs(doors) do
                    if not autoTrickTreatEnabled then break end
                    
                    local success, result = KnockDoor(door)
                    if success then
                        if result == "Trick" then
                            print("[🎃] Trick dari " .. door.Name)
                        elseif result == "Treat" then
                            print("[🍬] Treat dari " .. door.Name .. " → +" .. tostring(result) .. " Candy Corns")
                        else
                            print("[❌] Gagal interaksi dengan " .. door.Name)
                        end
                    else
                        print("[❌] Error knocking " .. door.Name .. ": " .. tostring(result))
                    end
                    
                    task.wait(0.5) -- Jeda biar gak spam server
                end
            else
                print("[🔍] Tidak ada Trick or Treat doors yang ditemukan")
            end
            
            -- Tunggu sebelum scan ulang
            task.wait(10)
        end
    end)
end

local function StopAutoTrickTreat()
    if not autoTrickTreatEnabled then return end
    autoTrickTreatEnabled = false
    
    if trickTreatLoop then
        task.cancel(trickTreatLoop)
        trickTreatLoop = nil
    end
    
    Notify({
        Title = "🎃 Auto Trick or Treat",
        Content = "System deactivated",
        Duration = 2
    })
end

local function ManualKnockAllDoors()
    local doors = FindTrickOrTreatDoors()
    
    if #doors == 0 then
        Notify({
            Title = "🎃 Trick or Treat",
            Content = "No Trick or Treat doors found!",
            Duration = 3
        })
        return
    end
    
    Notify({
        Title = "🎃 Manual Knock",
        Content = string.format("Knocking %d doors...", #doors),
        Duration = 2
    })
    
    local successfulKnocks = 0
    local totalCandy = 0
    
    for _, door in ipairs(doors) do
        local success, result = KnockDoor(door)
        if success then
            successfulKnocks = successfulKnocks + 1
            if result == "Treat" then
                totalCandy = totalCandy + 1
            end
        end
        task.wait(0.5)
    end
    
    Notify({
        Title = "🎃 Knock Complete",
        Content = string.format("Success: %d/%d doors | Candy: +%d", successfulKnocks, #doors, totalCandy),
        Duration = 4
    })
end

-- Auto Fishing System menggunakan modul baru
local function StartAutoFish()
    if autoFishEnabled then return end
    autoFishEnabled = true
    Notify({Title = "Auto Fishing", Content = "System activated successfully", Duration = 2})

    -- Start fishing dengan mode normal
    local config = {
        FishDelay = 4,
        CatchDelay = 2
    }
    
    AdvancedFishing.start(config, false)
end

local function StopAutoFish()
    if not autoFishEnabled then return end
    autoFishEnabled = false
    Notify({Title = "Auto Fishing", Content = "System deactivated", Duration = 2})
    
    AdvancedFishing.stop()
end

-- =============================================================================
-- ULTRA ANTI LAG SYSTEM - WHITE TEXTURE MODE
-- =============================================================================

-- Save original graphics settings
local function SaveOriginalGraphics()
    originalGraphicsSettings = {
        GraphicsQualityLevel = UserGameSettings.GraphicsQualityLevel,
        SavedQualityLevel = UserGameSettings.SavedQualityLevel,
        MasterVolume = Lighting.GlobalShadows,
        Brightness = Lighting.Brightness,
        FogEnd = Lighting.FogEnd,
        ShadowSoftness = Lighting.ShadowSoftness,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
    }
end

-- Ultra Anti Lag System - White Texture Mode
local function EnableAntiLag()
    if antiLagEnabled then return end
    
    SaveOriginalGraphics()
    antiLagEnabled = true
    
    -- Extreme graphics optimization with white textures
    pcall(function()
        -- Graphics quality settings
        UserGameSettings.GraphicsQualityLevel = 1
        UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        
        -- Lighting optimization - Bright white environment
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 999999
        Lighting.Brightness = 5  -- Extra bright
        Lighting.ShadowSoftness = 0
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 0
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)  -- Pure white ambient
        Lighting.Ambient = Color3.new(1, 1, 1)  -- Pure white
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        
        -- Terrain optimization - White terrain
        if workspace.Terrain then
            workspace.Terrain.Decoration = false
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterTransparency = 1
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterWaveSpeed = 0
        end
        
        -- Make all parts white and disable effects
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                -- Set all parts to white
                if obj:FindFirstChildOfClass("Texture") then
                    obj:FindFirstChildOfClass("Texture"):Destroy()
                end
                if obj:FindFirstChildOfClass("Decal") then
                    obj:FindFirstChildOfClass("Decal"):Destroy()
                end
                obj.Material = Enum.Material.SmoothPlastic
                obj.BrickColor = BrickColor.new("White")
                obj.Reflectance = 0
            elseif obj:IsA("ParticleEmitter") then
                obj.Enabled = false
            elseif obj:IsA("Fire") then
                obj.Enabled = false
            elseif obj:IsA("Smoke") then
                obj.Enabled = false
            elseif obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("Beam") then
                obj.Enabled = false
            elseif obj:IsA("Trail") then
                obj.Enabled = false
            elseif obj:IsA("Sound") and not obj:FindFirstAncestorWhichIsA("Player") then
                obj:Stop()
            end
        end
        
        -- Reduce texture quality to minimum
        settings().Rendering.QualityLevel = 1
    end)
    
    Notify({Title = "Ultra Anti Lag", Content = "White texture mode enabled - Maximum performance", Duration = 3})
end

local function DisableAntiLag()
    if not antiLagEnabled then return end
    antiLagEnabled = false
    
    -- Restore original graphics settings
    pcall(function()
        if originalGraphicsSettings.GraphicsQualityLevel then
            UserGameSettings.GraphicsQualityLevel = originalGraphicsSettings.GraphicsQualityLevel
        end
        if originalGraphicsSettings.SavedQualityLevel then
            UserGameSettings.SavedQualityLevel = originalGraphicsSettings.SavedQualityLevel
        end
        if originalGraphicsSettings.MasterVolume ~= nil then
            Lighting.GlobalShadows = originalGraphicsSettings.MasterVolume
        end
        if originalGraphicsSettings.Brightness then
            Lighting.Brightness = originalGraphicsSettings.Brightness
        end
        if originalGraphicsSettings.FogEnd then
            Lighting.FogEnd = originalGraphicsSettings.FogEnd
        end
        if originalGraphicsSettings.ShadowSoftness then
            Lighting.ShadowSoftness = originalGraphicsSettings.ShadowSoftness
        end
        if originalGraphicsSettings.EnvironmentDiffuseScale then
            Lighting.EnvironmentDiffuseScale = originalGraphicsSettings.EnvironmentDiffuseScale
        end
        if originalGraphicsSettings.EnvironmentSpecularScale then
            Lighting.EnvironmentSpecularScale = originalGraphicsSettings.EnvironmentSpecularScale
        end
        
        -- Restore terrain
        if workspace.Terrain then
            workspace.Terrain.Decoration = true
            workspace.Terrain.WaterReflectance = 0.5
            workspace.Terrain.WaterTransparency = 0.5
            workspace.Terrain.WaterWaveSize = 0.5
            workspace.Terrain.WaterWaveSpeed = 10
        end
        
        -- Restore lighting
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        
        -- Restore texture quality
        settings().Rendering.QualityLevel = 10
    end)
    
    Notify({Title = "Anti Lag", Content = "Graphics settings restored", Duration = 3})
end

-- Position Management System
local function SaveCurrentPosition()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        lastSavedPosition = character.HumanoidRootPart.Position
        Notify({
            Title = "Position Saved", 
            Content = string.format("Position saved successfully"),
            Duration = 2
        })
        return true
    end
    return false
end

local function LoadSavedPosition()
    if not lastSavedPosition then
        Notify({Title = "Load Failed", Content = "No position saved", Duration = 2})
        return false
    end
    
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(lastSavedPosition)
        Notify({Title = "Position Loaded", Content = "Teleported to saved position", Duration = 2})
        return true
    end
    return false
end

local function StartLockPosition()
    if lockPositionEnabled then return end
    lockPositionEnabled = true
    
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        lastSavedPosition = character.HumanoidRootPart.Position
    end
    
    lockPositionLoop = RunService.Heartbeat:Connect(function()
        if not lockPositionEnabled then return end
        
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") and lastSavedPosition then
            local currentPos = character.HumanoidRootPart.Position
            local distance = (currentPos - lastSavedPosition).Magnitude
            
            if distance > 3 then
                character.HumanoidRootPart.CFrame = CFrame.new(lastSavedPosition)
            end
        end
    end)
    
    Notify({Title = "Position Lock", Content = "Player position locked", Duration = 2})
end

local function StopLockPosition()
    if not lockPositionEnabled then return end
    lockPositionEnabled = false
    
    if lockPositionLoop then
        lockPositionLoop:Disconnect()
        lockPositionLoop = nil
    end
    
    Notify({Title = "Position Lock", Content = "Player position unlocked", Duration = 2})
end

-- =============================================================================
-- BYPASS SYSTEM - FISHING RADAR, DIVING GEAR & AUTO SELL
-- =============================================================================

-- Fishing Radar System
local function ToggleFishingRadar()
    local success, result = pcall(function()
        -- Load required modules
        local Replion = require(ReplicatedStorage.Packages.Replion)
        local Net = require(ReplicatedStorage.Packages.Net)
        local UpdateFishingRadar = Net:RemoteFunction("UpdateFishingRadar")
        
        -- Get player data
        local Data = Replion.Client:WaitReplion("Data")
        if not Data then
            return false, "Data Replion tidak ditemukan!"
        end

        -- Get current radar state
        local currentState = Data:Get("RegionsVisible")
        local desiredState = not currentState

        -- Invoke server to update radar
        local invokeSuccess = UpdateFishingRadar:InvokeServer(desiredState)
        
        if invokeSuccess then
            fishingRadarEnabled = desiredState
            return true, "Radar: " .. (desiredState and "ENABLED" or "DISABLED")
        else
            return false, "Failed to update radar"
        end
    end)
    
    if success then
        return true, result
    else
        return false, "Error: " .. tostring(result)
    end
end

local function StartFishingRadar()
    if fishingRadarEnabled then return end
    
    local success, message = ToggleFishingRadar()
    if success then
        fishingRadarEnabled = true
        Notify({Title = "Fishing Radar", Content = message, Duration = 3})
    else
        Notify({Title = "Radar Error", Content = message, Duration = 4})
    end
end

local function StopFishingRadar()
    if not fishingRadarEnabled then return end
    
    local success, message = ToggleFishingRadar()
    if success then
        fishingRadarEnabled = false
        Notify({Title = "Fishing Radar", Content = message, Duration = 3})
    else
        Notify({Title = "Radar Error", Content = message, Duration = 4})
    end
end

-- Diving Gear System
local function ToggleDivingGear()
    local success, result = pcall(function()
        -- Load required modules
        local Net = require(ReplicatedStorage.Packages.Net)
        local Replion = require(ReplicatedStorage.Packages.Replion)
        local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
        
        -- Get diving gear data
        local DivingGear = ItemUtility.GetItemDataFromItemType("Gears", "Diving Gear")
        if not DivingGear then
            return false, "Diving Gear tidak ditemukan!"
        end

        -- Get player data
        local Data = Replion.Client:WaitReplion("Data")
        if not Data then
            return false, "Data Replion tidak ditemukan!"
        end

        -- Get remote functions
        local UnequipOxygenTank = Net:RemoteFunction("UnequipOxygenTank")
        local EquipOxygenTank = Net:RemoteFunction("EquipOxygenTank")

        -- Check current equipment state
        local EquippedId = Data:Get("EquippedOxygenTankId")
        local isEquipped = EquippedId == DivingGear.Data.Id
        local success

        -- Toggle equipment
        if isEquipped then
            success = UnequipOxygenTank:InvokeServer()
        else
            success = EquipOxygenTank:InvokeServer(DivingGear.Data.Id)
        end

        if success then
            divingGearEnabled = not isEquipped
            return true, "Diving Gear: " .. (not isEquipped and "ON" or "OFF")
        else
            return false, "Failed to toggle diving gear"
        end
    end)
    
    if success then
        return true, result
    else
        return false, "Error: " .. tostring(result)
    end
end

local function StartDivingGear()
    if divingGearEnabled then return end
    
    local success, message = ToggleDivingGear()
    if success then
        divingGearEnabled = true
        Notify({Title = "Diving Gear", Content = message, Duration = 3})
    else
        Notify({Title = "Diving Gear Error", Content = message, Duration = 4})
    end
end

local function StopDivingGear()
    if not divingGearEnabled then return end
    
    local success, message = ToggleDivingGear()
    if success then
        divingGearEnabled = false
        Notify({Title = "Diving Gear", Content = message, Duration = 3})
    else
        Notify({Title = "Diving Gear Error", Content = message, Duration = 4})
    end
end

-- Auto Sell System
local function ManualSellAllFish()
    local success, result = pcall(function()
        local VendorController = require(ReplicatedStorage.Controllers.VendorController)
        if VendorController and VendorController.SellAllItems then
            VendorController:SellAllItems()
            return true, "All fish sold successfully!"
        else
            return false, "VendorController not found"
        end
    end)
    
    if success then
        Notify({Title = "Manual Sell", Content = result, Duration = 3})
    else
        Notify({Title = "Sell Error", Content = result, Duration = 4})
    end
end

local function StartAutoSell()
    if autoSellEnabled then return end
    autoSellEnabled = true
    
    autoSellLoop = task.spawn(function()
        while autoSellEnabled do
            pcall(function()
                local Replion = require(ReplicatedStorage.Packages.Replion)
                local Data = Replion.Client:WaitReplion("Data")
                local VendorController = require(ReplicatedStorage.Controllers.VendorController)
                
                if Data and VendorController and VendorController.SellAllItems then
                    local inventory = Data:Get("Inventory")
                    if inventory and inventory.Fish then
                        local fishCount = 0
                        for _, fish in pairs(inventory.Fish) do
                            fishCount = fishCount + (fish.Amount or 1)
                        end
                        
                        if fishCount >= autoSellThreshold then
                            VendorController:SellAllItems()
                            Notify({
                                Title = "Auto Sell", 
                                Content = string.format("Sold %d fish automatically", fishCount),
                                Duration = 2
                            })
                        end
                    end
                end
            end)
            task.wait(2) -- Check every 2 seconds
        end
    end)
    
    Notify({
        Title = "Auto Sell Started", 
        Content = string.format("Auto selling when fish count >= %d", autoSellThreshold),
        Duration = 3
    })
end

local function StopAutoSell()
    if not autoSellEnabled then return end
    autoSellEnabled = false
    
    if autoSellLoop then
        task.cancel(autoSellLoop)
        autoSellLoop = nil
    end
    
    Notify({Title = "Auto Sell", Content = "Auto sell stopped", Duration = 2})
end

local function SetAutoSellThreshold(amount)
    if type(amount) == "number" and amount > 0 then
        autoSellThreshold = amount
        Notify({
            Title = "Auto Sell Threshold", 
            Content = string.format("Threshold set to %d fish", amount),
            Duration = 3
        })
        return true
    end
    return false
end

-- Auto Radar Toggle with safety
local function SafeToggleRadar()
    local success, message = ToggleFishingRadar()
    if success then
        Notify({Title = "Fishing Radar", Content = message, Duration = 3})
    else
        Notify({Title = "Radar Error", Content = message, Duration = 4})
    end
end

-- Auto Diving Gear Toggle with safety
local function SafeToggleDivingGear()
    local success, message = ToggleDivingGear()
    if success then
        Notify({Title = "Diving Gear", Content = message, Duration = 3})
    else
        Notify({Title = "Diving Gear Error", Content = message, Duration = 4})
    end
end

-- Coordinate Display System
local function CreateCoordinateDisplay()
    if coordinateGui and coordinateGui.Parent then coordinateGui:Destroy() end
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "Anggazyy_Coordinates"
    sg.ResetOnSpawn = false
    sg.Parent = CoreGui

    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 220, 0, 40)
    frame.Position = UDim2.new(0.5, -110, 0, 15)
    frame.BackgroundColor3 = COLOR_SECONDARY
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0.3, 0)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = COLOR_PRIMARY
    stroke.Thickness = 1.6

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -12, 1, 0)
    label.Position = UDim2.new(0, 6, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(235, 235, 245)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.Text = "X: 0 | Y: 0 | Z: 0"
    label.TextXAlignment = Enum.TextXAlignment.Left

    coordinateGui = sg

    task.spawn(function()
        while coordinateGui and coordinateGui.Parent do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                label.Text = string.format("X: %d | Y: %d | Z: %d", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
            else
                label.Text = "X: - | Y: - | Z: -"
            end
            task.wait(0.12)
        end
    end)
end

local function DestroyCoordinateDisplay()
    if coordinateGui and coordinateGui.Parent then
        pcall(function() coordinateGui:Destroy() end)
        coordinateGui = nil
    end
end

-- =============================================================================
-- WINDUI MAIN WINDOW CREATION
-- =============================================================================

-- Create Main Window
local Window = WindUI:CreateWindow({
Title = "AanHub - Fish It",
Author = "by Aan • Premium Automation",
Folder = "AanHub",
Icon = "fish",
NewElements = true,
HideSearchBar = false,  
  
OpenButton = {  
    Title = "Open AanHub",  
    CornerRadius = UDim.new(1, 0),  
    StrokeThickness = 3,  
    Enabled = true,  
    Draggable = true,  
    OnlyMobile = false,  
      
    Color = ColorSequence.new(  
        Color3.fromHex("#6b31ff"),   
        Color3.fromHex("#30a2ff")  
    )  
}
})

-- Add version tag
Window:Tag({
Title = "v1.0-beta",
Icon = "github",
Color = Color3.fromHex("#6b31ff")
})

-- ========== ABOUT US TAB ==========
local AboutTab = Window:Tab({
Title = "About Us",
Icon = "info",
})

local AboutSection = AboutTab:Section({
Title = "About AanHub",
})

AboutSection:Image({
Image = "https://files.catbox.moe/of2fla.jpg",
AspectRatio = "16:9",
Radius = 9,
})

AboutSection:Space({ Columns = 3 })

AboutSection:Section({
Title = "What Is AanHub?",
TextSize = 24,
FontWeight = Enum.FontWeight.SemiBold,
})

AboutSection:Space()

AboutSection:Section({
Title = [[AanHub adalah script premium yang dirancang khusus untuk game Fish It di Roblox.
Dikembangkan dengan fokus pada automasi dan optimasi gameplay untuk memberikan pengalaman terbaik.

✨ **Fitur Utama:**
• Auto Fishing System – Sistem memancing otomatis yang cerdas
• Weather Machine – Manajemen dan pembelian cuaca secara efisien
• Bypass Features – Fitur canggih untuk meningkatkan gameplay
• Player Configuration – Optimasi performa dan kontrol karakter
• Mobile-Friendly UI – Antarmuka responsif untuk semua perangkat

🛡️ **Keunggulan:**
• 100% aman dan stabil
• Update berkala dengan fitur terbaru
• Dukungan untuk berbagai perangkat
• UI intuitif dan mudah digunakan

📌 **Catatan:**
Script ini sepenuhnya gratis dan tidak diperjualbelikan.
Dikembangkan untuk komunitas dengan tujuan membantu pemain menikmati gameplay yang lebih optimal.]],
TextSize = 16,
TextTransparency = 0.35,
FontWeight = Enum.FontWeight.Medium,
})

AboutTab:Space({ Columns = 4 })
-- ========== AUTO SYSTEM TAB ==========
local AutoTab = Window:Tab({
    Title = "Automation",
    Icon = "fish",
})

-- Main Fishing System
AutoTab:Section({
    Title = "🎣 Auto Fishing System",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
})

AutoTab:Space()

AutoTab:Toggle({
    Title = "Enable Auto Fishing",
    Desc = "Mulai sistem pemancingan otomatis dengan komunikasi server",
    Flag = "AutoFishToggle",
    Default = false,
    Callback = function(state)
        if state then
            StartAutoFish()
        else
            StopAutoFish()
        end
    end
})

AutoTab:Space()

-- Advanced Fishing Section
AutoTab:Section({
    Title = "⚡ Advanced Fishing",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
})

AutoTab:Toggle({
    Title = "Fast Mode",
    Desc = "Mode cepat dengan bypass minigame (blatant)",
    Flag = "BlatantModeToggle",
    Default = false,
    Callback = function(state)
        ToggleBlatantMode(state)
    end
})

AutoTab:Slider({
    Title = "Reel Delay",
    Desc = "Delay sebelum menarik ikan (0 - 1.87 detik)",
    Flag = "BlatantReelDelay",
    Step = 0.01,
    Value = {
        Min = 0,
        Max = 1.87,
        Default = 0.5,
    },
    Callback = function(value)
        SetBlatantReelDelay(value)
    end
})

AutoTab:Slider({
    Title = "Fishing Delay",
    Desc = "Delay antar percobaan memancing (loop cepat)",
    Flag = "BlatantFishingDelay",
    Step = 0.001,
    Value = {
        Min = 0,
        Max = 0.1,
        Default = 0.0015,
    },
    Callback = function(value)
        SetBlatantFishingDelay(value)
    end
})

AutoTab:Space()

-- Control Buttons Section
AutoTab:Section({
    Title = "🛠️ System Control",
    TextSize = 18,
    FontWeight = Enum.FontWeight.Medium,
})

AutoTab:Button({
    Title = "Initialize System",
    Icon = "zap",
    Desc = "Inisialisasi sistem fishing advanced",
    Callback = function()
        InitializeBlatantFishing()
    end
})

AutoTab:Button({
    Title = "Manual Cast",
    Icon = "fishing-rod",
    Desc = "Lempar kail secara manual",
    Callback = ManualBlatantFish
})

AutoTab:Space()

-- ========== WEATHER MACHINE TAB ==========
local WeatherTab = Window:Tab({
    Title = "Weather Machine",
    Icon = "cloud",
})

WeatherTab:Section({
    Title = "Weather Machine",
    Desc = "Purchase and activate different weather events",
})

-- Load weather data initially
availableWeathers = LoadWeatherData()

-- Weather Selection Toggles
for index, weather in ipairs(availableWeathers) do
    WeatherTab:Toggle({
        Title = weather.DisplayName,
        Flag = "WeatherToggle_" .. weather.InternalName,
        Default = false,
        Callback = function(state)
            ToggleWeatherSelection(index, state)
        end
    })
    
    if index < #availableWeathers then
        WeatherTab:Space()
    end
end

WeatherTab:Space({ Columns = 2 })

WeatherTab:Button({
    Title = "Buy Selected Weathers",
    Icon = "shopping-cart",
    Justify = "Center",
    Callback = BuySelectedWeathers
})

WeatherTab:Button({
    Title = "Refresh Weather List",
    Icon = "refresh-cw",
    Justify = "Center",
    Callback = function()
        local newOptions, newWeathers = RefreshWeatherList()
        Notify({
            Title = "Weather List Updated",
            Content = string.format("Loaded %d available weathers", #newWeathers),
            Duration = 3
        })
    end
})

-- ========== BYPASS TAB ==========
local BypassTab = Window:Tab({
    Title = "Bypass",
    Icon = "radar",
})

BypassTab:Section({
    Title = "Game Bypass Features",
    Desc = "Advanced features to enhance gameplay",
})

-- Fishing Radar Section
BypassTab:Section({
    Title = "Fishing Radar",
    TextSize = 18,
    FontWeight = Enum.FontWeight.SemiBold,
})

BypassTab:Toggle({
    Title = "Fishing Radar",
    Flag = "FishingRadarToggle",
    Default = false,
    Callback = function(state)
        if state then
            StartFishingRadar()
        else
            StopFishingRadar()
        end
    end
})

BypassTab:Button({
    Title = "Toggle Radar",
    Icon = "radar",
    Callback = SafeToggleRadar
})

BypassTab:Space()

-- Diving Gear Section
BypassTab:Section({
    Title = "Diving Gear",
    TextSize = 18,
    FontWeight = Enum.FontWeight.SemiBold,
})

BypassTab:Toggle({
    Title = "Diving Gear",
    Flag = "DivingGearToggle",
    Default = false,
    Callback = function(state)
        if state then
            StartDivingGear()
        else
            StopDivingGear()
        end
    end
})

BypassTab:Button({
    Title = "Toggle Diving Gear",
    Icon = "diving",
    Callback = SafeToggleDivingGear
})

BypassTab:Space()

-- Auto Sell Section
BypassTab:Section({
    Title = "Auto Sell Fish",
    TextSize = 18,
    FontWeight = Enum.FontWeight.SemiBold,
})

BypassTab:Toggle({
    Title = "Auto Sell Fish",
    Desc = "Automatically sell fish when threshold is reached",
    Flag = "AutoSellToggle",
    Default = false,
    Callback = function(state)
        if state then
            StartAutoSell()
        else
            StopAutoSell()
        end
    end
})

BypassTab:Slider({
    Title = "Sell Threshold",
    Desc = "Minimum fish count to trigger auto sell",
    Flag = "AutoSellThreshold",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 3,
    },
    Callback = function(value)
        SetAutoSellThreshold(value)
    end
})

BypassTab:Button({
    Title = "Sell All Fish Now",
    Icon = "dollar-sign",
    Callback = ManualSellAllFish
})

BypassTab:Space()

-- Trick or Treat Section
BypassTab:Section({
    Title = "🎃 Trick or Treat",
    TextSize = 18,
    FontWeight = Enum.FontWeight.SemiBold,
})

BypassTab:Toggle({
    Title = "Auto Trick or Treat",
    Desc = "Automatically knocks on all Trick or Treat doors",
    Flag = "AutoTrickTreatToggle",
    Default = false,
    Callback = function(state)
        if state then
            StartAutoTrickTreat()
        else
            StopAutoTrickTreat()
        end
    end
})

BypassTab:Button({
    Title = "Knock All Doors Now",
    Icon = "door-open",
    Callback = ManualKnockAllDoors
})

BypassTab:Space()

-- Quick Actions Section
BypassTab:Section({
    Title = "Quick Actions",
    TextSize = 18,
    FontWeight = Enum.FontWeight.SemiBold,
})

BypassTab:Button({
    Title = "Enable All Bypass",
    Icon = "play",
    Color = Color3.fromHex("#30ff6a"),
    Justify = "Center",
    Callback = function()
        StartFishingRadar()
        StartDivingGear()
        StartAutoSell()
        StartAutoTrickTreat()
        Notify({Title = "Bypass", Content = "All bypass features enabled", Duration = 3})
    end
})

BypassTab:Button({
    Title = "Disable All Bypass",
    Icon = "square",
    Color = Color3.fromHex("#ff4830"),
    Justify = "Center",
    Callback = function()
        StopFishingRadar()
        StopDivingGear()
        StopAutoSell()
        StopAutoTrickTreat()
        Notify({Title = "Bypass", Content = "All bypass features disabled", Duration = 3})
    end
})

-- ========== PLAYER CONFIGURATION TAB ==========
local PlayerConfigTab = Window:Tab({
    Title = "Player Config",
    Icon = "settings",
})

-- Performance Section
PlayerConfigTab:Section({
    Title = "Performance",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
})

PlayerConfigTab:Toggle({
    Title = "Ultra Anti Lag",
    Desc = "White texture mode for maximum performance",
    Flag = "AntiLagToggle",
    Default = false,
    Callback = function(state)
        if state then
            EnableAntiLag()
        else
            DisableAntiLag()
        end
    end
})

PlayerConfigTab:Space()

-- Anti AFK Section - DITAMBAHKAN DI PLAYER CONFIG
PlayerConfigTab:Section({
    Title = "Anti AFK System",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
})

PlayerConfigTab:Toggle({
    Title = "Anti AFK + Auto Reconnect",
    Desc = "Prevent AFK kick and auto reconnect if disconnected",
    Flag = "AntiAFKToggle",
    Default = false,
    Callback = function(state)
        ToggleAntiAFK(state)
    end
})

PlayerConfigTab:Space()

-- Position Section
PlayerConfigTab:Section({
    Title = "Position Management",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
})

PlayerConfigTab:Button({
    Title = "Save Position",
    Icon = "bookmark",
    Callback = SaveCurrentPosition
})

PlayerConfigTab:Button({
    Title = "Load Position",
    Icon = "navigation",
    Callback = LoadSavedPosition
})

PlayerConfigTab:Toggle({
    Title = "Lock Position",
    Desc = "Prevent movement from saved position",
    Flag = "LockPositionToggle",
    Default = false,
    Callback = function(state)
        if state then
            StartLockPosition()
        else
            StopLockPosition()
        end
    end
})

PlayerConfigTab:Space()

-- Movement Configuration - DIPINDAHKAN DARI PLAYER STATS
PlayerConfigTab:Section({
    Title = "Movement Configuration",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
})

PlayerConfigTab:Slider({
    Title = "Walk Speed",
    Desc = "Adjust player movement speed",
    Flag = "WalkSpeed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end
})

PlayerConfigTab:Slider({
    Title = "Jump Power",
    Desc = "Adjust player jump height",
    Flag = "JumpPower",
    Step = 1,
    Value = {
        Min = 50,
        Max = 350,
        Default = 50,
    },
    Callback = function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = val
        end
    end
})

PlayerConfigTab:Button({
    Title = "Reset Movement",
    Icon = "refresh-cw",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Notify({Title = "Reset", Content = "Movement reset to default", Duration = 2})
        end
    end
})

PlayerConfigTab:Space()

-- Quick Actions
PlayerConfigTab:Section({
    Title = "Quick Actions",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
})

PlayerConfigTab:Button({
    Title = "Max Performance",
    Icon = "zap",
    Color = Color3.fromHex("#30a2ff"),
    Justify = "Center",
    Callback = function()
        EnableAntiLag()
        ToggleAntiAFK(true)
        Notify({Title = "Performance", Content = "Maximum performance enabled", Duration = 2})
    end
})

-- ========== TELEPORTATION TAB ==========
local TeleportTab = Window:Tab({
    Title = "Teleportation",
    Icon = "map-pin",
})

TeleportTab:Section({
    Title = "Location Teleport",
    Desc = "Quick teleport to fishing spots",
})

-- DROPDOWN UNTUK MAP TELEPORT - DITAMBAHKAN LOKASI BARU
TeleportTab:Dropdown({
    Title = "Select Destination",
    Flag = "MapSelect",
    Values = {
        "Kohana",
        "Kohana Volcano", 
        "Lost Isle",
        "Coral Fish",
        "Tropical Grove",
        "Crater Island",
        "Esoteric Depth",
        "Ancient Jungle",
        "Sacred Temple",
        "Undground Cellar",
        "Fishermand Iland"
    },
    Value = "Kohana",
    Callback = function(selected)
        currentSelectedMap = selected
    end
})

-- BUTTON TELEPORT - DITAMBAHKAN FUNGSI TELEPORT KE LOKASI BARU
TeleportTab:Button({
    Title = "Teleport Now",
    Icon = "navigation",
    Callback = function()
        local targetPosition
        
        -- Tentukan posisi berdasarkan pilihan
        if currentSelectedMap == "Kohana" then
            targetPosition = Vector3.new(-637, 16, 626)
        elseif currentSelectedMap == "Kohana Volcano" then
            targetPosition = Vector3.new(-607, 48, 167)
        elseif currentSelectedMap == "Lost Isle" then
            targetPosition = Vector3.new(-3706, -136, -1014)
        elseif currentSelectedMap == "Coral Fish" then
            targetPosition = Vector3.new(-2923, 3, 2080)
        elseif currentSelectedMap == "Tropical Grove" then
            targetPosition = Vector3.new(-2053, 6, 3665)
        elseif currentSelectedMap == "Crater Island" then
            targetPosition = Vector3.new(997, 2, 5010)
        elseif currentSelectedMap == "Esoteric Depth" then
            targetPosition = Vector3.new(3252, -1301, 1392)
        elseif currentSelectedMap == "Ancient Jungle" then
            targetPosition = Vector3.new(1329, 7, -248)
        elseif currentSelectedMap == "Sacred Temple" then
            targetPosition = Vector3.new(1485, 7, -550)
        elseif currentSelectedMap == "Undground Cellar" then
            targetPosition = Vector3.new(2021, -92, -570)
        elseif currentSelectedMap == "Fishermand Iland" then
            targetPosition = Vector3.new(-26, 9, 2688)
        else
            -- Default position jika tidak ada yang cocok
            targetPosition = Vector3.new(-637, 16, 626)
        end
        
        -- Eksekusi teleport
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
            Notify({
                Title = "Teleport Success", 
                Content = string.format("Teleported to %s", currentSelectedMap),
                Duration = 3
            })
        else
            Notify({
                Title = "Teleport Failed",
                Content = "Character not found",
                Duration = 3
            })
        end
    end
})

TeleportTab:Toggle({
    Title = "Show Coordinates",
    Desc = "Display current position coordinates",
    Flag = "ShowCoords",
    Default = false,
    Callback = function(v)
        if v then
            CreateCoordinateDisplay()
        else
            DestroyCoordinateDisplay()
        end
    end
})

-- ========== SETTINGS TAB ==========
local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings-2",
})

-- Unload Hub Button
SettingsTab:Button({
    Title = "Unload Hub",
    Icon = "power",
    Color = Color3.fromHex("#ff4830"),
    Justify = "Center",
    Callback = function()
        StopAutoFish()
        StopLockPosition()
        DisableAntiLag()
        StopFishingRadar()
        StopDivingGear()
        StopAutoSell()
        StopAutoTrickTreat()
        ToggleBlatantMode(false)
        DestroyCoordinateDisplay()
        Window:Destroy()
        Notify({
            Title = "Unload",
            Content = "AanHub unloaded successfully",
            Duration = 2
        })
    end
})

-- Clean UI Button
SettingsTab:Button({
    Title = "Clean UI",
    Icon = "trash-2",
    Justify = "Center",
    Callback = function()
        for _, obj in ipairs(CoreGui:GetDescendants()) do
            pcall(function()
                if (obj:IsA("ImageLabel") or obj:IsA("ImageButton") or obj:IsA("TextLabel")) then
                    local name = (obj.Name or ""):lower()
                    local text = (obj.Text or ""):lower()
                    if string.find(name, "money") or string.find(text, "money") then
                        obj.Visible = false
                    end
                end
            end)
        end
        Notify({
            Title = "Clean",
            Content = "UI cleaned successfully",
            Duration = 2
        })
    end
})

-- Initial Notification
Notify({
    Title = "AanHub Ready",
    Content = "WindUI system initialized successfully with Advanced Minigame Bypass",
    Duration = 4
})

--//////////////////////////////////////////////////////////////////////////////////
-- WindUI System Initialization Complete
--//////////////////////////////////////////////////////////////////////////////////