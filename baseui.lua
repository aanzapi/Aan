--[[
    BaseUI v2.0 - Complete UI Library for Roblox Executors
    Created by: Aanzapi
    GitHub: https://github.com/aanzapi
    
    Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/username/repo/main/baseui.lua"))()
]]

local BaseUI = {
    Version = "2.0.0",
    Author = "Aanzapi",
    Theme = "Dark Modern"
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Color Palette
BaseUI.Colors = {
    Primary = Color3.fromRGB(0, 120, 215),
    Secondary = Color3.fromRGB(107, 114, 128),
    Success = Color3.fromRGB(34, 197, 94),
    Danger = Color3.fromRGB(239, 68, 68),
    Warning = Color3.fromRGB(245, 158, 11),
    Info = Color3.fromRGB(59, 130, 246),
    Dark = Color3.fromRGB(31, 41, 55),
    Darker = Color3.fromRGB(17, 24, 39),
    Light = Color3.fromRGB(243, 244, 246),
    Text = Color3.fromRGB(248, 250, 252),
    TextSecondary = Color3.fromRGB(156, 163, 175),
    Border = Color3.fromRGB(55, 65, 81),
    Accent = Color3.fromRGB(139, 92, 246)
}

-- Fonts
BaseUI.Fonts = {
    Regular = Enum.Font.Gotham,
    Medium = Enum.Font.GothamMedium,
    Semibold = Enum.Font.GothamSemibold,
    Bold = Enum.Font.GothamBold,
    Monospace = Enum.Font.Code
}

-- Animation Presets
BaseUI.Animations = {
    Quick = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Bouncy = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Elastic = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
}

--[[
    UTILITY FUNCTIONS
]]

function BaseUI:Create(class, properties, children)
    local instance = Instance.new(class)
    
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    
    if children then
        for _, child in ipairs(children) do
            child.Parent = instance
        end
    end
    
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    
    return instance
end

function BaseUI:Tween(object, tweenInfo, properties)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function BaseUI:Round(num, decimalPlaces)
    local multiplier = 10^(decimalPlaces or 0)
    return math.floor(num * multiplier + 0.5) / multiplier
end

function BaseUI:HexToColor(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber("0x" .. hex:sub(1, 2)),
        tonumber("0x" .. hex:sub(3, 4)),
        tonumber("0x" .. hex:sub(5, 6))
    )
end

--[[
    CORE UI COMPONENTS
]]

function BaseUI:Window(title, size, position, options)
    options = options or {}
    
    local window = {
        Title = title or "BaseUI Window",
        Size = size or UDim2.new(0, 500, 0, 400),
        Position = position or UDim2.new(0.5, -250, 0.5, -200),
        Theme = options.Theme or "Dark",
        Draggable = options.Draggable == nil and true or options.Draggable,
        Visible = options.Visible == nil and true or options.Visible,
        Components = {},
        Connections = {}
    }
    
    -- Main Container
    window.Container = self:Create("Frame", {
        Name = "BaseUIWindow",
        Size = window.Size,
        Position = window.Position,
        BackgroundColor3 = self.Colors.Darker,
        BorderColor3 = self.Colors.Border,
        BorderSizePixel = 1,
        ClipsDescendants = true,
        Parent = options.Parent or game:GetService("CoreGui")
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        self:Create("UIStroke", {
            Color = self.Colors.Accent,
            Thickness = 1
        })
    })
    
    -- Title Bar
    window.TitleBar = self:Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Colors.Dark,
        Parent = window.Container
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 12, 0, 0)})
    })
    
    -- Title Text
    window.TitleText = self:Create("TextLabel", {
        Name = "TitleText",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = window.Title,
        TextColor3 = self.Colors.Text,
        Font = self.Fonts.Semibold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = window.TitleBar
    })
    
    -- Close Button
    if options.CloseButton ~= false then
        window.CloseButton = self:Button("X", UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0.5, -15), {
            Parent = window.TitleBar,
            Color = self.Colors.Danger,
            TextColor = self.Colors.Text,
            OnClick = function()
                window:Destroy()
            end
        })
    end
    
    -- Content Frame
    window.Content = self:Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        Parent = window.Container
    })
    
    -- Make draggable
    if window.Draggable then
        local dragging = false
        local dragInput, dragStart, startPos
        
        local function update(input)
            local delta = input.Position - dragStart
            window.Container.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
        
        window.TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = window.Container.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        window.TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input == dragInput then
                update(input)
            end
        end)
    end
    
    -- Window Methods
    function window:Show()
        self.Container.Visible = true
        self:Tween(self.Container, self.Animations.Smooth, {
            Position = self.Position,
            Size = self.Size
        })
        return self
    end
    
    function window:Hide()
        self.Container.Visible = false
        return self
    end
    
    function window:Destroy()
        for _, connection in ipairs(self.Connections) do
            connection:Disconnect()
        end
        self.Container:Destroy()
        setmetatable(self, nil)
    end
    
    function window:AddComponent(component)
        table.insert(self.Components, component)
        return component
    end
    
    -- Initial show animation
    if window.Visible then
        window.Container.Position = UDim2.new(0.5, -250, 0, -400)
        window:Show()
    end
    
    return window
end

function BaseUI:Button(text, size, position, options)
    options = options or {}
    
    local button = {
        Text = text or "Button",
        Size = size or UDim2.new(0, 100, 0, 40),
        Position = position or UDim2.new(0, 0, 0, 0),
        Color = options.Color or self.Colors.Primary,
        TextColor = options.TextColor or self.Colors.Text,
        Disabled = options.Disabled or false,
        OnClick = options.OnClick or function() end,
        OnHover = options.OnHover or function() end,
        OnLeave = options.OnLeave or function() end
    }
    
    -- Create button frame
    button.Frame = self:Create("TextButton", {
        Name = "BaseUIButton",
        Size = button.Size,
        Position = button.Position,
        BackgroundColor3 = button.Color,
        Text = "",
        AutoButtonColor = false,
        Parent = options.Parent
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIStroke", {
            Color = self.Colors.Border,
            Thickness = 1
        })
    })
    
    -- Button label
    button.Label = self:Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = button.Text,
        TextColor3 = button.TextColor,
        Font = self.Fonts.Medium,
        TextSize = 14,
        Parent = button.Frame
    })
    
    -- Hover effect
    local originalColor = button.Color
    local hoverColor = Color3.new(
        math.min(originalColor.R * 1.2, 1),
        math.min(originalColor.G * 1.2, 1),
        math.min(originalColor.B * 1.2, 1)
    )
    
    local pressedColor = Color3.new(
        math.max(originalColor.R * 0.8, 0),
        math.max(originalColor.G * 0.8, 0),
        math.max(originalColor.B * 0.8, 0)
    )
    
    -- Mouse events
    button.Frame.MouseEnter:Connect(function()
        if button.Disabled then return end
        
        self:Tween(button.Frame, self.Animations.Quick, {
            BackgroundColor3 = hoverColor,
            Size = button.Size + UDim2.new(0, 2, 0, 2)
        })
        button.OnHover()
    end)
    
    button.Frame.MouseLeave:Connect(function()
        if button.Disabled then return end
        
        self:Tween(button.Frame, self.Animations.Quick, {
            BackgroundColor3 = originalColor,
            Size = button.Size
        })
        button.OnLeave()
    end)
    
    button.Frame.MouseButton1Down:Connect(function()
        if button.Disabled then return end
        
        self:Tween(button.Frame, self.Animations.Quick, {
            BackgroundColor3 = pressedColor,
            Size = button.Size - UDim2.new(0, 2, 0, 2)
        })
    end)
    
    button.Frame.MouseButton1Up:Connect(function()
        if button.Disabled then return end
        
        self:Tween(button.Frame, self.Animations.Quick, {
            BackgroundColor3 = hoverColor,
            Size = button.Size
        })
    end)
    
    button.Frame.MouseButton1Click:Connect(function()
        if button.Disabled then return end
        button.OnClick()
    end)
    
    -- Button methods
    function button:SetText(text)
        self.Text = text
        self.Label.Text = text
        return self
    end
    
    function button:SetColor(color)
        self.Color = color
        originalColor = color
        self.Frame.BackgroundColor3 = color
        return self
    end
    
    function button:SetDisabled(disabled)
        self.Disabled = disabled
        self.Frame.BackgroundTransparency = disabled and 0.5 or 0
        return self
    end
    
    function button:Destroy()
        self.Frame:Destroy()
        setmetatable(self, nil)
    end
    
    return button
end

function BaseUI:Label(text, size, position, options)
    options = options or {}
    
    local label = {
        Text = text or "Label",
        Size = size or UDim2.new(1, 0, 0, 20),
        Position = position or UDim2.new(0, 0, 0, 0)
    }
    
    label.Frame = self:Create("TextLabel", {
        Name = "BaseUILabel",
        Size = label.Size,
        Position = label.Position,
        BackgroundTransparency = 1,
        Text = label.Text,
        TextColor3 = options.Color or self.Colors.Text,
        Font = options.Font or self.Fonts.Regular,
        TextSize = options.TextSize or 14,
        TextXAlignment = options.Alignment or Enum.TextXAlignment.Left,
        TextWrapped = options.Wrapped or false,
        Parent = options.Parent
    })
    
    -- Label methods
    function label:SetText(text)
        self.Text = text
        self.Frame.Text = text
        return self
    end
    
    function label:SetColor(color)
        self.Frame.TextColor3 = color
        return self
    end
    
    function label:Destroy()
        self.Frame:Destroy()
        setmetatable(self, nil)
    end
    
    return label
end

function BaseUI:TextBox(placeholder, size, position, options)
    options = options or {}
    
    local textbox = {
        Placeholder = placeholder or "Type here...",
        Size = size or UDim2.new(1, 0, 0, 40),
        Position = position or UDim2.new(0, 0, 0, 0),
        OnFocus = options.OnFocus or function() end,
        OnFocusLost = options.OnFocusLost or function(text) end,
        OnTextChanged = options.OnTextChanged or function(text) end
    }
    
    -- Create container
    textbox.Frame = self:Create("Frame", {
        Name = "BaseUITextBox",
        Size = textbox.Size,
        Position = textbox.Position,
        BackgroundColor3 = self.Colors.Dark,
        BackgroundTransparency = 0.1,
        Parent = options.Parent
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIStroke", {
            Color = self.Colors.Border,
            Thickness = 1
        })
    })
    
    -- Actual TextBox
    textbox.Input = self:Create("TextBox", {
        Name = "Input",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        PlaceholderText = textbox.Placeholder,
        PlaceholderColor3 = self.Colors.TextSecondary,
        TextColor3 = self.Colors.Text,
        Font = self.Fonts.Regular,
        TextSize = 14,
        ClearTextOnFocus = options.ClearOnFocus or false,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = textbox.Frame
    })
    
    -- Focus effects
    textbox.Input.Focused:Connect(function()
        self:Tween(textbox.Frame, self.Animations.Quick, {
            BackgroundColor3 = Color3.fromRGB(40, 50, 70)
        })
        textbox.OnFocus()
    end)
    
    textbox.Input.FocusLost:Connect(function(enterPressed)
        self:Tween(textbox.Frame, self.Animations.Quick, {
            BackgroundColor3 = self.Colors.Dark
        })
        textbox.OnFocusLost(textbox.Input.Text, enterPressed)
    end)
    
    textbox.Input:GetPropertyChangedSignal("Text"):Connect(function()
        textbox.OnTextChanged(textbox.Input.Text)
    end)
    
    -- TextBox methods
    function textbox:SetText(text)
        self.Input.Text = text
        return self
    end
    
    function textbox:GetText()
        return self.Input.Text
    end
    
    function textbox:SetPlaceholder(text)
        self.Input.PlaceholderText = text
        return self
    end
    
    function textbox:SetDisabled(disabled)
        self.Input.Visible = not disabled
        return self
    end
    
    function textbox:Destroy()
        self.Frame:Destroy()
        setmetatable(self, nil)
    end
    
    return textbox
end

function BaseUI:Toggle(text, size, position, options)
    options = options or {}
    
    local toggle = {
        Text = text or "Toggle",
        Size = size or UDim2.new(1, 0, 0, 30),
        Position = position or UDim2.new(0, 0, 0, 0),
        State = options.Default or false,
        OnChange = options.OnChange or function(state) end
    }
    
    -- Create container
    toggle.Frame = self:Create("Frame", {
        Name = "BaseUIToggle",
        Size = toggle.Size,
        Position = toggle.Position,
        BackgroundTransparency = 1,
        Parent = options.Parent
    })
    
    -- Toggle switch
    toggle.Switch = self:Create("Frame", {
        Name = "Switch",
        Size = UDim2.new(0, 50, 0, 26),
        Position = UDim2.new(1, -55, 0.5, -13),
        BackgroundColor3 = toggle.State and self.Colors.Success or self.Colors.Secondary,
        Parent = toggle.Frame
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        self:Create("UIStroke", {
            Color = self.Colors.Border,
            Thickness = 1
        })
    })
    
    -- Toggle knob
    toggle.Knob = self:Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, toggle.State and 26 or 4, 0.5, -10),
        BackgroundColor3 = self.Colors.Text,
        Parent = toggle.Switch
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Toggle label
    toggle.Label = self:Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = toggle.Text,
        TextColor3 = self.Colors.Text,
        Font = self.Fonts.Regular,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggle.Frame
    })
    
    -- Click handler
    toggle.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle:SetState(not toggle.State)
        end
    end)
    
    -- Toggle methods
    function toggle:SetState(state)
        self.State = state
        
        self:Tween(self.Knob, self.Animations.Quick, {
            Position = UDim2.new(0, state and 26 or 4, 0.5, -10)
        })
        
        self:Tween(self.Switch, self.Animations.Quick, {
            BackgroundColor3 = state and self.Colors.Success or self.Colors.Secondary
        })
        
        self.OnChange(state)
        return self
    end
    
    function toggle:GetState()
        return self.State
    end
    
    function toggle:Destroy()
        self.Frame:Destroy()
        setmetatable(self, nil)
    end
    
    return toggle
end

function BaseUI:Slider(min, max, defaultValue, size, position, options)
    options = options or {}
    
    local slider = {
        Min = min or 0,
        Max = max or 100,
        Value = defaultValue or min,
        Size = size or UDim2.new(1, 0, 0, 50),
        Position = position or UDim2.new(0, 0, 0, 0),
        OnChange = options.OnChange or function(value) end
    }
    
    -- Create container
    slider.Frame = self:Create("Frame", {
        Name = "BaseUISlider",
        Size = slider.Size,
        Position = slider.Position,
        BackgroundTransparency = 1,
        Parent = options.Parent
    })
    
    -- Slider track
    slider.Track = self:Create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0.5, -3),
        BackgroundColor3 = self.Colors.Dark,
        Parent = slider.Frame
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Slider fill
    local fillPercentage = (slider.Value - slider.Min) / (slider.Max - slider.Min)
    slider.Fill = self:Create("Frame", {
        Name = "Fill",
        Size = UDim2.new(fillPercentage, 0, 1, 0),
        BackgroundColor3 = self.Colors.Primary,
        Parent = slider.Track
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Slider knob
    slider.Knob = self:Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(fillPercentage, -10, 0.5, -10),
        BackgroundColor3 = self.Colors.Text,
        Parent = slider.Frame
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        self:Create("UIStroke", {
            Color = self.Colors.Primary,
            Thickness = 2
        })
    })
    
-- Value label
    slider.ValueLabel = self:Create("TextLabel", {
        Name = "ValueLabel",
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -45, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(slider.Value),
        TextColor3 = self.Colors.Text,
        Font = self.Fonts.Medium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = slider.Frame
    })
    
    -- Title label
    if options.Title then
        slider.TitleLabel = self:Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -50, 0, 20),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = options.Title,
            TextColor3 = self.Colors.Text,
            Font = self.Fonts.Regular,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = slider.Frame
        })
    end
    
    -- Dragging logic
    local dragging = false
    
    local function updateSlider(input)
        local relativeX = (input.Position.X - slider.Track.AbsolutePosition.X) / slider.Track.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        local newValue = slider.Min + (relativeX * (slider.Max - slider.Min))
        newValue = self:Round(newValue, options.Decimals or 0)
        
        slider:SetValue(newValue)
    end
    
    slider.Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Slider methods
    function slider:SetValue(value)
        self.Value = math.clamp(value, self.Min, self.Max)
        
        local fillPercentage = (self.Value - self.Min) / (self.Max - self.Min)
        
        self:Tween(self.Fill, self.Animations.Quick, {
            Size = UDim2.new(fillPercentage, 0, 1, 0)
        })
        
        self:Tween(self.Knob, self.Animations.Quick, {
            Position = UDim2.new(fillPercentage, -10, 0.5, -10)
        })
        
        self.ValueLabel.Text = tostring(self.Value)
        self.OnChange(self.Value)
        return self
    end
    
    function slider:GetValue()
        return self.Value
    end
    
    function slider:Destroy()
        self.Frame:Destroy()
        setmetatable(self, nil)
    end
    
    return slider
end

function BaseUI:Dropdown(optionsList, placeholder, size, position, options)
    options = options or {}
    
    local dropdown = {
        Options = optionsList or {"Option 1", "Option 2", "Option 3"},
        Selected = nil,
        Size = size or UDim2.new(1, 0, 0, 40),
        Position = position or UDim2.new(0, 0, 0, 0),
        OnSelect = options.OnSelect or function(option, index) end,
        IsOpen = false
    }
    
    -- Create container
    dropdown.Frame = self:Create("Frame", {
        Name = "BaseUIDropdown",
        Size = dropdown.Size,
        Position = dropdown.Position,
        BackgroundColor3 = self.Colors.Dark,
        BackgroundTransparency = 0.1,
        ClipsDescendants = true,
        Parent = options.Parent
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIStroke", {
            Color = self.Colors.Border,
            Thickness = 1
        })
    })
    
    -- Selected display
    dropdown.SelectedLabel = self:Create("TextLabel", {
        Name = "Selected",
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = placeholder or "Select an option...",
        TextColor3 = self.Colors.TextSecondary,
        Font = self.Fonts.Regular,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dropdown.Frame
    })
    
    -- Arrow icon
    dropdown.Arrow = self:Create("TextLabel", {
        Name = "Arrow",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = self.Colors.TextSecondary,
        Font = self.Fonts.Regular,
        TextSize = 12,
        Parent = dropdown.Frame
    })
    
    -- Options container
    dropdown.OptionsFrame = self:Create("Frame", {
        Name = "Options",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = self.Colors.Darker,
        Visible = false,
        Parent = dropdown.Frame
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIStroke", {
            Color = self.Colors.Border,
            Thickness = 1
        })
    })
    
    -- Option buttons
    dropdown.OptionButtons = {}
    
    local function createOptionButton(option, index)
        local button = self:Create("TextButton", {
            Name = "Option_" .. index,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, (index - 1) * 35 + 5),
            BackgroundColor3 = self.Colors.Dark,
            Text = option,
            TextColor3 = self.Colors.Text,
            Font = self.Fonts.Regular,
            TextSize = 14,
            AutoButtonColor = false,
            Parent = dropdown.OptionsFrame
        }, {
            self:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
        })
        
        button.MouseEnter:Connect(function()
            self:Tween(button, self.Animations.Quick, {
                BackgroundColor3 = Color3.fromRGB(50, 60, 80)
            })
        end)
        
        button.MouseLeave:Connect(function()
            self:Tween(button, self.Animations.Quick, {
                BackgroundColor3 = self.Colors.Dark
            })
        end)
        
        button.MouseButton1Click:Connect(function()
            dropdown:Select(option, index)
            dropdown:Toggle()
        end)
        
        return button
    end
    
    -- Create all options
    for i, option in ipairs(dropdown.Options) do
        dropdown.OptionButtons[i] = createOptionButton(option, i)
    end
    
    -- Set options frame size
    dropdown.OptionsFrame.Size = UDim2.new(1, 0, 0, #dropdown.Options * 35 + 10)
    
    -- Toggle dropdown
    function dropdown:Toggle()
        self.IsOpen = not self.IsOpen
        
        if self.IsOpen then
            self.OptionsFrame.Visible = true
            self:Tween(self.OptionsFrame, self.Animations.Smooth, {
                Size = UDim2.new(1, 0, 0, #self.Options * 35 + 10)
            })
            self.Arrow.Text = "▲"
        else
            self:Tween(self.OptionsFrame, self.Animations.Smooth, {
                Size = UDim2.new(1, 0, 0, 0)
            })
            wait(0.25)
            self.OptionsFrame.Visible = false
            self.Arrow.Text = "▼"
        end
    end
    
    -- Select option
    function dropdown:Select(option, index)
        self.Selected = option
        self.SelectedLabel.Text = option
        self.SelectedLabel.TextColor3 = self.Colors.Text
        self.OnSelect(option, index)
    end
    
    -- Click handler
    dropdown.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dropdown:Toggle()
        end
    end)
    
    -- Close dropdown when clicking outside
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dropdown.IsOpen and not dropdown.Frame:IsDescendantOf(input.Target) then
                dropdown:Toggle()
            end
        end
    end)
    
    -- Dropdown methods
    function dropdown:GetSelected()
        return dropdown.Selected
    end
    
    function dropdown:SetOptions(newOptions)
        dropdown.Options = newOptions
        
        -- Clear old options
        for _, button in ipairs(dropdown.OptionButtons) do
            button:Destroy()
        end
        
        dropdown.OptionButtons = {}
        
        -- Create new options
        for i, option in ipairs(dropdown.Options) do
            dropdown.OptionButtons[i] = createOptionButton(option, i)
        end
        
        dropdown.OptionsFrame.Size = UDim2.new(1, 0, 0, #dropdown.Options * 35 + 10)
        return self
    end
    
    function dropdown:Destroy()
        self.Frame:Destroy()
        setmetatable(self, nil)
    end
    
    return dropdown
end

--[[
    QUICK UI BUILDER
]]

function BaseUI:CreateQuickUI(title)
    local ui = {}
    
    ui.Window = self:Window(title or "BaseUI", UDim2.new(0, 400, 0, 500))
    ui.Components = {}
    
    -- Add button method
    function ui:Button(text, callback)
        local button = self.BaseUI:Button(text, UDim2.new(0.9, 0, 0, 40), UDim2.new(0.05, 0, 0, 10 + (#self.Components * 50)), {
            Parent = self.Window.Content,
            OnClick = callback
        })
        table.insert(self.Components, button)
        return button
    end
    
    -- Add label method
    function ui:Label(text, size)
        local label = self.BaseUI:Label(text, UDim2.new(0.9, 0, size or 0, 20), UDim2.new(0.05, 0, 0, 10 + (#self.Components * 50)), {
            Parent = self.Window.Content
        })
        table.insert(self.Components, label)
        return label
    end
    
    -- Add textbox method
    function ui:TextBox(placeholder, callback)
        local textbox = self.BaseUI:TextBox(placeholder, UDim2.new(0.9, 0, 0, 40), UDim2.new(0.05, 0, 0, 10 + (#self.Components * 50)), {
            Parent = self.Window.Content,
            OnFocusLost = callback
        })
        table.insert(self.Components, textbox)
        return textbox
    end
    
    -- Add toggle method
    function ui:Toggle(text, default, callback)
        local toggle = self.BaseUI:Toggle(text, UDim2.new(0.9, 0, 0, 30), UDim2.new(0.05, 0, 0, 10 + (#self.Components * 50)), {
            Parent = self.Window.Content,
            Default = default,
            OnChange = callback
        })
        table.insert(self.Components, toggle)
        return toggle
    end
    
    -- Add slider method
    function ui:Slider(title, min, max, default, callback)
        local slider = self.BaseUI:Slider(min, max, default, UDim2.new(0.9, 0, 0, 50), UDim2.new(0.05, 0, 0, 10 + (#self.Components * 50)), {
            Parent = self.Window.Content,
            Title = title,
            OnChange = callback
        })
        table.insert(self.Components, slider)
        return slider
    end
    
    -- Add dropdown method
    function ui:Dropdown(options, placeholder, callback)
        local dropdown = self.BaseUI:Dropdown(options, placeholder, UDim2.new(0.9, 0, 0, 40), UDim2.new(0.05, 0, 0, 10 + (#self.Components * 50)), {
            Parent = self.Window.Content,
            OnSelect = callback
        })
        table.insert(self.Components, dropdown)
        return dropdown
    end
    
    ui.BaseUI = self
    
    return ui
end

--[[
    EXAMPLE AND INIT
]]

function BaseUI:Example()
    local exampleUI = self:CreateQuickUI("BaseUI Example v" .. self.Version)
    
    -- Title
    exampleUI:Label("Welcome to BaseUI!", 30)
        :SetColor(self.Colors.Accent)
    
    exampleUI:Label("A complete UI library for Roblox")
    
    -- Button example
    exampleUI:Button("Click Me!", function()
        print("Button clicked!")
    end)
    
    -- Toggle example
    exampleUI:Toggle("Enable Feature", false, function(state)
        print("Toggle state:", state)
    end)
    
    -- TextBox example
    exampleUI:TextBox("Enter your name", function(text)
        print("Hello, " .. text .. "!")
    end)
    
    -- Slider example
    exampleUI:Slider("Volume", 0, 100, 50, function(value)
        print("Volume set to:", value)
    end)
    
    -- Dropdown example
    exampleUI:Dropdown({"Option A", "Option B", "Option C"}, "Select option", function(option, index)
        print("Selected:", option, "Index:", index)
    end)
    
    -- Colorful buttons
    exampleUI:Button("Success Button", function()
        print("Success!")
    end):SetColor(self.Colors.Success)
    
    exampleUI:Button("Danger Button", function()
        print("Danger!")
    end):SetColor(self.Colors.Danger)
    
    return exampleUI
end

-- Auto-run example if loaded directly
if not script then
    -- This is loaded via executor
    local example = BaseUI:Example()
    print("✅ BaseUI v" .. BaseUI.Version .. " loaded successfully!")
    print("📝 Created by: " .. BaseUI.Author)
end

return BaseUI