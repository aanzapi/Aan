--=========================================================
-- Base UI Template (DrRay Minimal Edition)
--=========================================================

--==[ GUI Container ]==--
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "BaseUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

--==[ Main Frame ]==--
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0.45, 0, 0.55, 0)
MainFrame.Position = UDim2.new(0.275, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 58)
MainFrame.BorderSizePixel = 0
MainFrame.Name = "MainFrame"

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0.03, 0)

--==[ Title Bar ]==--
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0.1, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.9, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DrRay Base UI"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

local CloseButton = Instance.new("TextButton", TopBar)
CloseButton.Size = UDim2.new(0.08, 0, 0.8, 0)
CloseButton.Position = UDim2.new(0.92, 0, 0.1, 0)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.TextScaled = true
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BorderSizePixel = 0
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0.2, 0)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--==[ Tab Navigation Bar ]==--
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(0.25, 0, 0.9, 0)
TabBar.Position = UDim2.new(0, 0, 0.1, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TabBar.BorderSizePixel = 0
TabBar.Name = "TabBar"

local TabList = Instance.new("UIListLayout", TabBar)
TabList.Padding = UDim.new(0.02, 0)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.VerticalAlignment = Enum.VerticalAlignment.Top

--==[ Tab Button Function ]==--
local function createTab(name)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.9, 0, 0.08, 0)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
	button.Text = name
	button.TextScaled = true
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.BorderSizePixel = 0
	Instance.new("UICorner", button).CornerRadius = UDim.new(0.2, 0)
	button.Parent = TabBar
	return button
end

--==[ Content Area ]==--
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(0.75, 0, 0.9, 0)
ContentFrame.Position = UDim2.new(0.25, 0, 0.1, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ContentFrame.BorderSizePixel = 0

local UIPadding = Instance.new("UIPadding", ContentFrame)
UIPadding.PaddingTop = UDim.new(0.04, 0)
UIPadding.PaddingLeft = UDim.new(0.04, 0)

--==[ Dropdown Template ]==--
local function createDropdown(title, options)
	local frame = Instance.new("Frame", ContentFrame)
	frame.Size = UDim2.new(0.9, 0, 0.12, 0)
	frame.BackgroundColor3 = Color3.fromRGB(45, 50, 75)
	frame.BorderSizePixel = 0
	frame.Name = title
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0.2, 0)

	local label = Instance.new("TextLabel", frame)
	label.Text = title
	label.Size = UDim2.new(0.6, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold

	local drop = Instance.new("TextButton", frame)
	drop.Size = UDim2.new(0.35, 0, 0.8, 0)
	drop.Position = UDim2.new(0.62, 0, 0.1, 0)
	drop.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
	drop.Text = "Select"
	drop.TextColor3 = Color3.new(1, 1, 1)
	drop.TextScaled = true
	drop.Font = Enum.Font.GothamBold
	drop.BorderSizePixel = 0
	Instance.new("UICorner", drop).CornerRadius = UDim.new(0.2, 0)

	local current = options[1] or "None"
	local open = false

	local dropdownFrame = Instance.new("Frame", frame)
	dropdownFrame.Position = UDim2.new(0, 0, 1.05, 0)
	dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
	dropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
	dropdownFrame.BorderSizePixel = 0
	dropdownFrame.Visible = false
	Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0.1, 0)

	local list = Instance.new("UIListLayout", dropdownFrame)
	list.Padding = UDim.new(0.02, 0)

	for _, opt in ipairs(options) do
		local optBtn = Instance.new("TextButton", dropdownFrame)
		optBtn.Size = UDim2.new(1, 0, 0.2, 0)
		optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
		optBtn.Text = opt
		optBtn.TextScaled = true
		optBtn.TextColor3 = Color3.new(1, 1, 1)
		optBtn.Font = Enum.Font.GothamBold
		optBtn.BorderSizePixel = 0
		optBtn.MouseButton1Click:Connect(function()
			drop.Text = opt
			open = false
			dropdownFrame.Visible = false
		end)
	end

	drop.MouseButton1Click:Connect(function()
		open = not open
		dropdownFrame.Visible = open
	end)

	return frame
end

--==[ Example Tabs and Content ]==--
local tab1 = createTab("Main")
local tab2 = createTab("Settings")

local mainDropdown = createDropdown("Choose Mode", {"Easy", "Medium", "Hard"})
mainDropdown.Position = UDim2.new(0, 0, 0.05, 0)

local exampleBtn = Instance.new("TextButton", ContentFrame)
exampleBtn.Size = UDim2.new(0.9, 0, 0.12, 0)
exampleBtn.Position = UDim2.new(0, 0, 0.25, 0)
exampleBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
exampleBtn.Text = "Activate"
exampleBtn.TextScaled = true
exampleBtn.TextColor3 = Color3.new(1, 1, 1)
exampleBtn.Font = Enum.Font.GothamBold
exampleBtn.BorderSizePixel = 0
Instance.new("UICorner", exampleBtn).CornerRadius = UDim.new(0.2, 0)

exampleBtn.MouseButton1Click:Connect(function()
	print("Activated!")
end)

print("[✅] DrRay Base UI Loaded")
