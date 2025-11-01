-- Base Script dengan Menu Hamburger
-- Compatible dengan: Corona SDK, Gideros, atau framework Lua mobile lainnya

local widget = require("widget")
local composer = require("composer") -- Jika menggunakan Corona SDK

-- Warna yang digunakan
local colors = {
    primary = {0.2, 0.6, 0.8},
    secondary = {0.9, 0.9, 0.9},
    text = {0.2, 0.2, 0.2},
    background = {1, 1, 1}
}

-- Variabel global
local screenWidth, screenHeight = display.contentWidth, display.contentHeight
local isMenuOpen = false
local menuWidth = screenWidth * 0.7

-- Grup untuk elemen UI
local sceneGroup = display.newGroup()

-- Background utama
local background = display.newRect(sceneGroup, screenWidth/2, screenHeight/2, screenWidth, screenHeight)
background:setFillColor(unpack(colors.background))

-- Header dengan hamburger menu
local header = display.newRect(sceneGroup, screenWidth/2, 0, screenWidth, 60)
header.y = header.contentHeight/2
header:setFillColor(unpack(colors.primary))

-- Judul header
local title = display.newText(sceneGroup, "Aplikasi Saya", screenWidth/2, header.y, native.systemFont, 18)
title:setFillColor(1, 1, 1)

-- Tombol Hamburger
local hamburgerButton = display.newGroup()
sceneGroup:insert(hamburgerButton)

-- Garis-garis hamburger (3 garis)
for i = 1, 3 do
    local line = display.newRect(hamburgerButton, 30, 15 + (i-1)*10, 25, 3)
    line:setFillColor(1, 1, 1)
end
hamburgerButton.x, hamburgerButton.y = 30, header.y

-- Menu Sidebar
local menuGroup = display.newGroup()
sceneGroup:insert(menuGroup)

-- Background menu
local menuBackground = display.newRect(menuGroup, 0, 0, menuWidth, screenHeight)
menuBackground.x = -menuWidth/2
menuBackground:setFillColor(0.1, 0.1, 0.1, 0.95)

-- Overlay untuk menutup menu
local overlay = display.newRect(menuGroup, screenWidth/2, screenHeight/2, screenWidth, screenHeight)
overlay:setFillColor(0, 0, 0, 0.5)
overlay.isVisible = false
overlay.isHitTestable = true

-- Daftar menu items
local menuItems = {
    "Beranda",
    "Profil",
    "Pengaturan",
    "Bantuan",
    "Tentang",
    "Keluar"
}

local menuIcons = {
    "🏠", "👤", "⚙️", "❓", "ℹ️", "🚪"
}

-- Fungsi untuk membuat menu items
local function createMenuItems()
    local startY = 100
    local itemHeight = 50
    
    for i = 1, #menuItems do
        local yPos = startY + (i-1) * itemHeight
        
        -- Background item menu
        local itemBg = display.newRect(menuGroup, menuWidth/2, yPos, menuWidth - 20, 40)
        itemBg:setFillColor(0.3, 0.3, 0.3)
        itemBg.alpha = 0.7
        
        -- Icon menu
        local icon = display.newText(menuGroup, menuIcons[i], 40, yPos, native.systemFont, 20)
        
        -- Text menu
        local text = display.newText(menuGroup, menuItems[i], 70, yPos, native.systemFont, 16)
        text.anchorX = 0
        text:setFillColor(1, 1, 1)
        
        -- Tambahkan event listener untuk setiap item
        local function onMenuItemTap(event)
            print("Menu dipilih:", menuItems[i])
            closeMenu()
            -- Tambahkan aksi sesuai menu yang dipilih
            if menuItems[i] == "Keluar" then
                native.requestExit()
            end
            return true
        end
        
        itemBg:addEventListener("tap", onMenuItemTap)
        icon:addEventListener("tap", onMenuItemTap)
        text:addEventListener("tap", onMenuItemTap)
    end
end

-- Fungsi untuk membuka menu
local function openMenu()
    if isMenuOpen then return end
    
    isMenuOpen = true
    transition.to(menuGroup, {x = menuWidth/2, time = 300, transition = easing.outSine})
    overlay.isVisible = true
end

-- Fungsi untuk menutup menu
local function closeMenu()
    if not isMenuOpen then return end
    
    isMenuOpen = false
    transition.to(menuGroup, {x = -menuWidth/2, time = 300, transition = easing.outSine})
    overlay.isVisible = false
end

-- Fungsi toggle menu
local function toggleMenu()
    if isMenuOpen then
        closeMenu()
    else
        openMenu()
    end
end

-- Event listener untuk tombol hamburger
hamburgerButton:addEventListener("tap", toggleMenu)

-- Event listener untuk overlay (menutup menu saat diklik)
overlay:addEventListener("tap", closeMenu)

-- Fungsi untuk handle swipe gesture
local function onTouch(event)
    if event.phase == "began" then
        startX = event.x
    elseif event.phase == "ended" then
        local endX = event.x
        local diffX = endX - startX
        
        -- Swipe kanan untuk buka menu
        if diffX > 50 and not isMenuOpen then
            openMenu()
        -- Swipe kiri untuk tutup menu
        elseif diffX < -50 and isMenuOpen then
            closeMenu()
        end
    end
    return true
end

-- Tambahkan event listener untuk swipe
Runtime:addEventListener("touch", onTouch)

-- Konten utama aplikasi
local contentGroup = display.newGroup()
sceneGroup:insert(contentGroup)

-- Contoh konten halaman
local welcomeText = display.newText(contentGroup, "Selamat Datang di Aplikasi", screenWidth/2, screenHeight/2, native.systemFont, 20)
welcomeText:setFillColor(unpack(colors.text))

local instructionText = display.newText(contentGroup, "Tap icon ☰ untuk membuka menu", screenWidth/2, screenHeight/2 + 40, native.systemFont, 14)
instructionText:setFillColor(0.5, 0.5, 0.5)

-- Inisialisasi menu items
createMenuItems()

-- Posisi awal menu di luar layar
menuGroup.x = -menuWidth/2

-- Fungsi untuk cleanup (jika diperlukan)
local function cleanup()
    hamburgerButton:removeEventListener("tap", toggleMenu)
    overlay:removeEventListener("tap", closeMenu)
    Runtime:removeEventListener("touch", onTouch)
end

-- Export fungsi yang diperlukan (jika menggunakan module)
local scene = {
    sceneGroup = sceneGroup,
    openMenu = openMenu,
    closeMenu = closeMenu,
    toggleMenu = toggleMenu,
    cleanup = cleanup
}

return scene
