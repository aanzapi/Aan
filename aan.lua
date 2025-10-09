-- Langkah 1: Buat ScreenGui (Kontainer utama untuk GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExecutorBaseUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") -- Tempatkan di PlayerGui pemain lokal

-- Langkah 2: Buat Frame (Jendela atau panel utama)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "ExecutorWindow"
MainFrame.Size = UDim2.new(0.3, 0, 0.4, 0) -- Ukuran: 30% lebar, 40% tinggi layar
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0) -- Posisi: Tengah (sekitar)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Warna abu-abu gelap
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Tambahkan UI Corner untuk tampilan yang lebih modern (sudut melengkung)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8) -- Radius 8 pixel
UICorner.Parent = MainFrame

-- Langkah 3: Buat Label Judul
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0.1, 0) -- Lebar penuh Frame, 10% tinggi Frame
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleLabel.Text = "Basic Roblox Executor"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.BorderSizePixel = 0
TitleLabel.Parent = MainFrame

-- Langkah 4: Buat TextBox (Tempat pengguna mengetik kode)
local CodeTextBox = Instance.new("TextBox")
CodeTextBox.Name = "CodeInput"
CodeTextBox.Size = UDim2.new(0.9, 0, 0.65, 0) -- 90% lebar Frame, 65% tinggi Frame
CodeTextBox.Position = UDim2.new(0.05, 0, 0.12, 0) -- Sedikit ke bawah dan ke tengah
CodeTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CodeTextBox.PlaceholderText = "Ketik kode Lua Anda di sini..."
CodeTextBox.Text = ""
CodeTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeTextBox.TextSize = 14
CodeTextBox.MultiLine = true -- Memungkinkan banyak baris
CodeTextBox.TextXAlignment = Enum.TextXAlignment.Left
CodeTextBox.TextYAlignment = Enum.TextYAlignment.Top
CodeTextBox.Parent = MainFrame

-- Tambahkan UI Corner ke TextBox
local TextBoxUICorner = Instance.new("UICorner")
TextBoxUICorner.CornerRadius = UDim.new(0, 6)
TextBoxUICorner.Parent = CodeTextBox

-- Langkah 5: Buat TextButton (Tombol untuk menjalankan kode)
local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Name = "ExecuteButton"
ExecuteButton.Size = UDim2.new(0.9, 0, 0.15, 0) -- 90% lebar Frame, 15% tinggi Frame
ExecuteButton.Position = UDim2.new(0.05, 0, 0.8, 0) -- Di bagian bawah Frame
ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Warna biru cerah
ExecuteButton.Text = "EXECUTE"
ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteButton.TextScaled = true
ExecuteButton.Font = Enum.Font.SourceSansBold
ExecuteButton.Parent = MainFrame

-- Tambahkan UI Corner ke Button
local ButtonUICorner = Instance.new("UICorner")
ButtonUICorner.CornerRadius = UDim.new(0, 6)
ButtonUICorner.Parent = ExecuteButton

-- Langkah 6: Tambahkan fungsionalitas dasar (simulasi eksekusi)
ExecuteButton.MouseButton1Click:Connect(function()
    local codeToExecute = CodeTextBox.Text
    if string.len(codeToExecute) > 0 then
        -- Pada executor nyata, di sini akan ada fungsi 'loadstring' atau semacamnya
        -- *NAMUN*, fungsi 'loadstring' dinonaktifkan di Roblox, dan menjalankan kode
        -- arbitrer dari pengguna di game *asli* Roblox sangat tidak disarankan
        -- karena alasan keamanan dan exploit.
        
        -- Untuk tujuan contoh UI ini, kita hanya menampilkan pesan:
        print("Mengeksekusi kode...")
        print("---")
        print(codeToExecute)
        
        -- Anda bisa mengganti warna tombol sementara untuk memberikan feedback
        ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- Hijau
        wait(0.2)
        ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Kembali ke biru
    else
        print("TextBox kosong, tidak ada yang dieksekusi.")
    end
end)

-- Langkah 7: Tambahkan fungsionalitas drag/seret (opsional, tetapi penting untuk executor UI)
local isDragging = false
local dragStartPos = nil

TitleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPos = input.Position - MainFrame.Position.Offset
        TitleLabel.BackgroundTransparency = 0.5 -- Berikan visual feedback
    end
end)

TitleLabel.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
        TitleLabel.BackgroundTransparency = 0 -- Kembali normal
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        MainFrame.Position = UDim2.new(0, input.Position.X - dragStartPos.X, 0, input.Position.Y - dragStartPos.Y)
    end
end)

print("UI Executor Dasar telah dimuat.")
