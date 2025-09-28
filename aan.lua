-- Main GUI - By ChatGPT

-- Buat ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "CustomScriptGUI"

-- Frame Utama
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 350)
main.Position = UDim2.new(0.5, -250, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
main.Active, main.Draggable = true, true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Header
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(65, 50, 95)
header.Text = "Fish It Script - Custom Tab"
header.TextColor3 = Color3.new(1,1,1)
header.Font = Enum.Font.GothamBold
header.TextSize = 18
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

-- Tab Frame
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 50)
tabFrame.BackgroundTransparency = 1

-- Content Frame
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -20, 1, -100)
content.Position = UDim2.new(0, 10, 0, 95)
content.BackgroundColor3 = Color3.fromRGB(50, 40, 80)
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 10)

-- Fungsi bikin tombol tab
local function makeTab(name, pos)
	local btn = Instance.new("TextButton", tabFrame)
	btn.Size = UDim2.new(0, 95, 1, 0)
	btn.Position = UDim2.new(0, pos, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(70, 55, 100)
	btn.Text = name
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
	return btn
end

-- Tabs
local tabPlayer  = makeTab("Player Tele", 0)
local tabSave    = makeTab("Save Tele", 100)
local tabFly     = makeTab("Fly", 200)
local tabRun     = makeTab("Runhack", 300)
local tabFall    = makeTab("Anti Jatuh", 400)

-- Konten untuk tiap tab
local pages = {}

local function newPage()
	local p = Instance.new("Frame", content)
	p.Size = UDim2.new(1, 0, 1, 0)
	p.BackgroundTransparency = 1
	p.Visible = false
	return p
end

-- 1. Player Tele
pages.player = newPage()
local dropdown = Instance.new("TextButton", pages.player)
dropdown.Size = UDim2.new(1, -20, 0, 40)
dropdown.Position = UDim2.new(0, 10, 0, 10)
dropdown.Text = "Pilih Player"
dropdown.BackgroundColor3 = Color3.fromRGB(90, 70, 120)
dropdown.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)

local playerList = Instance.new("ScrollingFrame", pages.player)
playerList.Size = UDim2.new(1, -20, 0, 120)
playerList.Position = UDim2.new(0, 10, 0, 60)
playerList.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
playerList.ScrollBarThickness = 6
playerList.Visible = false
Instance.new("UICorner", playerList).CornerRadius = UDim.new(0, 8)

local tpBtn = Instance.new("TextButton", pages.player)
tpBtn.Size = UDim2.new(1, -20, 0, 40)
tpBtn.Position = UDim2.new(0, 10, 0, 190)
tpBtn.Text = "Teleport"
tpBtn.BackgroundColor3 = Color3.fromRGB(120, 90, 150)
tpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8)

local selectedPlayer = nil
local function refreshPlayers()
	playerList:ClearAllChildren()
	local y = 0
	for _,plr in pairs(game.Players:GetPlayers()) do
		if plr ~= game.Players.LocalPlayer then
			local b = Instance.new("TextButton", playerList)
			b.Size = UDim2.new(1, -10, 0, 30)
			b.Position = UDim2.new(0, 5, 0, y)
			b.Text = plr.Name
			b.BackgroundColor3 = Color3.fromRGB(70, 55, 100)
			b.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
			b.MouseButton1Click:Connect(function()
				selectedPlayer = plr
				dropdown.Text = "Dipilih: "..plr.Name
				playerList.Visible = false
			end)
			y = y + 35
		end
	end
	playerList.CanvasSize = UDim2.new(0,0,0,y)
end
dropdown.MouseButton1Click:Connect(function()
	refreshPlayers()
	playerList.Visible = not playerList.Visible
end)
tpBtn.MouseButton1Click:Connect(function()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local lp = game.Players.LocalPlayer
		if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			lp.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
		end
	end
end)

-- 2. Save Tele
pages.save = newPage()
local savedPos = nil
local saveBtn = Instance.new("TextButton", pages.save)
saveBtn.Size = UDim2.new(1, -20, 0, 40)
saveBtn.Position = UDim2.new(0, 10, 0, 20)
saveBtn.Text = "Save Posisi"
saveBtn.BackgroundColor3 = Color3.fromRGB(90, 70, 120)
saveBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)

local goBtn = Instance.new("TextButton", pages.save)
goBtn.Size = UDim2.new(1, -20, 0, 40)
goBtn.Position = UDim2.new(0, 10, 0, 70)
goBtn.Text = "Teleport ke Posisi Tersimpan"
goBtn.BackgroundColor3 = Color3.fromRGB(120, 90, 150)
goBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", goBtn).CornerRadius = UDim.new(0, 8)

saveBtn.MouseButton1Click:Connect(function()
	local lp = game.Players.LocalPlayer
	if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
		savedPos = lp.Character.HumanoidRootPart.CFrame
	end
end)
goBtn.MouseButton1Click:Connect(function()
	local lp = game.Players.LocalPlayer
	if savedPos and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
		lp.Character.HumanoidRootPart.CFrame = savedPos
	end
end)

-- 3. Fly
pages.fly = newPage()
local flyToggle = Instance.new("TextButton", pages.fly)
flyToggle.Size = UDim2.new(1, -20, 0, 40)
flyToggle.Position = UDim2.new(0, 10, 0, 20)
flyToggle.Text = "Toggle Fly"
flyToggle.BackgroundColor3 = Color3.fromRGB(120, 90, 150)
flyToggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", flyToggle).CornerRadius = UDim.new(0, 8)

local flying = false
flyToggle.MouseButton1Click:Connect(function()
	flying = not flying
	local lp = game.Players.LocalPlayer
	local char = lp.Character or lp.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	if flying then
		spawn(function()
			while flying and hum do
				game:GetService("RunService").Heartbeat:Wait()
				if hum.MoveDirection.Magnitude > 0 then
					hrp.Velocity = hum.MoveDirection * 60
				else
					hrp.Velocity = Vector3.new(0,0,0)
				end
			end
		end)
	else
		hrp.Velocity = Vector3.new(0,0,0)
	end
end)

-- 4. Runhack
pages.run = newPage()
local runToggle = Instance.new("TextButton", pages.run)
runToggle.Size = UDim2.new(1, -20, 0, 40)
runToggle.Position = UDim2.new(0, 10, 0, 20)
runToggle.Text = "Toggle Speed"
runToggle.BackgroundColor3 = Color3.fromRGB(120, 90, 150)
runToggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", runToggle).CornerRadius = UDim.new(0, 8)

local boosted = false
runToggle.MouseButton1Click:Connect(function()
	boosted = not boosted
	local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		if boosted then
			hum.WalkSpeed = 50
		else
			hum.WalkSpeed = 16
		end
	end
end)

-- 5. Anti Jatuh Mati
pages.fall = newPage()
local antiBtn = Instance.new("TextButton", pages.fall)
antiBtn.Size = UDim2.new(1, -20, 0, 40)
antiBtn.Position = UDim2.new(0, 10, 0, 20)
antiBtn.Text = "Aktifkan Anti Jatuh"
antiBtn.BackgroundColor3 = Color3.fromRGB(120, 90, 150)
antiBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", antiBtn).CornerRadius = UDim.new(0, 8)

local anti = false
antiBtn.MouseButton1Click:Connect(function()
	anti = not anti
	local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		if anti then
			hum.StateChanged:Connect(function(_, new)
				if new == Enum.HumanoidStateType.Freefall then
					hum:ChangeState(Enum.HumanoidStateType.Physics)
				end
			end)
		end
	end
end)

-- Sistem Tab
local function showPage(p)
	for _,pg in pairs(pages) do pg.Visible = false end
	p.Visible = true
end
tabPlayer.MouseButton1Click:Connect(function() showPage(pages.player) end)
tabSave.MouseButton1Click:Connect(function() showPage(pages.save) end)
tabFly.MouseButton1Click:Connect(function() showPage(pages.fly) end)
tabRun.MouseButton1Click:Connect(function() showPage(pages.run) end)
tabFall.MouseButton1Click:Connect(function() showPage(pages.fall) end)

-- default
showPage(pages.player)
