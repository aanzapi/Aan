--[[
===========================================================
    Custom Base UI
    Dibuat dengan cinta ❤️ oleh aanstok & ChatGPT
    Fitur:
    - Tombol Close
    - Tombol Hide untuk menampilkan kembali UI
    - Tampilan clean dan natural
===========================================================
]]

-- Layanan Roblox
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Hapus UI lama kalau ada
if CoreGui:FindFirstChild("BaseUI") then
    CoreGui.BaseUI:Destroy()
end
if CoreGui:FindFirstChild("HideButton") then
    CoreGui.HideButton:Destroy()
end

-- === Frame Utama ===
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "BaseUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 220)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

-- Shadow/Border halus
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Thickness = 1.5

-- === Judul ===
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Text = "Base UI - Example"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- === Tombol Close ===
local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -35, 0, 7)
CloseButton.Text = "×"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 22
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundTransparency = 0.2
CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local CloseCorner = Instance.new("UICorner", CloseButton)
CloseCorner.CornerRadius = UDim.new(1, 0)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
end)

-- === Contoh Tombol di Dalam UI ===
local ExampleButton = Instance.new("TextButton", MainFrame)
ExampleButton.Size = UDim2.new(0, 120, 0, 35)
ExampleButton.Position = UDim2.new(0.5, -60, 0.5, -17)
ExampleButton.Text = "Example Button"
ExampleButton.Font = Enum.Font.GothamSemibold
ExampleButton.TextSize = 14
ExampleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExampleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local BtnCorner = Instance.new("UICorner", ExampleButton)
BtnCorner.CornerRadius = UDim.new(0, 6)

ExampleButton.MouseEnter:Connect(function()
    TweenService:Create(ExampleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
end)
ExampleButton.MouseLeave:Connect(function()
    TweenService:Create(ExampleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
end)

-- === Tombol Hide yang Muncul Saat UI di Tutup ===
local HideGui = Instance.new("ScreenGui", CoreGui)
HideGui.Name = "HideButton"

local HideButton = Instance.new("TextButton", HideGui)
HideButton.Text = "Show UI"
HideButton.Size = UDim2.new(0, 100, 0, 35)
HideButton.Position = UDim2.new(0.02, 0, 0.4, 0)
HideButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.Font = Enum.Font.GothamBold
HideButton.TextSize = 14
HideButton.Visible = false

local HideCorner = Instance.new("UICorner", HideButton)
HideCorner.CornerRadius = UDim.new(0, 6)

HideButton.MouseEnter:Connect(function()
    TweenService:Create(HideButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
end)
HideButton.MouseLeave:Connect(function()
    TweenService:Create(HideButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
end)

-- === Fungsi Tombol ===
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    MainFrame.Visible = false
    HideButton.Visible = true
end)

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 350, 0, 220)
    MainFrame.BackgroundTransparency = 0
    HideButton.Visible = false
end)

print("✅ Base UI berhasil dimuat.")
