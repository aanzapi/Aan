-- Gui Buatan
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local WalkLabel = Instance.new("TextLabel")
local WalkBox = Instance.new("TextBox")
local FlyButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

ScreenGui.Parent = game.CoreGui

-- Frame Utama
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Position = UDim2.new(0.35, 0, 0.75, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Parent = ScreenGui

UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = MainFrame

-- Walkspeed Label
WalkLabel.Size = UDim2.new(0,100,0,30)
WalkLabel.Position = UDim2.new(0.05,0,0.1,0)
WalkLabel.Text = "WalkSpeed:"
WalkLabel.TextColor3 = Color3.fromRGB(255,255,255)
WalkLabel.BackgroundTransparency = 1
WalkLabel.Parent = MainFrame

-- Walkspeed Box
WalkBox.Size = UDim2.new(0,100,0,30)
WalkBox.Position = UDim2.new(0.5,0,0.1,0)
WalkBox.Text = tostring(hum.WalkSpeed)
WalkBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
WalkBox.TextColor3 = Color3.fromRGB(255,255,255)
WalkBox.Parent = MainFrame

-- Fly Button
FlyButton.Size = UDim2.new(0.9,0,0.3,0)
FlyButton.Position = UDim2.new(0.05,0,0.55,0)
FlyButton.Text = "Toggle Fly"
FlyButton.BackgroundColor3 = Color3.fromRGB(0,120,255)
FlyButton.TextColor3 = Color3.fromRGB(255,255,255)
FlyButton.Parent = MainFrame
local btncorner = Instance.new("UICorner", FlyButton)
btncorner.CornerRadius = UDim.new(0,8)

-- Fitur WalkSpeed
WalkBox.FocusLost:Connect(function()
	local val = tonumber(WalkBox.Text)
	if val then
		hum.WalkSpeed = val
	end
end)

-- Fly System
local flying = false
local bv, bg

local function startFly()
	if flying then return end
	flying = true

	bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
	bv.Velocity = Vector3.new(0,0,0)
	bv.MaxForce = Vector3.new(4000,4000,4000)

	bg = Instance.new("BodyGyro", char.HumanoidRootPart)
	bg.MaxTorque = Vector3.new(4000,4000,4000)
	bg.P = 10000
	bg.CFrame = char.HumanoidRootPart.CFrame

	-- Loop kontrol
	game:GetService("RunService").RenderStepped:Connect(function()
		if flying and bv and bg then
			local moveDir = hum.MoveDirection
			local vel = Vector3.new(moveDir.X*hum.WalkSpeed,0,moveDir.Z*hum.WalkSpeed)

			-- Naik pake tombol loncat
			if hum.Jump then
				vel = vel + Vector3.new(0,hum.WalkSpeed,0)
			end

			-- Turun (CTRL/Shift)
			if userinputservice:IsKeyDown(Enum.KeyCode.LeftControl) then
				vel = vel - Vector3.new(0,hum.WalkSpeed,0)
			end

			bv.Velocity = vel
			bg.CFrame = workspace.CurrentCamera.CFrame
		end
	end)
end

local function stopFly()
	flying = false
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

FlyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
		FlyButton.Text = "Toggle Fly"
		FlyButton.BackgroundColor3 = Color3.fromRGB(0,120,255)
	else
		startFly()
		FlyButton.Text = "Stop Fly"
		FlyButton.BackgroundColor3 = Color3.fromRGB(255,50,50)
	end
end)
