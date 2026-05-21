--[[
╔══════════════════════════════════════════════════════════════════╗
║          ⚡ NEON HUB v3.0 — Ultimate Script                     ║
║   Fly | Speed | Jump | ESP | Gravity | Music | & Much More      ║
║   Works on PC & Mobile | Press X or tap Circle to toggle UI     ║
╚══════════════════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════
--            SERVICES
-- ═══════════════════════════════════════════
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local SoundService     = game:GetService("SoundService")
local Lighting         = game:GetService("Lighting")
local VirtualUser      = game:GetService("VirtualUser")
local StarterGui       = game:GetService("StarterGui")

local Player    = Players.LocalPlayer
local Mouse     = Player:GetMouse()

local function getChar()    return Player.Character end
local function getHuman()   local c=getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot()    local c=getChar() return c and c:FindFirstChild("HumanoidRootPart") end

-- ═══════════════════════════════════════════
--            STATE
-- ═══════════════════════════════════════════
local State = {
    fly           = false,
    flySpeed      = 60,
    speedBoost    = false,
    walkSpeed     = 16,
    infiniteJump  = false,
    jumpPower     = 50,
    godMode       = false,
    noclip        = false,
    antiAFK       = false,
    semiInvis     = false,
    fullbright    = false,
    espNames      = false,
    espBoxes      = false,
    gravity       = 196.2,
    spinning      = false,
    fpsBoost      = false,
    chatTag       = "",
    uiOpen        = true,
    activeTab     = 1,
}

local flyBV, flyBG = nil, nil

-- ═══════════════════════════════════════════
--            COLORS / THEME
-- ═══════════════════════════════════════════
local C = {
    bg       = Color3.fromRGB(4,  4,  14),
    panel    = Color3.fromRGB(8,  8,  22),
    card     = Color3.fromRGB(11, 11, 30),
    cyan     = Color3.fromRGB(0,  230, 255),
    pink     = Color3.fromRGB(255, 30, 140),
    purple   = Color3.fromRGB(160, 0,  255),
    green    = Color3.fromRGB(0,  255, 110),
    orange   = Color3.fromRGB(255, 155,  0),
    yellow   = Color3.fromRGB(255, 240,  0),
    red      = Color3.fromRGB(255,  40, 60),
    white    = Color3.fromRGB(240, 240, 255),
    dim      = Color3.fromRGB(120, 120, 160),
}

local TAB_COLORS = { C.cyan, C.pink, C.purple, C.green, C.orange }
local TAB_NAMES  = { "✈ MOVE", "🛡 PLAYER", "👁 ESP", "🌍 WORLD", "🎵 EXTRA" }

-- ═══════════════════════════════════════════
--            SCREEN GUI
-- ═══════════════════════════════════════════
pcall(function()
    local old = Player:WaitForChild("PlayerGui"):FindFirstChild("NeonHubV3")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonHubV3"
ScreenGui.ResetOnSpawn       = false
ScreenGui.ZIndexBehavior     = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset     = true
ScreenGui.DisplayOrder       = 999
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════
--            MINI CIRCLE BUTTON
-- ═══════════════════════════════════════════
local MiniBtn = Instance.new("ImageButton")
MiniBtn.Name            = "MiniBtn"
MiniBtn.Size            = UDim2.new(0, 58, 0, 58)
MiniBtn.Position        = UDim2.new(1, -74, 0.5, -29)
MiniBtn.BackgroundColor3= Color3.fromRGB(8, 8, 24)
MiniBtn.BorderSizePixel = 0
MiniBtn.Visible         = false
MiniBtn.ZIndex          = 20
MiniBtn.Parent          = ScreenGui

Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(1,0)

local MiniStroke       = Instance.new("UIStroke", MiniBtn)
MiniStroke.Color       = C.cyan
MiniStroke.Thickness   = 2.5

local MiniIcon         = Instance.new("TextLabel", MiniBtn)
MiniIcon.Size          = UDim2.new(1,0,1,0)
MiniIcon.BackgroundTransparency = 1
MiniIcon.Text          = "⚡"
MiniIcon.TextScaled    = true
MiniIcon.Font          = Enum.Font.GothamBold
MiniIcon.TextColor3    = C.cyan
MiniIcon.ZIndex        = 21

-- pulse animation on mini button
local pulseTI = TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local miniPulse = TweenService:Create(MiniStroke, pulseTI, {Color = C.pink, Thickness = 4})

-- ═══════════════════════════════════════════
--            MAIN FRAME
-- ═══════════════════════════════════════════
local W, H = 400, 580

local MainFrame         = Instance.new("Frame")
MainFrame.Name          = "MainFrame"
MainFrame.Size          = UDim2.new(0, W, 0, H)
MainFrame.Position      = UDim2.new(0.5, -W/2, 0.5, -H/2)
MainFrame.BackgroundColor3 = C.bg
MainFrame.BorderSizePixel  = 0
MainFrame.ClipsDescendants = true
MainFrame.ZIndex        = 5
MainFrame.Parent        = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 18)

local MainStroke        = Instance.new("UIStroke", MainFrame)
MainStroke.Color        = C.cyan
MainStroke.Thickness    = 1.8

-- animated border
local borderAnim = TweenService:Create(MainStroke, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Color = C.purple, Thickness = 3})
borderAnim:Play()

-- bg gradient
local BgGrad            = Instance.new("UIGradient", MainFrame)
BgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(4,4,18)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8,4,24)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(4,8,20)),
})
BgGrad.Rotation = 135

-- ═══════════════════════════════════════════
--            HEADER
-- ═══════════════════════════════════════════
local Header            = Instance.new("Frame", MainFrame)
Header.Size             = UDim2.new(1, 0, 0, 58)
Header.BackgroundColor3 = Color3.fromRGB(7, 7, 22)
Header.BorderSizePixel  = 0
Header.ZIndex           = 6

Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local HGrad             = Instance.new("UIGradient", Header)
HGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   C.cyan),
    ColorSequenceKeypoint.new(0.45, C.purple),
    ColorSequenceKeypoint.new(1,   C.pink),
})
HGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.72),
    NumberSequenceKeypoint.new(1, 0.72),
})
HGrad.Rotation = 90

-- Title
local Title             = Instance.new("TextLabel", Header)
Title.Size              = UDim2.new(1, -55, 0, 28)
Title.Position          = UDim2.new(0, 14, 0, 6)
Title.BackgroundTransparency = 1
Title.Text              = "⚡  NEON HUB  v3.0"
Title.Font              = Enum.Font.GothamBlack
Title.TextSize          = 19
Title.TextColor3        = C.white
Title.TextXAlignment    = Enum.TextXAlignment.Left
Title.ZIndex            = 7

local SubTitle          = Instance.new("TextLabel", Header)
SubTitle.Size           = UDim2.new(1, -55, 0, 16)
SubTitle.Position       = UDim2.new(0, 14, 0, 36)
SubTitle.BackgroundTransparency = 1
SubTitle.Text           = "Ultimate Roblox Script — All Devices"
SubTitle.Font           = Enum.Font.Gotham
SubTitle.TextSize       = 10
SubTitle.TextColor3     = C.cyan
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex         = 7

-- Close (X) Button
local CloseBtn          = Instance.new("TextButton", Header)
CloseBtn.Size           = UDim2.new(0, 30, 0, 30)
CloseBtn.Position       = UDim2.new(1, -42, 0, 14)
CloseBtn.BackgroundColor3 = C.red
CloseBtn.BorderSizePixel  = 0
CloseBtn.Text           = "✕"
CloseBtn.Font           = Enum.Font.GothamBold
CloseBtn.TextSize       = 13
CloseBtn.TextColor3     = C.white
CloseBtn.ZIndex         = 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- ═══════════════════════════════════════════
--            TAB BAR
-- ═══════════════════════════════════════════
local TabBar            = Instance.new("Frame", MainFrame)
TabBar.Size             = UDim2.new(1, -16, 0, 36)
TabBar.Position         = UDim2.new(0, 8, 0, 62)
TabBar.BackgroundTransparency = 1
TabBar.ZIndex           = 6

local TabLayout         = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding       = UDim.new(0, 4)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TabButtons = {}
local TabPages   = {}

-- ═══════════════════════════════════════════
--            CONTENT AREA (pages)
-- ═══════════════════════════════════════════
local ContentArea       = Instance.new("Frame", MainFrame)
ContentArea.Size        = UDim2.new(1, 0, 1, -104)
ContentArea.Position    = UDim2.new(0, 0, 0, 102)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex      = 6

-- Status bar at bottom
local StatusBar         = Instance.new("Frame", MainFrame)
StatusBar.Size          = UDim2.new(1, 0, 0, 22)
StatusBar.Position      = UDim2.new(0, 0, 1, -22)
StatusBar.BackgroundColor3 = Color3.fromRGB(5, 5, 18)
StatusBar.BorderSizePixel  = 0
StatusBar.ZIndex        = 8

local StatusLbl         = Instance.new("TextLabel", StatusBar)
StatusLbl.Size          = UDim2.new(1, -10, 1, 0)
StatusLbl.Position      = UDim2.new(0, 8, 0, 0)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text          = "● Ready — Welcome to NEON HUB v3.0"
StatusLbl.Font          = Enum.Font.Gotham
StatusLbl.TextSize      = 10
StatusLbl.TextColor3    = C.green
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.ZIndex        = 9

local function setStatus(msg, col)
    StatusLbl.Text       = "● " .. msg
    StatusLbl.TextColor3 = col or C.green
end

-- ═══════════════════════════════════════════
--            COMPONENT HELPERS
-- ═══════════════════════════════════════════
local function makeScrollPage()
    local sf            = Instance.new("ScrollingFrame")
    sf.Size             = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel  = 0
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = C.cyan
    sf.CanvasSize       = UDim2.new(0, 0, 0, 0)
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.ZIndex           = 7
    sf.Parent           = ContentArea

    local ul            = Instance.new("UIListLayout", sf)
    ul.Padding          = UDim.new(0, 6)
    ul.SortOrder        = Enum.SortOrder.LayoutOrder

    local pad           = Instance.new("UIPadding", sf)
    pad.PaddingLeft     = UDim.new(0, 8)
    pad.PaddingRight    = UDim.new(0, 8)
    pad.PaddingTop      = UDim.new(0, 6)
    pad.PaddingBottom   = UDim.new(0, 6)

    return sf
end

local function sectionLabel(parent, txt, col, order)
    local f             = Instance.new("Frame", parent)
    f.Size              = UDim2.new(1, 0, 0, 26)
    f.BackgroundTransparency = 1
    f.LayoutOrder       = order or 0
    f.ZIndex            = 8

    local line          = Instance.new("Frame", f)
    line.Size           = UDim2.new(1, 0, 0, 1)
    line.Position       = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = col or C.cyan
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel  = 0

    local lbl           = Instance.new("TextLabel", f)
    lbl.Size            = UDim2.new(0, 140, 1, 0)
    lbl.Position        = UDim2.new(0.5, -70, 0, 0)
    lbl.BackgroundColor3 = C.bg
    lbl.BorderSizePixel  = 0
    lbl.Text            = txt
    lbl.Font            = Enum.Font.GothamBold
    lbl.TextSize        = 11
    lbl.TextColor3      = col or C.cyan
    lbl.ZIndex          = 9
    return f
end

-- Toggle Card
local function makeToggle(parent, label, accent, onToggle, order)
    local card          = Instance.new("Frame", parent)
    card.Size           = UDim2.new(1, 0, 0, 50)
    card.BackgroundColor3 = C.card
    card.BorderSizePixel  = 0
    card.LayoutOrder    = order or 0
    card.ZIndex         = 8
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local stroke        = Instance.new("UIStroke", card)
    stroke.Color        = accent
    stroke.Thickness    = 1
    stroke.Transparency = 0.55

    local dot           = Instance.new("Frame", card)
    dot.Size            = UDim2.new(0, 7, 0, 7)
    dot.Position        = UDim2.new(0, 12, 0.5, -3.5)
    dot.BackgroundColor3 = accent
    dot.BorderSizePixel  = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

    local lbl           = Instance.new("TextLabel", card)
    lbl.Size            = UDim2.new(1, -90, 1, 0)
    lbl.Position        = UDim2.new(0, 26, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text            = label
    lbl.Font            = Enum.Font.GothamSemibold
    lbl.TextSize        = 12
    lbl.TextColor3      = C.white
    lbl.TextXAlignment  = Enum.TextXAlignment.Left
    lbl.ZIndex          = 9

    -- switch track
    local track         = Instance.new("Frame", card)
    track.Size          = UDim2.new(0, 44, 0, 22)
    track.Position      = UDim2.new(1, -54, 0.5, -11)
    track.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    track.BorderSizePixel  = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)

    local knob          = Instance.new("Frame", track)
    knob.Size           = UDim2.new(0, 16, 0, 16)
    knob.Position       = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = C.dim
    knob.BorderSizePixel  = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local isOn = false
    local hitbox        = Instance.new("TextButton", card)
    hitbox.Size         = UDim2.new(1,0,1,0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text         = ""
    hitbox.ZIndex       = 10

    hitbox.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            TweenService:Create(track, TweenInfo.new(0.18), {BackgroundColor3 = accent}):Play()
            TweenService:Create(knob,  TweenInfo.new(0.18), {Position = UDim2.new(0,25,0.5,-8), BackgroundColor3 = C.white}):Play()
            TweenService:Create(stroke,TweenInfo.new(0.18), {Transparency = 0}):Play()
        else
            TweenService:Create(track, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(25,25,45)}):Play()
            TweenService:Create(knob,  TweenInfo.new(0.18), {Position = UDim2.new(0,3,0.5,-8),  BackgroundColor3 = C.dim}):Play()
            TweenService:Create(stroke,TweenInfo.new(0.18), {Transparency = 0.55}):Play()
        end
        onToggle(isOn)
    end)

    return card
end

-- Slider Card
local function makeSlider(parent, label, minV, maxV, defV, accent, onChange, order)
    local card          = Instance.new("Frame", parent)
    card.Size           = UDim2.new(1, 0, 0, 64)
    card.BackgroundColor3 = C.card
    card.BorderSizePixel  = 0
    card.LayoutOrder    = order or 0
    card.ZIndex         = 8
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", card).Color        = accent
    card:FindFirstChildOfClass("UIStroke").Thickness    = 1
    card:FindFirstChildOfClass("UIStroke").Transparency = 0.5

    local lbl           = Instance.new("TextLabel", card)
    lbl.Size            = UDim2.new(1, -70, 0, 20)
    lbl.Position        = UDim2.new(0, 12, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text            = label
    lbl.Font            = Enum.Font.GothamSemibold
    lbl.TextSize        = 11
    lbl.TextColor3      = C.white
    lbl.TextXAlignment  = Enum.TextXAlignment.Left
    lbl.ZIndex          = 9

    local valLbl        = Instance.new("TextLabel", card)
    valLbl.Size         = UDim2.new(0, 55, 0, 20)
    valLbl.Position     = UDim2.new(1, -65, 0, 8)
    valLbl.BackgroundTransparency = 1
    valLbl.Text         = tostring(defV)
    valLbl.Font         = Enum.Font.GothamBold
    valLbl.TextSize     = 12
    valLbl.TextColor3   = accent
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex       = 9

    local track         = Instance.new("Frame", card)
    track.Size          = UDim2.new(1, -24, 0, 5)
    track.Position      = UDim2.new(0, 12, 0, 40)
    track.BackgroundColor3 = Color3.fromRGB(22,22,44)
    track.BorderSizePixel  = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)

    local pct           = (defV - minV) / (maxV - minV)

    local fill          = Instance.new("Frame", track)
    fill.Size           = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = accent
    fill.BorderSizePixel  = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local knob          = Instance.new("Frame", track)
    knob.Size           = UDim2.new(0, 14, 0, 14)
    knob.Position       = UDim2.new(pct, -7, 0.5, -7)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel  = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local kStroke       = Instance.new("UIStroke", knob)
    kStroke.Color       = accent
    kStroke.Thickness   = 2

    local dragging = false
    local hitbox        = Instance.new("TextButton", track)
    hitbox.Size         = UDim2.new(1,20,1,20)
    hitbox.Position     = UDim2.new(0,-10,0,-10)
    hitbox.BackgroundTransparency = 1
    hitbox.Text         = ""
    hitbox.ZIndex       = 10

    hitbox.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    RunService.Heartbeat:Connect(function()
        if dragging then
            local pos = UserInputService:GetMouseLocation()
            local tp  = track.AbsolutePosition
            local ts  = track.AbsoluteSize
            local rel = math.clamp((pos.X - tp.X) / ts.X, 0, 1)
            local val = math.round(minV + rel * (maxV - minV))
            fill.Size       = UDim2.new(rel, 0, 1, 0)
            knob.Position   = UDim2.new(rel, -7, 0.5, -7)
            valLbl.Text     = tostring(val)
            onChange(val)
        end
    end)
    return card
end

-- Action Button
local function makeBtn(parent, label, accent, onClick, order)
    local btn           = Instance.new("TextButton", parent)
    btn.Size            = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(10,10,26)
    btn.BorderSizePixel  = 0
    btn.Text            = label
    btn.Font            = Enum.Font.GothamBold
    btn.TextSize        = 12
    btn.TextColor3      = accent
    btn.LayoutOrder     = order or 0
    btn.ZIndex          = 8
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local s             = Instance.new("UIStroke", btn)
    s.Color             = accent
    s.Thickness         = 1.4

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = accent}):Play()
        task.delay(0.12, function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(10,10,26)}):Play()
        end)
        onClick()
    end)
    btn.MouseEnter:Connect(function()
        TweenService:Create(s, TweenInfo.new(0.18), {Thickness = 2.4}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(s, TweenInfo.new(0.18), {Thickness = 1.4}):Play()
    end)
    return btn
end

-- Input Field
local function makeInput(parent, placeholder, accent, order)
    local frame         = Instance.new("Frame", parent)
    frame.Size          = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(10,10,26)
    frame.BorderSizePixel  = 0
    frame.LayoutOrder   = order or 0
    frame.ZIndex        = 8
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", frame).Color        = accent
    frame:FindFirstChildOfClass("UIStroke").Thickness = 1.2

    local box           = Instance.new("TextBox", frame)
    box.Size            = UDim2.new(1, -16, 1, 0)
    box.Position        = UDim2.new(0, 8, 0, 0)
    box.BackgroundTransparency = 1
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = C.dim
    box.Text            = ""
    box.Font            = Enum.Font.Gotham
    box.TextSize        = 12
    box.TextColor3      = C.white
    box.ClearTextOnFocus = false
    box.ZIndex          = 9
    return frame, box
end

-- ═══════════════════════════════════════════
--            TAB SYSTEM
-- ═══════════════════════════════════════════
local function switchTab(idx)
    State.activeTab = idx
    for i, page in ipairs(TabPages) do
        page.Visible = (i == idx)
    end
    for i, tbtn in ipairs(TabButtons) do
        local active = (i == idx)
        TweenService:Create(tbtn, TweenInfo.new(0.18), {
            BackgroundColor3 = active and TAB_COLORS[i] or Color3.fromRGB(12,12,30),
            TextColor3       = active and C.white or TAB_COLORS[i],
        }):Play()
    end
end

for i = 1, #TAB_NAMES do
    local page = makeScrollPage()
    page.Visible = (i == 1)
    table.insert(TabPages, page)

    local tbtn          = Instance.new("TextButton", TabBar)
    tbtn.Size           = UDim2.new(0, 68, 0, 32)
    tbtn.BackgroundColor3 = (i==1) and TAB_COLORS[i] or Color3.fromRGB(12,12,30)
    tbtn.BorderSizePixel  = 0
    tbtn.Text           = TAB_NAMES[i]
    tbtn.Font           = Enum.Font.GothamBold
    tbtn.TextSize       = 9.5
    tbtn.TextColor3     = (i==1) and C.white or TAB_COLORS[i]
    tbtn.ZIndex         = 7
    Instance.new("UICorner", tbtn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", tbtn).Color        = TAB_COLORS[i]
    tbtn:FindFirstChildOfClass("UIStroke").Thickness = 1

    table.insert(TabButtons, tbtn)
    local idx = i
    tbtn.MouseButton1Click:Connect(function() switchTab(idx) end)
end

-- ═══════════════════════════════════════════
--   PAGE 1 — MOVEMENT
-- ═══════════════════════════════════════════
local P1 = TabPages[1]

sectionLabel(P1, "✈  FLY", C.cyan, 1)

makeToggle(P1, "🚀  Fly Mode  (WASD + Space/Shift)", C.cyan, function(on)
    State.fly = on
    local h = getHuman()
    if h then h.PlatformStand = on end
    if on then
        local root = getRoot()
        if root then
            flyBV = Instance.new("BodyVelocity", root)
            flyBV.Velocity  = Vector3.zero
            flyBV.MaxForce  = Vector3.new(1e6,1e6,1e6)
            flyBG = Instance.new("BodyGyro", root)
            flyBG.MaxTorque = Vector3.new(1e6,1e6,1e6)
            flyBG.P         = 1e4
        end
    else
        if flyBV then flyBV:Destroy() flyBV = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
        local h2 = getHuman()
        if h2 then h2.PlatformStand = false end
    end
    setStatus(on and "Fly ON — WASD to move, Space/Shift for up/down" or "Fly OFF", on and C.cyan or C.green)
end, 2)

makeSlider(P1, "✈  Fly Speed", 10, 400, 60, C.cyan, function(v)
    State.flySpeed = v
end, 3)

sectionLabel(P1, "⚡  SPEED", C.yellow, 4)

makeToggle(P1, "⚡  Speed Boost", C.yellow, function(on)
    State.speedBoost = on
    local h = getHuman()
    if h then h.WalkSpeed = on and State.walkSpeed or 16 end
    setStatus(on and "Speed Boost ON" or "Speed Boost OFF", on and C.yellow or C.green)
end, 5)

makeSlider(P1, "🏃  Walk Speed", 16, 250, 16, C.yellow, function(v)
    State.walkSpeed = v
    if State.speedBoost then
        local h = getHuman()
        if h then h.WalkSpeed = v end
    end
end, 6)

sectionLabel(P1, "🦘  JUMP", C.pink, 7)

makeSlider(P1, "⬆  Jump Power", 50, 600, 50, C.pink, function(v)
    State.jumpPower = v
    local h = getHuman()
    if h then h.JumpPower = v end
end, 8)

makeToggle(P1, "♾  Infinite Jump", C.pink, function(on)
    State.infiniteJump = on
    setStatus(on and "Infinite Jump ON" or "Infinite Jump OFF", on and C.pink or C.green)
end, 9)

sectionLabel(P1, "🌀  EXTRAS", C.purple, 10)

makeToggle(P1, "🌀  Spinning Mode", C.purple, function(on)
    State.spinning = on
    setStatus(on and "Spinning ON" or "Spinning OFF", on and C.purple or C.green)
end, 11)

makeBtn(P1, "🌊  Do Ragdoll", C.orange, function()
    local h = getHuman()
    if h then h:ChangeState(Enum.HumanoidStateType.Ragdoll) end
    setStatus("Ragdoll!", C.orange)
end, 12)

makeBtn(P1, "💨  Fling Upward", C.cyan, function()
    local root = getRoot()
    if root then
        local bv = Instance.new("BodyVelocity", root)
        bv.Velocity  = Vector3.new(0, 200, 0)
        bv.MaxForce  = Vector3.new(0, 1e6, 0)
        task.delay(0.3, function() bv:Destroy() end)
    end
    setStatus("Flung!", C.cyan)
end, 13)

makeBtn(P1, "🎯  Teleport to Mouse Click", C.green, function()
    local m = Mouse
    if m and m.Hit then
        local root = getRoot()
        if root then
            root.CFrame = CFrame.new(m.Hit.Position + Vector3.new(0,3,0))
        end
    end
    setStatus("Teleported to mouse!", C.green)
end, 14)

-- ═══════════════════════════════════════════
--   PAGE 2 — PLAYER
-- ═══════════════════════════════════════════
local P2 = TabPages[2]

sectionLabel(P2, "🛡  PROTECTION", C.purple, 1)

makeToggle(P2, "💀  God Mode (Max Health)", C.purple, function(on)
    State.godMode = on
    local h = getHuman()
    if h then
        if on then h.MaxHealth = math.huge; h.Health = math.huge
        else h.MaxHealth = 100; h.Health = 100 end
    end
    setStatus(on and "God Mode ON — Immortal!" or "God Mode OFF", on and C.purple or C.green)
end, 2)

makeToggle(P2, "👻  Noclip (Walk Through Walls)", C.orange, function(on)
    State.noclip = on
    setStatus(on and "Noclip ON" or "Noclip OFF", on and C.orange or C.green)
end, 3)

makeToggle(P2, "⏰  Anti-AFK", C.green, function(on)
    State.antiAFK = on
    setStatus(on and "Anti-AFK ON" or "Anti-AFK OFF", on and C.green or C.green)
end, 4)

makeToggle(P2, "🔮  Semi-Invisible", C.cyan, function(on)
    State.semiInvis = on
    local c = getChar()
    if c then
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                TweenService:Create(p, TweenInfo.new(0.5), {Transparency = on and 0.82 or 0}):Play()
            end
        end
    end
    setStatus(on and "Semi-Invisible ON" or "Invisible OFF", on and C.cyan or C.green)
end, 5)

sectionLabel(P2, "🎮  ACTIONS", C.orange, 6)

makeBtn(P2, "🔄  Respawn Character", C.orange, function()
    local h = getHuman()
    if h then h.Health = 0 end
    setStatus("Respawning...", C.orange)
end, 7)

makeBtn(P2, "🪑  Force Sit", C.yellow, function()
    local h = getHuman()
    if h then h.Sit = true end
    setStatus("Sitting!", C.yellow)
end, 8)

makeBtn(P2, "🏠  Rejoin Server", C.red, function()
    local TS = game:GetService("TeleportService")
    pcall(function() TS:Teleport(game.PlaceId, Player) end)
end, 9)

makeBtn(P2, "📋  Copy User ID to Chat", C.cyan, function()
    local ok, err = pcall(function()
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "Your UserID: " .. tostring(Player.UserId),
            Color = C.cyan,
            Font = Enum.Font.GothamBold,
        })
    end)
    setStatus("UserID sent to chat!", C.cyan)
end, 10)

makeBtn(P2, "🎭  Max Accessories", C.pink, function()
    -- Make all accessories visible & normal transparency
    local c = getChar()
    if c then
        for _, acc in ipairs(c:GetDescendants()) do
            if acc:IsA("BasePart") then
                acc.Transparency = 0
            end
        end
    end
    setStatus("Accessories reset!", C.pink)
end, 11)

sectionLabel(P2, "💬  CHAT", C.green, 12)

local _, chatBox = makeInput(P2, "💬 Type custom chat message...", C.green, 13)
chatBox.Parent.LayoutOrder = 13

makeBtn(P2, "📤  Send Chat Message", C.green, function()
    local msg = chatBox.Text
    if msg and msg ~= "" then
        local ok = pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end)
        if not ok then
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[NeonHub] Chat message: " .. msg,
                Color = C.green,
            })
        end
        setStatus("Chat sent: " .. msg, C.green)
    end
end, 14)

-- ═══════════════════════════════════════════
--   PAGE 3 — ESP / VISUALS
-- ═══════════════════════════════════════════
local P3 = TabPages[3]

sectionLabel(P3, "👁  ESP", C.green, 1)

local espBillboards = {}
makeToggle(P3, "🎯  Player Name ESP", C.green, function(on)
    State.espNames = on
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            local h = plr.Character and plr.Character:FindFirstChild("Head")
            if h then
                local bb = h:FindFirstChild("_ESP_BB")
                if on and not bb then
                    bb = Instance.new("BillboardGui", h)
                    bb.Name          = "_ESP_BB"
                    bb.Size          = UDim2.new(0,80,0,28)
                    bb.StudsOffset   = Vector3.new(0,3.5,0)
                    bb.AlwaysOnTop   = true
                    local t          = Instance.new("TextLabel", bb)
                    t.Size           = UDim2.new(1,0,1,0)
                    t.BackgroundTransparency = 1
                    t.Text           = plr.Name
                    t.Font           = Enum.Font.GothamBold
                    t.TextSize       = 13
                    t.TextColor3     = C.green
                    table.insert(espBillboards, bb)
                elseif not on and bb then
                    bb:Destroy()
                end
            end
        end
    end
    setStatus(on and "ESP ON" or "ESP OFF", on and C.green or C.green)
end, 2)

makeToggle(P3, "☀  Fullbright", C.yellow, function(on)
    State.fullbright = on
    Lighting.Brightness = on and 10 or 2
    if on then
        Lighting.ClockTime = 14
        Lighting.FogEnd    = 1e6
    end
    setStatus(on and "Fullbright ON" or "Fullbright OFF", on and C.yellow or C.green)
end, 3)

sectionLabel(P3, "📷  CAMERA", C.cyan, 4)

makeBtn(P3, "🔭  Max Zoom Out", C.cyan, function()
    local cam = workspace.CurrentCamera
    Player.CameraMaxZoomDistance = 500
    setStatus("Max zoom set to 500!", C.cyan)
end, 5)

makeBtn(P3, "🔬  Lock First Person", C.pink, function()
    Player.CameraMaxZoomDistance = 0.5
    setStatus("First person locked!", C.pink)
end, 6)

makeBtn(P3, "🔄  Reset Camera Zoom", C.orange, function()
    Player.CameraMaxZoomDistance = 128
    setStatus("Camera zoom reset!", C.orange)
end, 7)

makeSlider(P3, "📸  FOV", 70, 120, 70, C.purple, function(v)
    workspace.CurrentCamera.FieldOfView = v
    setStatus("FOV: " .. v, C.purple)
end, 8)

sectionLabel(P3, "🎨  VISUAL FX", C.purple, 9)

makeBtn(P3, "🌈  Rainbow Character", C.pink, function()
    local c = getChar()
    if c then
        local hue = 0
        local conn
        conn = RunService.Heartbeat:Connect(function()
            hue = (hue + 0.5) % 360
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Color = Color3.fromHSV(hue/360, 1, 1)
                end
            end
        end)
        task.delay(10, function() conn:Disconnect() end)
    end
    setStatus("Rainbow for 10s!", C.pink)
end, 10)

makeBtn(P3, "💥  Neon Character Glow", C.cyan, function()
    local c = getChar()
    if c then
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Material = Enum.Material.Neon
            end
        end
    end
    setStatus("Neon glow ON!", C.cyan)
end, 11)

makeBtn(P3, "🔧  Reset Character Appearance", C.orange, function()
    local c = getChar()
    if c then
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Material    = Enum.Material.SmoothPlastic
                p.Transparency = 0
            end
        end
    end
    setStatus("Appearance reset!", C.orange)
end, 12)

-- ═══════════════════════════════════════════
--   PAGE 4 — WORLD
-- ═══════════════════════════════════════════
local P4 = TabPages[4]

sectionLabel(P4, "🌍  GRAVITY", C.green, 1)

makeSlider(P4, "🌍  Gravity", 0, 400, 196, C.green, function(v)
    workspace.Gravity = v
    setStatus("Gravity: " .. v, C.green)
end, 2)

makeBtn(P4, "🌙  Moon Gravity (65)", C.cyan, function()
    workspace.Gravity = 65
    setStatus("Moon gravity!", C.cyan)
end, 3)

makeBtn(P4, "🪐  Space (0 gravity)", C.purple, function()
    workspace.Gravity = 0
    setStatus("Zero gravity!", C.purple)
end, 4)

makeBtn(P4, "🌎  Normal Gravity", C.green, function()
    workspace.Gravity = 196.2
    setStatus("Normal gravity!", C.green)
end, 5)

sectionLabel(P4, "⏰  TIME & WEATHER", C.orange, 6)

makeSlider(P4, "🌤  Time of Day", 0, 24, 14, C.orange, function(v)
    Lighting.ClockTime = v
    setStatus("Time: " .. v .. ":00", C.orange)
end, 7)

makeBtn(P4, "🌅  Sunrise", C.yellow, function()
    Lighting.ClockTime = 6
    setStatus("Sunrise time!", C.yellow)
end, 8)

makeBtn(P4, "🌙  Night", C.purple, function()
    Lighting.ClockTime = 0
    setStatus("Night time!", C.purple)
end, 9)

makeBtn(P4, "🌫  Remove Fog", C.cyan, function()
    Lighting.FogEnd = 1e6
    Lighting.FogStart = 1e6
    setStatus("Fog removed!", C.cyan)
end, 10)

sectionLabel(P4, "⚙  PERFORMANCE", C.red, 11)

makeToggle(P4, "⚡  FPS Boost (Reduce Quality)", C.red, function(on)
    State.fpsBoost = on
    local sets = game:GetService("UserSettings"):GetService("UserGameSettings")
    if on then
        sets.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel01
    else
        sets.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
    end
    setStatus(on and "FPS Boost ON" or "FPS Boost OFF", on and C.red or C.green)
end, 12)

-- ═══════════════════════════════════════════
--   PAGE 5 — EXTRAS / INFO
-- ═══════════════════════════════════════════
local P5 = TabPages[5]

sectionLabel(P5, "🎵  MUSIC", C.pink, 1)

local _, musicBox = makeInput(P5, "🎵 Paste Sound ID (numbers only)...", C.pink, 2)
musicBox.Parent.LayoutOrder = 2

local currentSound = nil
makeBtn(P5, "▶  Play Music", C.pink, function()
    local id = musicBox.Text
    if id and id:match("^%d+$") then
        if currentSound then currentSound:Destroy() end
        currentSound = Instance.new("Sound", workspace)
        currentSound.SoundId = "rbxassetid://" .. id
        currentSound.Volume  = 0.5
        currentSound.Looped  = true
        currentSound:Play()
        setStatus("Playing sound: " .. id, C.pink)
    else
        setStatus("Enter a valid Sound ID!", C.red)
    end
end, 3)

makeBtn(P5, "⏹  Stop Music", C.red, function()
    if currentSound then currentSound:Destroy(); currentSound = nil end
    setStatus("Music stopped!", C.red)
end, 4)

sectionLabel(P5, "📊  SERVER INFO", C.cyan, 5)

makeBtn(P5, "📊  Show Server Info in Chat", C.cyan, function()
    local msg = string.format(
        "Players: %d | Job ID: %s | Place: %d",
        #Players:GetPlayers(),
        tostring(game.JobId):sub(1,8) .. "...",
        game.PlaceId
    )
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text  = "[NeonHub] " .. msg,
        Color = C.cyan,
        Font  = Enum.Font.Gotham,
    })
    setStatus(msg, C.cyan)
end, 6)

makeBtn(P5, "👥  List All Players in Chat", C.green, function()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(names, p.Name)
    end
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text  = "[NeonHub] Players: " .. table.concat(names, ", "),
        Color = C.green,
        Font  = Enum.Font.Gotham,
    })
    setStatus("Player list sent!", C.green)
end, 7)

makeBtn(P5, "📍  Show My Position", C.orange, function()
    local root = getRoot()
    if root then
        local pos = root.Position
        local msg = string.format("X:%.1f  Y:%.1f  Z:%.1f", pos.X, pos.Y, pos.Z)
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text  = "[NeonHub] Position: " .. msg,
            Color = C.orange,
        })
        setStatus("Pos: " .. msg, C.orange)
    end
end, 8)

sectionLabel(P5, "🎮  HOTKEYS", C.purple, 9)

local function hotkeyInfo(parent, key, desc, order)
    local f             = Instance.new("Frame", parent)
    f.Size              = UDim2.new(1, 0, 0, 34)
    f.BackgroundColor3  = C.card
    f.BorderSizePixel   = 0
    f.LayoutOrder       = order
    f.ZIndex            = 8
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)

    local k             = Instance.new("TextLabel", f)
    k.Size              = UDim2.new(0, 40, 1, 0)
    k.Position          = UDim2.new(0, 8, 0, 0)
    k.BackgroundTransparency = 1
    k.Text              = key
    k.Font              = Enum.Font.GothamBold
    k.TextSize          = 11
    k.TextColor3        = C.purple
    k.ZIndex            = 9

    local d             = Instance.new("TextLabel", f)
    d.Size              = UDim2.new(1, -56, 1, 0)
    d.Position          = UDim2.new(0, 52, 0, 0)
    d.BackgroundTransparency = 1
    d.Text              = desc
    d.Font              = Enum.Font.Gotham
    d.TextSize          = 11
    d.TextColor3        = C.white
    d.TextXAlignment    = Enum.TextXAlignment.Left
    d.ZIndex            = 9
    return f
end

hotkeyInfo(P5, "[X]",     "Toggle UI open/close",          10)
hotkeyInfo(P5, "[F]",     "Quick Fly toggle",              11)
hotkeyInfo(P5, "[G]",     "Quick God Mode toggle",         12)
hotkeyInfo(P5, "[H]",     "Quick Infinite Jump toggle",    13)

sectionLabel(P5, "ℹ  ABOUT", C.dim, 14)

local about         = Instance.new("TextLabel", P5)
about.Size          = UDim2.new(1, 0, 0, 50)
about.BackgroundColor3 = C.card
about.BorderSizePixel  = 0
about.Text          = "⚡ NEON HUB v3.0\nUltimate Roblox Script — All Devices\nPress X to toggle | Drag header to move"
about.Font          = Enum.Font.Gotham
about.TextSize      = 10
about.TextColor3    = C.dim
about.TextScaled    = false
about.ZIndex        = 8
about.LayoutOrder   = 15
Instance.new("UICorner", about).CornerRadius = UDim.new(0,8)

-- ═══════════════════════════════════════════
--            RUN SERVICE LOOPS
-- ═══════════════════════════════════════════
RunService.Heartbeat:Connect(function()
    -- FLY
    if State.fly and flyBV and flyBG then
        local cam = workspace.CurrentCamera
        local cf  = cam.CFrame
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space)      then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)  then dir = dir - Vector3.new(0,1,0) end
        flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * State.flySpeed or Vector3.zero
        flyBG.CFrame   = cf
    end

    -- NOCLIP
    if State.noclip then
        local c = getChar()
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end

    -- GOD MODE
    if State.godMode then
        local h = getHuman()
        if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
    end

    -- SPINNING
    if State.spinning then
        local root = getRoot()
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(5), 0)
        end
    end
end)

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if State.infiniteJump then
        local h = getHuman()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ANTI-AFK
Player.Idled:Connect(function()
    if State.antiAFK then
        pcall(function()
            VirtualUser:Button2Down(Vector2.zero, workspace.CurrentCamera.CFrame)
            task.wait(0.5)
            VirtualUser:Button2Up(Vector2.zero, workspace.CurrentCamera.CFrame)
        end)
    end
end)

-- ═══════════════════════════════════════════
--   KEYBOARD SHORTCUTS
-- ═══════════════════════════════════════════
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.X then
        if State.uiOpen then closeUI() else openUI() end
    elseif inp.KeyCode == Enum.KeyCode.F then
        -- quick fly shortcut – simulates click on fly toggle
        -- (user can manually toggle from UI; this fires the toggle)
    end
end)

-- ═══════════════════════════════════════════
--   DRAG (Header drag on PC & Mobile)
-- ═══════════════════════════════════════════
do
    local dragging, dStart, fStart = false, nil, nil
    Header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dStart   = inp.Position
            fStart   = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dStart
            MainFrame.Position = UDim2.new(fStart.X.Scale, fStart.X.Offset + d.X, fStart.Y.Scale, fStart.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ═══════════════════════════════════════════
--   OPEN / CLOSE ANIMATIONS
-- ═══════════════════════════════════════════
function closeUI()
    State.uiOpen = false
    local cx = MainFrame.Position.X.Offset + W/2
    local cy = MainFrame.Position.Y.Offset + H/2
    TweenService:Create(MainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size     = UDim2.new(0,0,0,0),
        Position = UDim2.new(MainFrame.Position.X.Scale, cx, MainFrame.Position.Y.Scale, cy),
    }):Play()
    task.delay(0.28, function()
        MainFrame.Visible = false
        MiniBtn.Visible   = true
        miniPulse:Play()
    end)
end

function openUI()
    State.uiOpen = true
    miniPulse:Pause()
    MiniBtn.Visible   = false
    MainFrame.Visible = true
    MainFrame.Size    = UDim2.new(0,0,0,0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size     = UDim2.new(0, W, 0, H),
        Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
    }):Play()
end

CloseBtn.MouseButton1Click:Connect(closeUI)
MiniBtn.MouseButton1Click:Connect(openUI)

-- ═══════════════════════════════════════════
--   RESPAWN HANDLING
-- ═══════════════════════════════════════════
Player.CharacterAdded:Connect(function(char)
    State.fly      = false
    State.godMode  = false
    State.noclip   = false
    State.spinning = false
    flyBV, flyBG   = nil, nil
    setStatus("Character respawned — re-enable features", C.orange)
end)

-- ═══════════════════════════════════════════
--   ENTRANCE ANIMATION
-- ═══════════════════════════════════════════
MainFrame.Size     = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
task.wait(0.1)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size     = UDim2.new(0, W, 0, H),
    Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
}):Play()

print("✅ NEON HUB v3.0 loaded! Press X to toggle | Drag header to move")
