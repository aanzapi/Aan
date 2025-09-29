-- Services
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishItUI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

---------------------------------------------------------------------
-- 🔹 Intro Animation: A A N transparan (tanpa background hitam)
---------------------------------------------------------------------
local IntroFrame = Instance.new("Frame", ScreenGui)
IntroFrame.Size = UDim2.new(1,0,1,0)
IntroFrame.BackgroundTransparency = 1 -- 🔥 transparan
IntroFrame.ZIndex = 10

local AANLabel = Instance.new("TextLabel", IntroFrame)
AANLabel.Size = UDim2.new(1,0,1,0)
AANLabel.Text = ""
AANLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AANLabel.Font = Enum.Font.GothamBlack
AANLabel.TextScaled = true
AANLabel.BackgroundTransparency = 1
AANLabel.ZIndex = 11

-- Glow efek (Stroke)
local UIStroke = Instance.new("UIStroke", AANLabel)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(180, 90, 255)
UIStroke.Transparency = 0.2

-- Animasi huruf muncul
local text = "A A N"
for i = 1, #text do
	task.wait(0.4)
	AANLabel.Text = string.sub(text, 1, i)

	-- Pulse glow tiap huruf muncul
	UIStroke.Thickness = 6
	local pulse = TweenService:Create(UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Thickness = 2})
	pulse:Play()
end

-- Animasi Glow Berdenyut (loop kecil sebelum fade)
local keepPulsing = true
task.spawn(function()
	while keepPulsing do
		local up = TweenService:Create(UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.6})
		local down = TweenService:Create(UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.2})
		up:Play()
		up.Completed:Wait()
		down:Play()
		down.Completed:Wait()
	end
end)

-- Tunggu sebentar lalu fade out
task.wait(1.5)
keepPulsing = false
local fadeTween = TweenService:Create(AANLabel, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
fadeTween:Play()
fadeTween.Completed:Wait()

-- Hilangkan IntroFrame
IntroFrame:Destroy()

---------------------------------------------------------------------
-- 🔹 Baru Tampilkan Main UI
---------------------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(42, 21, 60)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Animasi muncul (zoom + fade)
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0, 200, 0, 120)

task.wait(0.3)
MainFrame.Visible = true
TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 450, 0, 280),
	BackgroundTransparency = 0
}):Play()

-- ❗ lanjutkan isi UI panelmu di bawah sini (header, tab, dll)
