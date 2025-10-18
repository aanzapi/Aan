-- Base UI Script: Mewah dan Unik dengan Tombol Close & Hide
-- Dibuat oleh Grok (Unik: Gradien Dinamis + Particle Trail + Fade Animasi)

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Buat ScreenGui utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MewahUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame utama dengan desain mewah (gradien dan glow)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.4, 0, 0.5, 0)  -- Ukuran 40% lebar, 50% tinggi screen
mainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)  -- Posisi tengah
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 50)  -- Warna dasar gelap
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Tambahkan UICorner untuk sudut melengkung (mewah)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.1, 0)  -- Sudut melengkung 10%
uiCorner.Parent = mainFrame

-- Gradien background (unik: warna berubah dinamis)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 50, 200)),  -- Ungu gelap
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 100, 255)),  -- Biru
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))   -- Ungu terang
}
gradient.Rotation = 45  -- Rotasi gradien untuk efek mewah
gradient.Parent = mainFrame

-- Glow effect (mewah dan unik)
local glow = Instance.new("UIStroke")
glow.Color = Color3.fromRGB(150, 100, 255)
glow.Thickness = 3
glow.Transparency = 0.5
glow.Parent = mainFrame

-- Particle trail effect (unik: partikel mengikuti frame)
local particleEmitter = Instance.new("ParticleEmitter")
particleEmitter.Texture = "rbxassetid://241685484"  -- Texture partikel sederhana
particleEmitter.Size = NumberSequence.new(0.5)
particleEmitter.Lifetime = NumberRange.new(1, 2)
particleEmitter.Rate = 10
particleEmitter.Speed = NumberRange.new(5, 10)
particleEmitter.Parent = mainFrame

-- Label judul (mewah dengan font dan shadow)
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Mewah UI Base"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Shadow effect untuk judul (unik)
local titleShadow = titleLabel:Clone()
titleShadow.TextColor3 = Color3.fromRGB(100, 100, 150)
titleShadow.Position = UDim2.new(0, 2, 0, 2)
titleShadow.ZIndex = titleLabel.ZIndex - 1
titleShadow.Parent = mainFrame

-- Tombol Close (menghapus GUI)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0.15, 0, 0.1, 0)
closeButton.Position = UDim2.new(0.85, 0, 0.05, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextScaled = true
closeButton.Parent = mainFrame

-- UICorner untuk tombol close
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

-- Tombol Hide (toggle hide/show dengan animasi)
local hideButton = Instance.new("TextButton")
hideButton.Name = "HideButton"
hideButton.Size = UDim2.new(0.15, 0, 0.1, 0)
hideButton.Position = UDim2.new(0.7, 0, 0.05, 0)
hideButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
hideButton.Text = "Hide"
hideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hideButton.Font = Enum.Font.SourceSansBold
hideButton.TextScaled = true
hideButton.Parent = mainFrame

-- UICorner untuk tombol hide
local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0.5, 0)
hideCorner.Parent = hideButton

-- Variabel untuk toggle hide
local isHidden = false

-- Fungsi animasi fade (unik: smooth tween)
local tweenService = game:GetService("TweenService")
local fadeIn = tweenService:Create(mainFrame, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
local fadeOut = tweenService:Create(mainFrame, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1})

-- Event untuk tombol Close
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()  -- Hapus GUI sepenuhnya
end)

-- Event untuk tombol Hide
hideButton.MouseButton1Click:Connect(function()
    if isHidden then
        fadeIn:Play()  -- Tampilkan dengan animasi
        hideButton.Text = "Hide"
        isHidden = false
    else
        fadeOut:Play()  -- Sembunyikan dengan animasi
        hideButton.Text = "Show"
        isHidden = true
    end
end)

-- Animasi masuk awal (mewah)
mainFrame.BackgroundTransparency = 1
fadeIn:Play()
