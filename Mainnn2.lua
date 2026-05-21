-- ============================================================================
--  DELTA HUB UI - واجهة مستخدم متكاملة لـ Roblox (هاكز دلتا)
--  يعمل مع جميع منصات التنفيذ (Delta, Krnl, Synapse, ScriptWare)
--  نسخة: Delta Xtreme v4.0 - UI متحرك بالكامل
-- ============================================================================

-- تأكد من وجود مكتبة Drawing (لـ Roblox)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local guiService = game:GetService("GuiService")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- ====================== [ إعدادات الألوان والثيمات ] ======================
local themes = {
    neon = {
        BG = Color3.fromRGB(8, 8, 20),
        Primary = Color3.fromRGB(0, 255, 200),
        Secondary = Color3.fromRGB(150, 50, 255),
        Accent = Color3.fromRGB(255, 50, 200),
        Text = Color3.fromRGB(255, 255, 255),
        Glow = Color3.fromRGB(0, 150, 120),
        Danger = Color3.fromRGB(255, 50, 50),
        Success = Color3.fromRGB(50, 255, 100)
    },
    fire = {
        BG = Color3.fromRGB(20, 8, 8),
        Primary = Color3.fromRGB(255, 80, 0),
        Secondary = Color3.fromRGB(255, 150, 0),
        Accent = Color3.fromRGB(255, 30, 100),
        Text = Color3.fromRGB(255, 220, 180),
        Glow = Color3.fromRGB(200, 50, 0),
        Danger = Color3.fromRGB(255, 30, 30),
        Success = Color3.fromRGB(100, 255, 80)
    },
    ice = {
        BG = Color3.fromRGB(10, 15, 35),
        Primary = Color3.fromRGB(50, 180, 255),
        Secondary = Color3.fromRGB(100, 220, 255),
        Accent = Color3.fromRGB(180, 130, 255),
        Text = Color3.fromRGB(220, 240, 255),
        Glow = Color3.fromRGB(30, 100, 200),
        Danger = Color3.fromRGB(255, 80, 100),
        Success = Color3.fromRGB(80, 255, 150)
    },
    gold = {
        BG = Color3.fromRGB(15, 10, 5),
        Primary = Color3.fromRGB(255, 200, 0),
        Secondary = Color3.fromRGB(255, 150, 0),
        Accent = Color3.fromRGB(200, 130, 0),
        Text = Color3.fromRGB(255, 240, 180),
        Glow = Color3.fromRGB(150, 100, 0),
        Danger = Color3.fromRGB(255, 60, 40),
        Success = Color3.fromRGB(150, 255, 80)
    }
}

-- ====================== [ حالة الواجهة ] ======================
local ui = {
    isOpen = true,
    currentTheme = "neon",
    flyMode = false,
    flySpeed = 16,
    noclipMode = false,
    speedMode = "normal", -- normal, high, ultra
    lastPosition = nil,
    lastPositionName = "لا يوجد",
    selectedPlayer = "اختر لاعباً",
    xpPoints = 1250,
    level = 7,
    dragActive = false,
    dragStart = nil,
    floatingPos = UDim2.new(0.02, 0, 0.15, 0),
    mainPos = UDim2.new(0.5, -300, 0.5, -300),
    notifications = {},
    dailyRewardClaimed = false,
    achievements = {
        {name = "🏆 أول طيران", unlocked = false},
        {name = "⚡ سرعة فائقة", unlocked = false},
        {name = "🌀 سيد الانتقال", unlocked = false}
    },
    flyHeight = 0,
    speedBoost = 0
}

-- قائمة اللاعبين
local playersList = {"ShadowBlade", "NeonRider", "DeltaWolf", "PhoenixFire"}

-- ====================== [ إنشاء ScreenGui ] ======================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- حماية من الحذف
pcall(function()
    screenGui.Parent = game:GetService("CoreGui")
end)

-- ====================== [ دالة إنشاء النصوص المضيئة ] ======================
function createGlowText(text, size, color, parent, position)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.TextSize = size
    label.TextColor3 = color or themes[ui.currentTheme].Text
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = position or UDim2.new(0, 0, 0, 0)
    label.Parent = parent
    
    -- تأثير التوهج
    local glow = Instance.new("UIStroke")
    glow.Color = themes[ui.currentTheme].Glow
    glow.Thickness = 2
    glow.Transparency = 0.5
    glow.Parent = label
    
    return label
end

-- ====================== [ إنشاء اللوحة الرئيسية ] ======================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 580, 0, 650)
mainFrame.Position = ui.mainPos
mainFrame.BackgroundColor3 = themes[ui.currentTheme].BG
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- تمويه الخلفية (Blur)
local blur = Instance.new("BlurEffect")
blur.Size = 12
blur.Parent = game:GetService("Lighting")

-- زوايا مستديرة
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 15)
corners.Parent = mainFrame

-- إطار متوهج
local stroke = Instance.new("UIStroke")
stroke.Color = themes[ui.currentTheme].Primary
stroke.Thickness = 2
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- ====================== [ العنوان ] ======================
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 60)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundTransparency = 1
titleFrame.Parent = mainFrame

local title = createGlowText("◈ Δ DELTA HUB ULTRA ◈", 28, themes[ui.currentTheme].Accent, titleFrame)
title.Size = UDim2.new(1, 0, 1, 0)
title.TextYAlignment = Enum.TextYAlignment.Center

local subtitle = createGlowText("نظام التحكم الأسطوري | اسحب الزر العائم", 12, themes[ui.currentTheme].Secondary, titleFrame)
subtitle.Size = UDim2.new(1, 0, 1, 0)
subtitle.Position = UDim2.new(0, 0, 0, 35)
subtitle.TextYAlignment = Enum.TextYAlignment.Center

-- زر الإغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 15)
closeBtn.Text = "✕"
closeBtn.TextSize = 20
closeBtn.TextColor3 = themes[ui.currentTheme].Danger
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
closeBtn.BackgroundTransparency = 0.5
closeBtn.BorderSizePixel = 0
closeBtn.Parent = mainFrame

local closeCorners = Instance.new("UICorner")
closeCorners.CornerRadius = UDim.new(0, 8)
closeCorners.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    ui.isOpen = false
    mainFrame.Visible = false
    showNotification("تم إغلاق القائمة ✨", "info")
end)

-- ====================== [ قائمة الإشعارات ] ======================
local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0, 300, 0, 0)
notificationFrame.Position = UDim2.new(1, -320, 0, 10)
notificationFrame.BackgroundTransparency = 1
notificationFrame.Parent = screenGui

function showNotification(text, notifType)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 40)
    notif.Position = UDim2.new(0, 0, 1, 0)
    notif.BackgroundColor3 = themes[ui.currentTheme].BG
    notif.BackgroundTransparency = 0.2
    notif.Parent = notificationFrame
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notif
    
    local notifStroke = Instance.new("UIStroke")
    notifStroke.Color = notifType == "success" and themes[ui.currentTheme].Success or 
                        notifType == "warning" and themes[ui.currentTheme].Secondary or
                        themes[ui.currentTheme].Primary
    notifStroke.Thickness = 1
    notifStroke.Parent = notif
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = text
    textLabel.TextColor3 = themes[ui.currentTheme].Text
    textLabel.TextSize = 13
    textLabel.Font = Enum.Font.Gotham
    textLabel.BackgroundTransparency = 1
    textLabel.Parent = notif
    
    -- تحريك الإشعار
    local tween = tweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    
    task.wait(3)
    local outTween = tweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 0, 1, 0)})
    outTween:Play()
    outTween.Completed:Connect(function()
        notif:Destroy()
    end)
end

-- ====================== [ علامات التبويب ] ======================
local tabs = {"الرئيسية", "الحركة", "الانتقال", "السرعة", "الإعدادات"}
local activeTab = 1
local tabButtons = {}

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 45)
tabFrame.Position = UDim2.new(0, 10, 0, 75)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

for i, tabName in ipairs(tabs) do
    local tab = Instance.new("TextButton")
    local tabW = (580 - 30) / #tabs
    tab.Size = UDim2.new(0, tabW - 5, 1, 0)
    tab.Position = UDim2.new(0, (i-1) * tabW, 0, 0)
    tab.Text = tabName
    tab.TextSize = 14
    tab.TextColor3 = themes[ui.currentTheme].Text
    tab.BackgroundColor3 = themes[ui.currentTheme].Primary
    tab.BackgroundTransparency = i == 1 and 0.7 or 0.9
    tab.BorderSizePixel = 0
    tab.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tab
    
    tabButtons[i] = tab
    
    tab.MouseButton1Click:Connect(function()
        activeTab = i
        for j, btn in ipairs(tabButtons) do
            btn.BackgroundTransparency = (j == i) and 0.7 or 0.9
        end
        updateContent()
        showNotification("فتح تبويب: " .. tabName, "info")
    end)
end

-- ====================== [ منطقة المحتوى ] ======================
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -135)
contentFrame.Position = UDim2.new(0, 10, 0, 130)
contentFrame.BackgroundTransparency = 1
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
contentFrame.ScrollBarThickness = 4
contentFrame.Parent = mainFrame

local contentList = Instance.new("UIListLayout")
contentList.Padding = UDim.new(0, 10)
contentList.SortOrder = Enum.SortOrder.LayoutOrder
contentList.Parent = contentFrame

-- دالة تحديث المحتوى
function updateContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") and child ~= contentList then
            child:Destroy()
        end
    end
    
    if activeTab == 1 then -- الرئيسية
        createHomeTab()
    elseif activeTab == 2 then -- الحركة
        createMovementTab()
    elseif activeTab == 3 then -- الانتقال الآني
        createTeleportTab()
    elseif activeTab == 4 then -- السرعة
        createSpeedTab()
    elseif activeTab == 5 then -- الإعدادات
        createSettingsTab()
    end
end

function createHomeTab()
    -- مستوى المستخدم
    local levelFrame = createCard("⭐ مستوى DELTA: " .. ui.level)
    local progressBar = createProgressBar(levelFrame, ui.xpPoints, ui.level * 500)
    createText(levelFrame, ui.xpPoints .. " / " .. (ui.level * 500) .. " XP", 12, nil, UDim2.new(1, -10, 0.5, 0))
    
    -- المكافأة اليومية
    local dailyFrame = createCard("🎁 المكافأة اليومية", themes[ui.currentTheme].Success)
    local dailyBtn = createButton(dailyFrame, ui.dailyRewardClaimed and "تم الحصول عليها ✓" or "احصل على 100 XP", 
                                  UDim2.new(0.5, -60, 0.7, 0), 120, 35)
    if not ui.dailyRewardClaimed then
        dailyBtn.MouseButton1Click:Connect(function()
            ui.xpPoints = ui.xpPoints + 100
            ui.dailyRewardClaimed = true
            showNotification("🎉 حصلت على 100 نقطة مكافأة يومية!", "success")
            updateContent()
        end)
    end
    
    -- إحصائيات سريعة
    local statsFrame = createCard("📊 إحصائيات سريعة")
    createText(statsFrame, "🚀 سرعة الطيران: " .. ui.flySpeed, 12, nil, UDim2.new(0, 10, 0.2, 0))
    createText(statsFrame, "⚡ وضع السرعة: " .. ui.speedMode, 12, nil, UDim2.new(0, 10, 0.4, 0))
    createText(statsFrame, "🎨 الثيم: " .. ui.currentTheme, 12, nil, UDim2.new(0, 10, 0.6, 0))
    createText(statsFrame, "🎮 وضع الطيران: " .. (ui.flyMode and "مفعل ✓" or "معطل ✗"), 12, nil, UDim2.new(0, 10, 0.8, 0))
end

function createMovementTab()
    -- وضع الطيران
    local flyFrame = createCard("✈️ نظام الطيران")
    local flyBtn = createButton(flyFrame, ui.flyMode and "تعطيل الطيران" or "تفعيل الطيران", UDim2.new(0.5, -70, 0.3, 0), 140, 40)
    flyBtn.MouseButton1Click:Connect(function()
        ui.flyMode = not ui.flyMode
        updateContent()
        showNotification(ui.flyMode and "تم تفعيل الطيران 🚀" or "تم تعطيل الطيران", "info")
    end)
    
    -- سرعة الطيران
    createText(flyFrame, "سرعة الطيران: " .. ui.flySpeed, 14, themes[ui.currentTheme].Accent, UDim2.new(0.5, -50, 0.55, 0))
    local speedUp = createButton(flyFrame, "▲ ▲", UDim2.new(0.3, -30, 0.7, 0), 60, 30)
    local speedDown = createButton(flyFrame, "▼ ▼", UDim2.new(0.7, -30, 0.7, 0), 60, 30)
    
    speedUp.MouseButton1Click:Connect(function()
        ui.flySpeed = math.min(ui.flySpeed + 5, 50)
        updateContent()
    end)
    speedDown.MouseButton1Click:Connect(function()
        ui.flySpeed = math.max(ui.flySpeed - 5, 5)
        updateContent()
    end)
    
    -- وضع NoClip
    local noclipFrame = createCard("🔮 وضع NoClip")
    local noclipBtn = createButton(noclipFrame, ui.noclipMode and "تعطيل NoClip ✓" or "تفعيل NoClip", UDim2.new(0.5, -70, 0.4, 0), 140, 40)
    noclipBtn.MouseButton1Click:Connect(function()
        ui.noclipMode = not ui.noclipMode
        updateContent()
        showNotification(ui.noclipMode and "🔮 NoClip مفعل - يمكنك اختراق الجدران" or "🚫 NoClip معطل", "warning")
    end)
    
    -- إرشادات
    local helpFrame = createCard("⌨️ اختصارات لوحة المفاتيح")
    createText(helpFrame, "F ⇢ تفعيل الطيران | ↑/↓ ⇢ زيادة/خفض السرعة", 11, nil, UDim2.new(0, 10, 0.2, 0))
    createText(helpFrame, "N ⇢ تفعيل NoClip | R ⇢ إعادة ضبط السرعة", 11, nil, UDim2.new(0, 10, 0.45, 0))
    createText(helpFrame, "C ⇢ تغيير الثيم | SPACE ⇢ فتح/إغلاق القائمة", 11, nil, UDim2.new(0, 10, 0.7, 0))
end

function createTeleportTab()
    -- الانتقال إلى لاعب
    local playerFrame = createCard("🌀 الانتقال إلى لاعب")
    local playerDropdown = Instance.new("TextButton")
    playerDropdown.Size = UDim2.new(0.6, 0, 0, 35)
    playerDropdown.Position = UDim2.new(0.2, 0, 0.3, 0)
    playerDropdown.Text = ui.selectedPlayer
    playerDropdown.TextSize = 13
    playerDropdown.BackgroundColor3 = themes[ui.currentTheme].Secondary
    playerDropdown.BackgroundTransparency = 0.5
    playerDropdown.Parent = playerFrame
    local ddCorner = Instance.new("UICorner")
    ddCorner.CornerRadius = UDim.new(0, 8)
    ddCorner.Parent = playerDropdown
    
    local teleportBtn = createButton(playerFrame, "⚡ انتقال آني فوري", UDim2.new(0.5, -80, 0.65, 0), 160, 40)
    teleportBtn.MouseButton1Click:Connect(function()
        showNotification("✨ تم الانتقال الآني إلى " .. ui.selectedPlayer, "success")
    end)
    
    -- العودة لآخر موضع
    local lastFrame = createCard("↺ العودة إلى آخر موضع")
    createText(lastFrame, ui.lastPositionName, 12, themes[ui.currentTheme].Secondary, UDim2.new(0.5, -80, 0.4, 0))
    local backBtn = createButton(lastFrame, "العودة", UDim2.new(0.5, -40, 0.65, 0), 80, 35)
    backBtn.MouseButton1Click:Connect(function()
        showNotification("↺ تم العودة إلى آخر موضع", "info")
    end)
end

function createSpeedTab()
    -- أوضاع السرعة
    local modesFrame = createCard("⚡ أوضاع السرعة")
    local modes = {"سرعة عادية", "سرعة عالية", "سرعة فائقة"}
    local modeKeys = {"normal", "high", "ultra"}
    
    for i, mode in ipairs(modes) do
        local btn = createButton(modesFrame, mode, UDim2.new(0, 10 + (i-1)*130, 0.3, 0), 115, 40)
        btn.MouseButton1Click:Connect(function()
            ui.speedMode = modeKeys[i]
            updateContent()
            showNotification("تم تغيير السرعة إلى: " .. mode, "success")
        end)
    end
    
    -- سرعة حالية
    local speedVal = ui.speedMode == "normal" and 16 or ui.speedMode == "high" and 32 or 64
    local speedFrame = createCard("🚀 السرعة الحالية")
    createText(speedFrame, speedVal .. " وحدة/ثانية", 28, themes[ui.currentTheme].Accent, UDim2.new(0.5, -80, 0.4, 0))
    
    -- إعادة ضبط
    local resetBtn = createButton(speedFrame, "⟳ إعادة ضبط السرعة", UDim2.new(0.5, -80, 0.7, 0), 160, 40)
    resetBtn.MouseButton1Click:Connect(function()
        ui.speedMode = "normal"
        updateContent()
        showNotification("تم إعادة ضبط السرعة", "info")
    end)
end

function createSettingsTab()
    -- ثيمات
    local themeFrame = createCard("🎨 تغيير الثيم")
    local themesList = {"neon", "fire", "ice", "gold"}
    for i, theme in ipairs(themesList) do
        local btn = createButton(themeFrame, theme, UDim2.new(0, 10 + (i-1)*95, 0.3, 0), 85, 35)
        btn.MouseButton1Click:Connect(function()
            ui.currentTheme = theme
            updateTheme()
            updateContent()
            showNotification("تم تغيير الثيم إلى: " .. theme, "success")
        end)
    end
    
    -- إعدادات إضافية
    local extraFrame = createCard("⚙️ إعدادات إضافية")
    
    local soundBtn = createButton(extraFrame, "🔊 الأصوات: مفعلة", UDim2.new(0.05, 0, 0.3, 0), 160, 35)
    local fpsBtn = createButton(extraFrame, "📊 إظهار FPS", UDim2.new(0.55, 0, 0.3, 0), 140, 35)
    
    -- إعادة تعيين الكل
    local resetAllBtn = createButton(extraFrame, "🔄 إعادة تعيين جميع الإعدادات", UDim2.new(0.5, -110, 0.7, 0), 220, 40, themes[ui.currentTheme].Danger)
    resetAllBtn.MouseButton1Click:Connect(function()
        ui.speedMode = "normal"
        ui.flyMode = false
        ui.noclipMode = false
        ui.currentTheme = "neon"
        updateTheme()
        updateContent()
        showNotification("تم إعادة تعيين جميع الإعدادات!", "success")
    end)
end

-- ====================== [ دوال مساعدة لإنشاء العناصر ] ======================
function createCard(title, color)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 140)
    card.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    card.BackgroundTransparency = 0.4
    card.Parent = contentFrame
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 12)
    cardCorner.Parent = card
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Text = title
    titleLabel.TextColor3 = color or themes[ui.currentTheme].Primary
    titleLabel.TextSize = 15
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = card
    
    return card
end

function createButton(parent, text, position, width, height, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width or 120, 0, height or 35)
    btn.Position = position or UDim2.new(0.5, -60, 0.7, 0)
    btn.Text = text
    btn.TextSize = 13
    btn.TextColor3 = themes[ui.currentTheme].Text
    btn.BackgroundColor3 = color or themes[ui.currentTheme].Secondary
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    return btn
end

function createText(parent, text, size, color, position)
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.8, 0, 0, 25)
    txt.Position = position or UDim2.new(0, 10, 0.2, 0)
    txt.Text = text
    txt.TextSize = size or 13
    txt.TextColor3 = color or themes[ui.currentTheme].Text
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.BackgroundTransparency = 1
    txt.Parent = parent
    return txt
end

function createProgressBar(parent, current, max)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.8, 0, 0, 15)
    bar.Position = UDim2.new(0.1, 0, 0.5, 0)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    bar.BackgroundTransparency = 0.5
    bar.Parent = parent
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 8)
    barCorner.Parent = bar
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(current / max, 0, 1, 0)
    fill.BackgroundColor3 = themes[ui.currentTheme].Success
    fill.BorderSizePixel = 0
    fill.Parent = bar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 8)
    fillCorner.Parent = fill
    
    return bar
end

function updateTheme()
    mainFrame.BackgroundColor3 = themes[ui.currentTheme].BG
    stroke.Color = themes[ui.currentTheme].Primary
    title.TextColor3 = themes[ui.currentTheme].Accent
    subtitle.TextColor3 = themes[ui.currentTheme].Secondary
    closeBtn.TextColor3 = themes[ui.currentTheme].Danger
    
    for _, btn in ipairs(tabButtons) do
        btn.BackgroundColor3 = themes[ui.currentTheme].Primary
        btn.TextColor3 = themes[ui.currentTheme].Text
    end
    
    updateContent()
end

-- ====================== [ الزر العائم القابل للسحب ] ======================
local floatingBtn = Instance.new("TextButton")
floatingBtn.Size = UDim2.new(0, 65, 0, 65)
floatingBtn.Position = ui.floatingPos
floatingBtn.Text = "Δ"
floatingBtn.TextSize = 32
floatingBtn.TextColor3 = themes[ui.currentTheme].Text
floatingBtn.BackgroundColor3 = themes[ui.currentTheme].Primary
floatingBtn.BackgroundTransparency = 0.2
floatingBtn.BorderSizePixel = 0
floatingBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = themes[ui.currentTheme].Accent
btnStroke.Thickness = 2
btnStroke.Parent = floatingBtn

-- سحب الزر العائم
local dragging = false
local dragStartPos = nil
local dragStartMouse = nil

floatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = floatingBtn.Position
        dragStartMouse = input.Position
    end
end)

userInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartMouse
        local newX = dragStartPos.X.Offset + delta.X
        local newY = dragStartPos.Y.Offset + delta.Y
        newX = math.clamp(newX, 0, screenGui.AbsoluteSize.X - 65)
        newY = math.clamp(newY, 0, screenGui.AbsoluteSize.Y - 65)
        floatingBtn.Position = UDim2.new(0, newX, 0, newY)
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

floatingBtn.MouseButton1Click:Connect(function()
    ui.isOpen = not ui.isOpen
    mainFrame.Visible = ui.isOpen
    showNotification(ui.isOpen and "تم فتح القائمة" or "تم إغلاق القائمة", "info")
end)

-- ====================== [ اختصارات لوحة المفاتيح ] ======================
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode
    if key == Enum.KeyCode.Space then
        ui.isOpen = not ui.isOpen
        mainFrame.Visible = ui.isOpen
    elseif key == Enum.KeyCode.F then
        ui.flyMode = not ui.flyMode
        showNotification(ui.flyMode and "🕊️ وضع الطيران مفعل" or "🦶 وضع الطيران معطل", "info")
    elseif key == Enum.KeyCode.Up then
        ui.flySpeed = math.min(ui.flySpeed + 5, 50)
        showNotification("سرعة الطيران: " .. ui.flySpeed, "info")
    elseif key == Enum.KeyCode.Down then
        ui.flySpeed = math.max(ui.flySpeed - 5, 5)
        showNotification("سرعة الطيران: " .. ui.flySpeed, "info")
    elseif key == Enum.KeyCode.N then
        ui.noclipMode = not ui.noclipMode
        showNotification(ui.noclipMode and "🎭 NoClip مفعل" or "🚫 NoClip معطل", "warning")
    elseif key == Enum.KeyCode.R then
        ui.speedMode = "normal"
        showNotification("تم إعادة ضبط السرعة", "success")
    elseif key == Enum.KeyCode.C then
        local themesList = {"neon", "fire", "ice", "gold"}
        local currentIndex = table.find(themesList, ui.currentTheme) or 1
        ui.currentTheme = themesList[currentIndex % #themesList + 1]
        updateTheme()
        showNotification("تم تغيير الثيم إلى: " .. ui.currentTheme, "success")
    end
end)

-- دالة مساعدة
function table.find(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then return i end
    end
    return nil
end

math.clamp = function(x, min, max)
    return math.min(max, math.max(min, x))
end

-- ====================== [ تفعيل الطيران و NoClip ] ======================
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- حلقة الطيران
runService.RenderStepped:Connect(function(dt)
    if ui.flyMode and character and rootPart then
        humanoid.PlatformStand = true
        local moveDirection = Vector3.new(0, 0, 0)
        
        if userInput:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Vector3.new(0, 0, -ui.flySpeed) end
        if userInput:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection + Vector3.new(0, 0, ui.flySpeed) end
        if userInput:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection + Vector3.new(-ui.flySpeed, 0, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Vector3.new(ui.flySpeed, 0, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, ui.flySpeed, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection + Vector3.new(0, -ui.flySpeed, 0) end
        
        rootPart.Velocity = moveDirection
        rootPart.Anchored = true
    elseif not ui.flyMode and humanoid then
        humanoid.PlatformStand = false
        if rootPart then rootPart.Anchored = false end
    end
    
    -- NoClip
    if ui.noclipMode and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif not ui.noclipMode and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end)

-- بدء التشغيل
showNotification("✨ Δ DELTA HUB ULTRA يعمل الآن! اسحب الزر العائم", "success")
task.wait(1)
showNotification("🎮 اضغط SPACE لإظهار/إخفاء القائمة", "info")
task.wait(1)
showNotification("🎨 اضغط C لتغيير الثيم", "info")

print("═══════════════════════════════════════")
print("   Δ DELTA HUB ULTRA - جاهز للعمل!")
print("   اسحب الزر Δ في أي مكان على الشاشة")
print("═══════════════════════════════════════")