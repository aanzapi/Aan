--// Walvy Community GUI Base by Aanz
--// UI Template (tanpa fitur)

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Sidebar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Content = Instance.new("Frame")

local UICorner = Instance.new("UICorner")
local UIListLayout = Instance.new("UIListLayout")

-- Sidebar Buttons
local buttons = {"Auto Farm", "Teleport", "Shop", "User", "Utility", "Webhook", "Settings"}

-- UI Settings
ScreenGui.Name = "WalvyGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 600, 0, 350)

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Sidebar
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(0, 150, 1, 0)

UIListLayout.Parent = Sidebar
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- Title
Title.Parent = Sidebar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Walvy Community\nPremium (Beta)"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.TextSize = 14
Title.TextWrapped = true

-- Generate Sidebar Buttons
for _, name in ipairs(buttons) do
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Parent = Sidebar
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.Size = UDim2.new(1, -10, 0, 28)
	btn.Position = UDim2.new(0, 5, 0, 0)
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	btn.TextSize = 13
	btn.AutoButtonColor = false

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = btn

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	end)
end

-- Content Area
Content.Name = "Content"
Content.Parent = MainFrame
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Content.BorderSizePixel = 0
Content.Position = UDim2.new(0, 155, 0, 10)
Content.Size = UDim2.new(1, -165, 1, -20)

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 6)
corner2.Parent = Content

-- Example label (isi konten nanti)
local placeholder = Instance.new("TextLabel")
placeholder.Parent = Content
placeholder.BackgroundTransparency = 1
placeholder.Size = UDim2.new(1, 0, 1, 0)
placeholder.Font = Enum.Font.Gotham
placeholder.Text = "👋 Welcome! Pilih menu di sebelah kiri"
placeholder.TextColor3 = Color3.fromRGB(200, 200, 200)
placeholder.TextSize = 15
placeholder.TextWrapped = true

print("✅ Walvy GUI Base loaded successfully!")
