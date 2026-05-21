-- ============================================================================
--  DELTA HUB ULTRA - واجهة مستخدم أسطورية مع كل الميزات المطلوبة
--  إصدار: Delta Xtreme v3.0
--  اللغات: Lua (متوافقة مع Love2D, FiveM, Roblox)
-- ============================================================================

-- ====================== [ إعدادات النافذة ] ======================
local window = {
    width = 1366,
    height = 768,
    title = "Δ DELTA HUB ULTRA | واجهة المستقبل"
}

-- ====================== [ نظام الألوان المتقدم ] ======================
local themes = {
    neon = {
        name = "نيون أخضر-أزرق",
        bg = {0.05, 0.05, 0.10, 0.96},
        primary = {0.00, 1.00, 0.80, 1.0},    -- أخضر نيون
        secondary = {0.40, 0.20, 1.00, 1.0},  -- أزرق بنفسجي
        accent = {1.00, 0.20, 0.80, 1.0},     -- وردي نيون
        text = {1.0, 1.0, 1.0, 1.0},
        border = {0.00, 0.90, 0.70, 0.9},
        glow = {0.00, 0.50, 0.40, 0.4},
        success = {0.00, 0.80, 0.40, 1.0},
        warning = {1.00, 0.60, 0.00, 1.0},
        danger = {1.00, 0.20, 0.20, 1.0}
    },
    fire = {
        name = "نار البركان",
        bg = {0.08, 0.03, 0.02, 0.96},
        primary = {1.00, 0.30, 0.00, 1.0},
        secondary = {1.00, 0.60, 0.00, 1.0},
        accent = {1.00, 0.00, 0.40, 1.0},
        text = {1.0, 0.85, 0.70, 1.0},
        border = {1.00, 0.40, 0.00, 0.9},
        glow = {0.80, 0.20, 0.00, 0.3},
        success = {0.50, 1.00, 0.30, 1.0},
        warning = {1.00, 0.80, 0.00, 1.0},
        danger = {1.00, 0.20, 0.00, 1.0}
    },
    ice = {
        name = "جليد قطبي",
        bg = {0.02, 0.05, 0.12, 0.95},
        primary = {0.20, 0.70, 1.00, 1.0},
        secondary = {0.50, 0.90, 1.00, 1.0},
        accent = {0.80, 0.50, 1.00, 1.0},
        text = {0.85, 0.95, 1.00, 1.0},
        border = {0.30, 0.80, 1.00, 0.8},
        glow = {0.10, 0.40, 0.70, 0.3},
        success = {0.30, 0.90, 0.50, 1.0},
        warning = {1.00, 0.90, 0.30, 1.0},
        danger = {1.00, 0.40, 0.50, 1.0}
    },
    gold = {
        name = "ذهب أسطوري",
        bg = {0.06, 0.04, 0.02, 0.97},
        primary = {1.00, 0.80, 0.00, 1.0},
        secondary = {1.00, 0.60, 0.00, 1.0},
        accent = {0.80, 0.60, 0.00, 1.0},
        text = {1.00, 0.90, 0.50, 1.0},
        border = {1.00, 0.70, 0.00, 0.9},
        glow = {0.60, 0.40, 0.00, 0.4},
        success = {0.50, 0.90, 0.30, 1.0},
        warning = {1.00, 0.70, 0.00, 1.0},
        danger = {1.00, 0.30, 0.20, 1.0}
    },
    galaxy = {
        name = "مجرة درب التبانة",
        bg = {0.02, 0.01, 0.05, 0.98},
        primary = {0.60, 0.20, 1.00, 1.0},
        secondary = {0.80, 0.30, 0.90, 1.0},
        accent = {0.30, 0.10, 0.80, 1.0},
        text = {0.90, 0.80, 1.00, 1.0},
        border = {0.70, 0.30, 1.00, 0.8},
        glow = {0.30, 0.10, 0.50, 0.4},
        success = {0.40, 0.80, 0.90, 1.0},
        warning = {1.00, 0.50, 0.00, 1.0},
        danger = {1.00, 0.20, 0.40, 1.0}
    }
}

-- ====================== [ الحالة العامة للواجهة ] ======================
local ui = {
    isOpen = true,
    dragActive = false,
    dragX = 0, dragY = 0,
    floatingX = 100,
    floatingY = 100,
    panelX = 0, panelY = 0,
    panelWidth = 580,
    panelHeight = 620,
    currentTheme = "neon",
    soundEnabled = true,
    musicEnabled = true,
    mode = "computer",
    uiLocked = false,
    
    -- إعدادات الحركة
    flyMode = false,
    flySpeed = 5,
    flyHeight = 0,
    noclipMode = false,
    speedMode = "normal",
    customSpeed = 16,
    
    -- الانتقال الآني
    lastPosition = nil,
    lastPositionName = "لا يوجد",
    selectedPlayer = "✧ اختر لاعباً ✧",
    teleportHistory = {},
    waypoints = {},
    
    -- الإعدادات المتقدمة
    transparency = 0.95,
    animationSpeed = 0.15,
    showFPS = true,
    showCoordinates = true,
    particleEffects = true,
    soundVolume = 70,
    language = "AR",
    notifications = {},
    
    -- الميزات الإضافية
    xpPoints = 1250,
    level = 7,
    achievements = {},
    dailyReward = 0,
    lastDaily = nil
}

-- ====================== [ علامات التبويب الرئيسية ] ======================
local tabs = {
    {icon = "🏠", name = "الرئيسية", id = 1},
    {icon = "✈️", name = "الحركة", id = 2},
    {icon = "🌀", name = "الانتقال الآني", id = 3},
    {icon = "⚡", name = "السرعة", id = 4},
    {icon = "🎮", name = "الألعاب", id = 5},
    {icon = "🎨", name = "المظهر", id = 6},
    {icon = "⚙️", name = "الإعدادات", id = 7}
}
local activeTab = 1

-- ====================== [ قائمة اللاعبين ] ======================
local playersList = {
    {name = "ShadowBlade", level = 99, status = "متصل", rank = "أسطوري"},
    {name = "NeonRider", level = 52, status = "متصل", rank = "محارب"},
    {name = "DeltaWolf", level = 34, status = "غير متصل", rank = "خبير"},
    {name = "PhoenixFire", level = 87, status = "متصل", rank = "نخبة"},
    {name = "CyberKnight", level = 45, status = "متصل", rank = "محارب"},
    {name = "MysticSoul", level = 28, status = "غير متصل", rank = "مبتدئ"},
    {name = "ThunderGod", level = 100, status = "متصل", rank = "أسطوري ⚡"},
    {name = "IceQueen", level = 73, status = "متصل", rank = "نخبة"}
}

-- ====================== [ قائمة المهام اليومية ] ======================
local dailyQuests = {
    {name = "🏃 تحرك 1000 خطوة", progress = 0, target = 1000, reward = 50, completed = false},
    {name = "⚡ استخدم سرعة فائقة 5 مرات", progress = 0, target = 5, reward = 100, completed = false},
    {name = "🌀 انتقال آني إلى لاعب", progress = 0, target = 3, reward = 75, completed = false},
    {name = "✨ غيّر المظهر 3 مرات", progress = 0, target = 3, reward = 60, completed = false}
}

-- ====================== [ دوال مساعدة متقدمة ] ======================
function getColor(name)
    return themes[ui.currentTheme][name]
end

function showNotification(text, type)
    table.insert(ui.notifications, {text = text, type = type or "info", time = 3})
end

function playSound(soundName)
    if ui.soundEnabled then
        print("[🎵 صوت] " .. soundName)
        -- love.audio.play(sounds[soundName]) -- تفعيل عند وجود مكتبة صوتية
    end
end

function drawGlowText(text, x, y, align, size, color, glowIntensity)
    local intensity = glowIntensity or 3
    love.graphics.setFont(love.graphics.newFont(size or 16))
    for i = 1, intensity do
        love.graphics.setColor(getColor("glow")[1], getColor("glow")[2], getColor("glow")[3], 0.2 / i)
        love.graphics.printf(text, x + i/2, y + i/2, love.graphics.getWidth(), align)
    end
    love.graphics.setColor(color or getColor("text"))
    love.graphics.printf(text, x, y, love.graphics.getWidth(), align)
end

function drawNeonBox(x, y, w, h, radius, color, glow)
    love.graphics.setColor(getColor(glow or "glow"))
    love.graphics.rectangle("fill", x-3, y-3, w+6, h+6, radius+2)
    love.graphics.setColor(color or getColor("primary"))
    love.graphics.rectangle("fill", x, y, w, h, radius)
    love.graphics.setColor(getColor("border"))
    love.graphics.rectangle("line", x, y, w, h, radius)
end

function drawProgressBar(x, y, w, h, progress, max, color)
    local percent = math.min(1, progress / max)
    love.graphics.setColor(0.2, 0.2, 0.3, 0.5)
    love.graphics.rectangle("fill", x, y, w, h, 5)
    love.graphics.setColor(color or getColor("success"))
    love.graphics.rectangle("fill", x, y, w * percent, h, 5)
    love.graphics.setColor(getColor("text"))
    love.graphics.print(string.format("%d/%d", progress, max), x + 5, y + 3)
end

-- ====================== [ لوحة الإشعارات ] ======================
function drawNotifications()
    local yOffset = 10
    for i = #ui.notifications, 1, -1 do
        local notif = ui.notifications[i]
        local alpha = math.min(1, notif.time)
        local color = notif.type == "success" and getColor("success") or 
                      notif.type == "warning" and getColor("warning") or
                      notif.type == "error" and getColor("danger") or getColor("primary")
        love.graphics.setColor(color[1], color[2], color[3], alpha * 0.9)
        love.graphics.rectangle("fill", love.graphics.getWidth() - 320, yOffset, 300, 40, 8)
        love.graphics.setColor(getColor("text"))
        love.graphics.print(notif.text, love.graphics.getWidth() - 310, yOffset + 12)
        notif.time = notif.time - 0.02
        if notif.time <= 0 then
            table.remove(ui.notifications, i)
        end
        yOffset = yOffset + 50
    end
end

-- ====================== [ اللوحة الرئيسية ] ======================
function drawMainPanel()
    local x, y = ui.panelX, ui.panelY
    local w, h = ui.panelWidth, ui.panelHeight
    
    love.graphics.setColor(getColor("bg")[1], getColor("bg")[2], getColor("bg")[3], ui.transparency)
    love.graphics.rectangle("fill", x, y, w, h, 20)
    drawNeonBox(x, y, w, h, 20, getColor("primary"), "glow")
    
    -- الهيدر المميز
    love.graphics.setFont(love.graphics.newFont(32))
    drawGlowText("◈ Δ DELTA HUB ULTRA ◈", x + w/2, y + 18, "center", 32, getColor("accent"), 4)
    love.graphics.setFont(love.graphics.newFont(12))
    drawGlowText("النسخة الأسطورية 3.0 | بوابتك للعوالم الموازية", x + w/2, y + 55, "center", 12, getColor("secondary"))
    
    -- زر الإغلاق
    love.graphics.setColor(getColor("danger"))
    love.graphics.rectangle("fill", x + w - 40, y + 12, 28, 28, 6)
    drawGlowText("✕", x + w - 32, y + 15, "left", 20, getColor("text"))
    
    -- علامات التبويب
    local tabY = y + 82
    local tabW = (w - 30) / #tabs
    for i, tab in ipairs(tabs) do
        local tabX = x + 15 + (i-1) * tabW
        local isActive = (activeTab == i)
        if isActive then
            love.graphics.setColor(getColor("primary"))
            love.graphics.rectangle("fill", tabX, tabY, tabW - 2, 40, 8)
        else
            love.graphics.setColor(0.15, 0.15, 0.25, 0.7)
            love.graphics.rectangle("fill", tabX, tabY, tabW - 2, 40, 8)
        end
        drawGlowText(tab.icon .. " " .. tab.name, tabX + (tabW-2)/2, tabY + 12, "center", 13, 
                    isActive and getColor("text") or {0.7, 0.7, 0.8, 1})
    end
    
    -- المحتوى حسب التبويب
    local contentY = y + 135
    local contentW = w - 30
    if activeTab == 1 then drawHomeTab(x + 15, contentY, contentW, y + h - 30)
    elseif activeTab == 2 then drawMovementTab(x + 15, contentY, contentW)
    elseif activeTab == 3 then drawTeleportTab(x + 15, contentY, contentW)
    elseif activeTab == 4 then drawSpeedTab(x + 15, contentY, contentW)
    elseif activeTab == 5 then drawGamesTab(x + 15, contentY, contentW)
    elseif activeTab == 6 then drawAppearanceTab(x + 15, contentY, contentW)
    elseif activeTab == 7 then drawSettingsTab(x + 15, contentY, contentW, y + h - 30)
    end
end

-- ====================== [ تبويب الرئيسية ] ======================
function drawHomeTab(x, y, w, bottomY)
    -- مستوى المستخدم
    love.graphics.setColor(getColor("secondary"))
    love.graphics.rectangle("fill", x, y, w, 80, 12)
    drawGlowText("⭐ مستوى DELTA: " .. ui.level, x + 20, y + 12, "left", 18)
    drawProgressBar(x + 20, y + 38, w - 40, 18, ui.xpPoints, (ui.level * 500), getColor("accent"))
    drawGlowText(ui.xpPoints .. " / " .. (ui.level * 500) .. " XP", x + w - 30, y + 38, "right", 11)
    
    -- المكافأة اليومية
    local rewardY = y + 95
    drawNeonBox(x, rewardY, w, 50, 10, getColor("primary"))
    drawGlowText("🎁 المكافأة اليومية: " .. (ui.dailyReward > 0 and ui.dailyReward .. " نقطة" or "لم تحصل بعد"), 
                x + w/2, rewardY + 18, "center", 14)
    
    -- المهام اليومية
    local questY = rewardY + 65
    drawGlowText("📋 المهام اليومية", x, questY, "left", 16)
    for i, quest in ipairs(dailyQuests) do
        local qY = questY + 30 + (i-1) * 42
        drawProgressBar(x, qY, w - 100, 20, quest.progress, quest.target, getColor("warning"))
        drawGlowText(quest.name, x, qY - 14, "left", 11)
        drawGlowText("+" .. quest.reward, x + w - 90, qY + 3, "right", 11, getColor("success"))
    end
    
    -- إحصائيات سريعة
    local statsY = bottomY - 85
    love.graphics.setColor(getColor("bg"))
    love.graphics.rectangle("fill", x, statsY, w, 70, 10)
    drawGlowText("🚀 سرعة الطيران: " .. ui.flySpeed, x + 15, statsY + 12, "left", 12)
    drawGlowText("⚡ وضع السرعة: " .. ui.speedMode, x + 180, statsY + 12, "left", 12)
    drawGlowText("🎨 الثيم: " .. themes[ui.currentTheme].name, x + 15, statsY + 35, "left", 12)
    drawGlowText("👥 متصلين: " .. playersCount(), x + 180, statsY + 35, "left", 12)
end

function playersCount()
    local count = 0
    for _, p in ipairs(playersList) do
        if p.status == "متصل" then count = count + 1 end
    end
    return count
end

-- ====================== [ تبويب الحركة ] ======================
function drawMovementTab(x, y, w)
    drawGlowText("✈️ نظام التحكم بالحركة المتقدم ✈️", x + w/2, y, "center", 18)
    
    -- وضع الطيران
    local btnY = y + 40
    drawNeonBox(x, btnY, w, 50, 10, ui.flyMode and getColor("success") or getColor("primary"))
    drawGlowText(ui.flyMode and "✅ الطيران مفعل" or "❌ الطيران معطل", x + w/2, btnY + 18, "center", 16)
    
    -- سرعة الطيران
    drawGlowText("سرعة الطيران الحالية: " .. ui.flySpeed, x + w/2, btnY + 70, "center", 14)
    love.graphics.setColor(getColor("primary"))
    love.graphics.rectangle("fill", x + w/2 - 100, btnY + 90, 200, 35, 8)
    drawGlowText("▲ للأعلى    ▼ للأسفل", x + w/2, btnY + 112, "center", 12)
    
    -- وضع NoClip
    local noclipY = btnY + 145
    drawNeonBox(x, noclipY, w, 45, 10, ui.noclipMode and getColor("accent") or getColor("secondary"))
    drawGlowText("🔮 وضع NoClip: " .. (ui.noclipMode and "مفعل - اختراق الجدران" or "معطل"), x + w/2, noclipY + 16, "center", 14)
    
    -- حركة حرة - عصا التحكم
    local joystickY = noclipY + 65
    drawGlowText("🎮 عصا التحكم السريع", x, joystickY, "left", 14)
    local cx, cy = x + w/2, joystickY + 50
    love.graphics.setColor(0.2, 0.2, 0.3, 0.8)
    love.graphics.circle("fill", cx, cy, 50)
    love.graphics.setColor(getColor("primary"))
    love.graphics.circle("line", cx, cy, 50)
    love.graphics.setColor(getColor("accent"))
    love.graphics.circle("fill", cx + 20, cy - 15, 10)
    
    drawGlowText("WASD أو الأسهم للتحرك", x + w/2, cy + 65, "center", 11)
end

-- ====================== [ تبويب الانتقال الآني ] ======================
function drawTeleportTab(x, y, w)
    drawGlowText("🌀 نظام الانتقال الآني الفوري 🌀", x + w/2, y, "center", 18)
    
    -- الانتقال إلى لاعب
    local playerY = y + 45
    drawNeonBox(x, playerY, w, 55, 10, getColor("primary"))
    drawGlowText("الانتقال إلى لاعب:", x + w/2, playerY + 15, "center", 13)
    drawGlowText("► " .. ui.selectedPlayer .. " ◄", x + w/2, playerY + 38, "center", 14, getColor("accent"))
    
    -- زر الانتقال الفوري
    local teleY = playerY + 70
    drawNeonBox(x + w/2 - 110, teleY, 220, 45, 10, getColor("secondary"))
    drawGlowText("⚡ انتقال آني فوري ⚡", x + w/2, teleY + 28, "center", 16)
    
    -- العودة لآخر موضع
    local lastY = teleY + 60
    drawNeonBox(x + w/2 - 90, lastY, 180, 40, 10, getColor("warning"))
    drawGlowText("↺ العودة إلى آخر موضع", x + w/2, lastY + 26, "center", 13)
    drawGlowText(ui.lastPositionName, x + w/2, lastY + 54, "center", 10)
    
    -- نقاط الوايبوينت
    local wayY = lastY + 80
    drawGlowText("📍 نقاط الوايبوينت المحفوظة", x, wayY, "left", 13)
    for i = 1, 3 do
        drawNeonBox(x + (i-1) * 110, wayY + 25, 95, 30, 8, getColor("glow"))
        drawGlowText("نقطة " .. i, x + (i-1) * 110 + 47, wayY + 47, "center", 11)
    end
end

-- ====================== [ تبويب السرعة ] ======================
function drawSpeedTab(x, y, w)
    drawGlowText("⚡ نظام تعزيز السرعة ⚡", x + w/2, y, "center", 18)
    
    local modes = {
        {name = "سرعة عادية", key = "normal", speed = 16, icon = "🐢"},
        {name = "سرعة عالية", key = "high", speed = 32, icon = "🐎"},
        {name = "سرعة فائقة", key = "ultra", speed = 64, icon = "⚡"}
    }
    
    local btnW = (w - 40) / 3
    for i, mode in ipairs(modes) do
        local isActive = ui.speedMode == mode.key
        drawNeonBox(x + 10 + (i-1)*(btnW+10), y + 45, btnW, 60, 10, 
                   isActive and getColor("success") or getColor("primary"))
        drawGlowText(mode.icon, x + 10 + (i-1)*(btnW+10) + btnW/2, y + 60, "center", 22)
        drawGlowText(mode.name, x + 10 + (i-1)*(btnW+10) + btnW/2, y + 90, "center", 11)
    end
    
    -- مؤشر السرعة
    drawGlowText("🚀 السرعة الحالية", x + w/2, y + 130, "center", 14)
    local speedVal = ui.speedMode == "normal" and 16 or ui.speedMode == "high" and 32 or 64
    drawGlowText(string.format("%d وحدة/ثانية", speedVal), x + w/2, y + 155, "center", 28, getColor("accent"))
    
    -- إعادة ضبط السرعة
    drawNeonBox(x + w/2 - 100, y + 185, 200, 42, 10, getColor("warning"))
    drawGlowText("⟳ إعادة ضبط السرعة ⟳", x + w/2, y + 208, "center", 14)
    
    -- سرعة مخصصة
    drawGlowText("سرعة مخصصة: " .. ui.customSpeed, x + w/2, y + 250, "center", 12)
end

-- ====================== [ تبويب الألعاب ] ======================
function drawGamesTab(x, y, w)
    drawGlowText("🎮 ألعاب وترفيه 🎮", x + w/2, y, "center", 18)
    
    local games = {
        {name = "🧩 لغز النيون", desc = "اختبر ذكائك", reward = "50 XP"},
        {name = "🏎️ سباق السرعة", desc = "تحدي السرعة القصوى", reward = "100 XP"},
        {name = "🎯 صانع القرار", desc = "رمية حظ", reward = "25 XP"},
        {name = "🌀 متاهة الضوء", desc = "ابحث عن المخرج", reward = "75 XP"}
    }
    
    for i, game in ipairs(games) do
        local gameY = y + 40 + (i-1) * 70
        drawNeonBox(x, gameY, w - 80, 55, 10, getColor("secondary"))
        drawGlowText(game.name, x + 15, gameY + 12, "left", 14)
        drawGlowText(game.desc, x + 15, gameY + 32, "left", 10)
        drawGlowText(game.reward, x + w - 70, gameY + 28, "center", 11, getColor("success"))
        drawNeonBox(x + w - 75, gameY + 12, 60, 30, 8, getColor("primary"))
        drawGlowText("لعب", x + w - 45, gameY + 32, "center", 12)
    end
    
    -- لعبة الروليت
    drawGlowText("🎲 لعبة الحظ - روليت", x, y + 330, "left", 13)
    drawNeonBox(x, y + 355, w, 60, 10, getColor("accent"))
    drawGlowText("[ 1 ]  [ 2 ]  [ 3 ]  [ 4 ]  [ 5 ]  [ 6 ]", x + w/2, y + 375, "center", 18)
    drawGlowText("اضغط على رقم للمراهنة", x + w/2, y + 400, "center", 10)
end

-- ====================== [ تبويب المظهر ] ======================
function drawAppearanceTab(x, y, w)
    drawGlowText("🎨 تخصيص المظهر والنظام 🎨", x + w/2, y, "center", 18)
    
    -- اختيار الثيم
    local themeY = y + 45
    drawGlowText("اختر الثيم المفضل:", x, themeY, "left", 13)
    local themeNames = {"neon", "fire", "ice", "gold", "galaxy"}
    local themeW = (w - 30) / 5
    for i, themeName in ipairs(themeNames) do
        local isActive = ui.currentTheme == themeName
        drawNeonBox(x + 5 + (i-1)*themeW, themeY + 25, themeW - 5, 45, 8, 
                   isActive and getColor("success") or getColor("glow"))
        drawGlowText(themes[themeName].name, x + 5 + (i-1)*themeW + (themeW-5)/2, themeY + 50, "center", 9)
    end
    
    -- شفافية الواجهة
    drawGlowText("شفافية الواجهة: " .. math.floor(ui.transparency * 100) .. "%", x, themeY + 90, "left", 12)
    love.graphics.setColor(getColor("primary"))
    love.graphics.rectangle("fill", x, themeY + 115, w * ui.transparency, 8, 4)
    
    -- وضع الجوال/الكمبيوتر
    local modeY = themeY + 145
    drawNeonBox(x, modeY, (w-10)/2, 45, 10, ui.mode == "mobile" and getColor("success") or getColor("primary"))
    drawGlowText("📱 وضع الجوال", x + (w-10)/4, modeY + 28, "center", 12)
    
    drawNeonBox(x + (w-10)/2 + 10, modeY, (w-10)/2, 45, 10, ui.mode == "computer" and getColor("success") or getColor("primary"))
    drawGlowText("💻 وضع الكمبيوتر", x + (w-10)/2 + 10 + (w-10)/4, modeY + 28, "center", 12)
    
    -- قفل الواجهة
    drawNeonBox(x, modeY + 60, w, 40, 10, ui.uiLocked and getColor("danger") or getColor("success"))
    drawGlowText(ui.uiLocked and "🔒 الواجهة مقفلة" or "🔓 الواجهة غير مقفلة", x + w/2, modeY + 85, "center", 13)
    
    -- تأثيرات الجسيمات
    drawGlowText("تأثيرات الجسيمات: " .. (ui.particleEffects and "مفعلة ✨" or "معطلة"), x, modeY + 120, "left", 11)
end

-- ====================== [ تبويب الإعدادات ] ======================
function drawSettingsTab(x, y, w, bottomY)
    drawGlowText("⚙️ الإعدادات المتقدمة ⚙️", x + w/2, y, "center", 18)
    
    local settings = {
        {icon = "🔊", name = "المؤثرات الصوتية", value = ui.soundEnabled, type = "toggle"},
        {icon = "🎵", name = "الموسيقى الخلفية", value = ui.musicEnabled, type = "toggle"},
        {icon = "📊", name = "إظهار FPS", value = ui.showFPS, type = "toggle"},
        {icon = "📍", name = "إظهار الإحداثيات", value = ui.showCoordinates, type = "toggle"},
        {icon = "✨", name = "تأثيرات الجسيمات", value = ui.particleEffects, type = "toggle"},
        {icon = "🌍", name = "اللغة (Language)", value = ui.language, type = "select", options = {"AR", "EN"}}
    }
    
    for i, setting in ipairs(settings) do
        local sY = y + 35 + (i-1) * 48
        love.graphics.setColor(0.1, 0.1, 0.2, 0.6)
        love.graphics.rectangle("fill", x, sY, w, 40, 8)
        drawGlowText(setting.icon .. " " .. setting.name, x + 15, sY + 13, "left", 12)
        
        if setting.type == "toggle" then
            drawNeonBox(x + w - 70, sY + 8, 55, 25, 6, setting.value and getColor("success") or getColor("danger"))
            drawGlowText(setting.value and "ON" or "OFF", x + w - 43, sY + 24, "center", 11)
        elseif setting.type == "select" then
            drawNeonBox(x + w - 100, sY + 8, 85, 25, 6, getColor("primary"))
            drawGlowText(setting.value, x + w - 58, sY + 24, "center", 11)
        end
    end
    
    -- إعادة تعيين جميع الإعدادات
    local resetY = bottomY - 55
    drawNeonBox(x + w/2 - 120, resetY, 240, 40, 10, getColor("warning"))
    drawGlowText("🔄 إعادة تعيين جميع الإعدادات", x + w/2, resetY + 26, "center", 13)
end

-- ====================== [ الزر العائم القابل للسحب ] ======================
function drawFloatingButton()
    local size = 70
    local cx, cy = ui.floatingX + size/2, ui.floatingY + size/2
    
    -- توهج خارجي
    for i = 1, 4 do
        love.graphics.setColor(getColor("glow")[1], getColor("glow")[2], getColor("glow")[3], 0.3 / i)
        love.graphics.circle("fill", cx, cy, size/2 + i * 3)
    end
    
    love.graphics.setColor(0.05, 0.05, 0.15, 0.95)
    love.graphics.circle("fill", cx, cy, size/2)
    love.graphics.setColor(getColor("primary"))
    love.graphics.circle("line", cx, cy, size/2, 8)
    love.graphics.setColor(getColor("accent"))
    love.graphics.circle("line", cx, cy, size/2 - 2, 8)
    
    drawGlowText("Δ", cx - 12, cy - 14, "left", 38, getColor("text"))
    drawGlowText("HUB", cx - 20, cy + 10, "left", 14, getColor("secondary"))
end

-- ====================== [ معالجة الأحداث ] ======================
function love.mousepressed(mx, my, button)
    if button ~= 1 then return end
    
    local size = 70
    local inFloating = mx >= ui.floatingX and mx <= ui.floatingX + size and
                       my >= ui.floatingY and my <= ui.floatingY + size
    
    if inFloating then
        ui.dragActive = true
        ui.dragX = mx - ui.floatingX
        ui.dragY = my - ui.floatingY
        playSound("click")
        return
    end
    
    if ui.isOpen then
        local x, y, w, h = ui.panelX, ui.panelY, ui.panelWidth, ui.panelHeight
        
        -- زر الإغلاق
        if mx >= x + w - 40 and mx <= x + w - 12 and my >= y + 12 and my <= y + 40 then
            ui.isOpen = false
            playSound("close")
            showNotification("تم إغلاق القائمة", "info")
            return
        end
        
        -- علامات التبويب
        local tabY = y + 82
        local tabW = (w - 30) / #tabs
        for i = 1, #tabs do
            local tabX = x + 15 + (i-1) * tabW
            if mx >= tabX and mx <= tabX + tabW - 2 and my >= tabY and my <= tabY + 40 then
                activeTab = i
                playSound("tab")
                showNotification("فتح تبويب: " .. tabs[i].name, "info")
                break
            end
        end
        
        -- أزرار سريعة في تبويب الرئيسية
        if activeTab == 1 then
            -- زر المكافأة اليومية
            local rewardX, rewardY = x + 15, y + 190
            if mx >= rewardX and mx <= rewardX + ui.panelWidth - 30 and my >= rewardY and my <= rewardY + 50 then
                ui.dailyReward = 100
                ui.xpPoints = ui.xpPoints + 100
                showNotification("🎉 حصلت على 100 نقطة مكافأة يومية!", "success")
                playSound("reward")
            end
        end
        
        -- أزرار تبويب الحركة
        if activeTab == 2 then
            local btnX, btnY = x + 15, y + 180
            if mx >= btnX and mx <= btnX + ui.panelWidth - 30 and my >= btnY and my <= btnY + 50 then
                ui.flyMode = not ui.flyMode
                showNotification(ui.flyMode and "تم تفعيل الطيران 🚀" or "تم تعطيل الطيران", "info")
                playSound("toggle")
            end
            
            local noclipX, noclipY = x + 15, y + 330
            if mx >= noclipX and mx <= noclipX + ui.panelWidth - 30 and my >= noclipY and my <= noclipY + 45 then
                ui.noclipMode = not ui.noclipMode
                showNotification(ui.noclipMode and "🔮 وضع NoClip مفعل - يمكنك اختراق الجدران" or "❌ تم تعطيل NoClip", "warning")
                playSound("toggle")
            end
        end
        
        -- أزرار تبويب الانتقال الآني
        if activeTab == 3 then
            local teleX, teleY = x + ui.panelWidth/2 - 110, y + 210
            if mx >= teleX and mx <= teleX + 220 and my >= teleY and my <= teleY + 45 then
                ui.lastPosition = {x = mx, y = my, z = 0}
                ui.lastPositionName = "موضع: " .. math.floor(mx) .. ", " .. math.floor(my)
                showNotification("✨ تم الانتقال الآني!", "success")
                playSound("teleport")
            end
            
            local backX, backY = x + ui.panelWidth/2 - 90, y + 270
            if mx >= backX and mx <= backX + 180 and my >= backY and my <= backY + 40 then
                showNotification("↺ تم العودة إلى آخر موضع", "info")
                playSound("teleport")
            end
        end
        
        -- أزرار تبويب السرعة
        if activeTab == 4 then
            local resetX, resetY = x + ui.panelWidth/2 - 100, y + 230
            if mx >= resetX and mx <= resetX + 200 and my >= resetY and my <= resetY + 42 then
                ui.speedMode = "normal"
                showNotification("تم إعادة ضبط السرعة إلى الوضع العادي", "info")
                playSound("reset")
            end
        end
        
        -- أزرار تبويب الإعدادات
        if activeTab == 7 then
            local resetX, resetY = x + ui.panelWidth/2 - 120, y + ui.panelHeight - 90
            if mx >= resetX and mx <= resetX + 240 and my >= resetY and my <= resetY + 40 then
                ui.soundEnabled = true
                ui.musicEnabled = true
                ui.showFPS = true
                ui.particleEffects = true
                ui.currentTheme = "neon"
                showNotification("تم إعادة تعيين جميع الإعدادات!", "success")
                playSound("reset")
            end
        end
    end
end

function love.mousereleased(mx, my, button)
    if button == 1 then
        ui.dragActive = false
    end
end

function love.mousemoved(mx, my)
    if ui.dragActive and not ui.uiLocked then
        ui.floatingX = mx - ui.dragX
        ui.floatingY = my - ui.dragY
        ui.floatingX = math.max(0, math.min(ui.floatingX, love.graphics.getWidth() - 70))
        ui.floatingY = math.max(0, math.min(ui.floatingY, love.graphics.getHeight() - 70))
    end
end

function love.keypressed(key)
    if key == "space" then
        ui.isOpen = not ui.isOpen
        playSound(ui.isOpen and "open" or "close")
    elseif key == "escape" and ui.isOpen then
        ui.isOpen = false
    elseif key == "f" then
        ui.flyMode = not ui.flyMode
        showNotification(ui.flyMode and "🕊️ وضع الطيران مفعل" or "🦶 وضع الطيران معطل", "info")
    elseif key == "up" and ui.flyMode then
        ui.flySpeed = math.min(ui.flySpeed + 2, 30)
        showNotification("سرعة الطيران: " .. ui.flySpeed, "info")
    elseif key == "down" and ui.flyMode then
        ui.flySpeed = math.max(ui.flySpeed - 2, 1)
        showNotification("سرعة الطيران: " .. ui.flySpeed, "info")
    elseif key == "n" then
        ui.noclipMode = not ui.noclipMode
        showNotification(ui.noclipMode and "🎭 NoClip مفعل" or "🚫 NoClip معطل", "warning")
    elseif key == "t" then
        showNotification("تم التهيئة للانتقال الآني... اضغط مرة أخرى للتأكيد", "info")
    elseif key == "r" then
        ui.speedMode = "normal"
        showNotification("تم إعادة ضبط السرعة", "success")
    elseif key == "c" then
        ui.currentTheme = (ui.currentTheme == "neon" and "fire") or 
                         (ui.currentTheme == "fire" and "ice") or
                         (ui.currentTheme == "ice" and "gold") or
                         (ui.currentTheme == "gold" and "galaxy") or "neon"
        showNotification("تم تغيير الثيم إلى: " .. themes[ui.currentTheme].name, "success")
    elseif key == "l" then
        ui.uiLocked = not ui.uiLocked
        showNotification(ui.uiLocked and "🔒 تم قفل الواجهة" or "🔓 تم فتح الواجهة", "info")
    end
end

function love.update(dt)
    -- تحديث الإشعارات
    for i = #ui.notifications, 1, -1 do
        ui.notifications[i].time = ui.notifications[i].time - dt
        if ui.notifications[i].time <= 0 then
            table.remove(ui.notifications, i)
        end
    end
    
    -- تأثيرات الجسيمات الخفيفة
    if ui.particleEffects and not ui.isOpen then
        -- تأثير توهج حول الزر العائم
    end
end

function love.draw()
    -- خلفية ديناميكية
    local time = love.timer.getTime()
    love.graphics.setBackgroundColor(0.02, 0.02, 0.06)
    
    -- شبكة متحركة
    love.graphics.setColor(getColor("glow")[1], getColor("glow")[2], getColor("glow")[3], 0.15)
    for i = 0, love.graphics.getWidth(), 60 do
        love.graphics.line(i + math.sin(time) * 5, 0, i + math.cos(time) * 5, love.graphics.getHeight())
        love.graphics.line(0, i + math.cos(time) * 5, love.graphics.getWidth(), i + math.sin(time) * 5)
    end
    
    -- جسيمات متطايرة
    if ui.particleEffects then
        love.graphics.setColor(getColor("accent")[1], getColor("accent")[2], getColor("accent")[3], 0.3)
        for i = 1, 20 do
            local px = (math.sin(time * 2 + i) * 0.5 + 0.5) * love.graphics.getWidth()
            local py = (math.cos(time * 1.7 + i) * 0.5 + 0.5) * love.graphics.getHeight()
            love.graphics.circle("fill", px, py, 2)
        end
    end
    
    if ui.isOpen then
        drawMainPanel()
    end
    drawFloatingButton()
    drawNotifications()
    
    -- عرض FPS والإحداثيات
    if ui.showFPS then
        love.graphics.setColor(0.5, 0.8, 1, 0.7)
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
    end
    
    if ui.showCoordinates then
        local mx, my = love.mouse.getPosition()
        love.graphics.setColor(0.5, 0.8, 1, 0.7)
        love.graphics.print(string.format("📍 %d, %d", mx, my), love.graphics.getWidth() - 100, 10)
    end
    
    -- تلميحات سريعة
    if not ui.isOpen then
        love.graphics.setColor(1, 1, 1, 0.4)
        love.graphics.print("⌨ اضغط SPACE لفتح القائمة", 10, love.graphics.getHeight() - 25)
    end
end

function love.resize(w, h)
    window.width, window.height = w, h
    ui.panelX = (w - ui.panelWidth) / 2
    ui.panelY = (h - ui.panelHeight) / 2
    ui.floatingX = math.min(ui.floatingX, w - 70)
    ui.floatingY = math.min(ui.floatingY, h - 70)
end

function love.load()
    love.window.setMode(window.width, window.height, {resizable=true, vsync=true})
    love.window.setTitle(window.title)
    love.resize(window.width, window.height)
    
    -- رسالة ترحيب
    print("╔════════════════════════════════════════╗")
    print("║     Δ DELTA HUB ULTRA - جاهز للعمل     ║")
    print("║        اسحب الزر D في أي مكان!         ║")
    print("╚════════════════════════════════════════╝")
    
    showNotification("✨ مرحباً بك في DELTA HUB ULTRA! اسحب الزر العائم", "success")
    showNotification("🎮 اضغط SPACE لإظهار/إخفاء القائمة", "info")
    showNotification("🎨 اضغط C لتغيير الثيم", "info")
end

-- ============================================================================
-- نهاية الكود - واجهة DELTA HUB ULTRA تعمل بكامل طاقتها!
-- ===========================================================================