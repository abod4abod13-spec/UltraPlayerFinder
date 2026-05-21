--[[
╔══════════════════════════════════════════════════════════════╗
║           ⚡ NEON HUB v2.0 — by Claude ⚡                   ║
║     Fly | Speed | Jump | Infinite Jump | & More              ║
╚══════════════════════════════════════════════════════════════╝
   كيفية الاستخدام:
   - انسخ هذا السكربت في Roblox Script Executor
   - اضغط X لإخفاء/إظهار الواجهة
   - الواجهة قابلة للسحب
--]]

-- ══════════════════════════════════════
--            SERVICES & VARIABLES
-- ══════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ══════════════════════════════════════
--             STATE VARIABLES
-- ══════════════════════════════════════
local flyEnabled = false
local flySpeed = 50
local jumpPower = 50
local infiniteJumpEnabled = false
local noclipEnabled = false
local speedEnabled = false
local walkSpeed = 16
local antiAFKEnabled = false
local espEnabled = false
local godModeEnabled = false
local flyBodyVelocity = nil
local flyBodyGyro = nil
local jumpCount = 0
local isUIOpen = true

-- ══════════════════════════════════════
--              NEON COLORS
-- ══════════════════════════════════════
local NEON_CYAN    = Color3.fromRGB(0, 255, 255)
local NEON_PINK    = Color3.fromRGB(255, 0, 128)
local NEON_PURPLE  = Color3.fromRGB(170, 0, 255)
local NEON_GREEN   = Color3.fromRGB(0, 255, 100)
local NEON_ORANGE  = Color3.fromRGB(255, 165, 0)
local NEON_YELLOW  = Color3.fromRGB(255, 255, 0)
local DARK_BG      = Color3.fromRGB(5, 5, 15)
local PANEL_BG     = Color3.fromRGB(8, 8, 25)
local CARD_BG      = Color3.fromRGB(12, 12, 35)

-- ══════════════════════════════════════
--            UI CREATION
-- ══════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- ══ MINI BUTTON (circle when closed) ══
local MiniButton = Instance.new("ImageButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.new(0, 56, 0, 56)
MiniButton.Position = UDim2.new(1, -75, 0.5, -28)
MiniButton.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
MiniButton.BorderSizePixel = 0
MiniButton.Visible = false
MiniButton.ZIndex = 10
MiniButton.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = NEON_CYAN
MiniStroke.Thickness = 2
MiniStroke.Parent = MiniButton

local MiniLabel = Instance.new("TextLabel")
MiniLabel.Size = UDim2.new(1, 0, 1, 0)
MiniLabel.BackgroundTransparency = 1
MiniLabel.Text = "⚡"
MiniLabel.TextScaled = true
MiniLabel.Font = Enum.Font.GothamBold
MiniLabel.TextColor3 = NEON_CYAN
MiniLabel.ZIndex = 11
MiniLabel.Parent = MiniButton

-- ══ GLOW PULSE for Mini Button ══
local miniGlowTween = TweenService:Create(MiniStroke,
    TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Color = NEON_PINK, Thickness = 3}
)

-- ══ MAIN FRAME ══
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 560)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -280)
MainFrame.BackgroundColor3 = DARK_BG
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = NEON_CYAN
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Animated border glow
local strokeTween = TweenService:Create(MainStroke,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Color = NEON_PURPLE, Thickness = 2.5}
)
strokeTween:Play()

-- ══ GRADIENT BACKGROUND ══
local BgGradient = Instance.new("UIGradient")
BgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 5, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 10, 25)),
})
BgGradient.Rotation = 135
BgGradient.Parent = MainFrame

-- ══ HEADER ══
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(8, 8, 30)
Header.BorderSizePixel = 0
Header.ZIndex = 2
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local HeaderGrad = Instance.new("UIGradient")
HeaderGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 128)),
})
HeaderGrad.Rotation = 90
HeaderGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.7),
    NumberSequenceKeypoint.new(1, 0.7),
})
HeaderGrad.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ NEON HUB v2.0"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 20
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3
TitleLabel.Parent = Header

local SubLabel = Instance.new("TextLabel")
SubLabel.Size = UDim2.new(1, -80, 0, 18)
SubLabel.Position = UDim2.new(0, 16, 0, 38)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "Ultimate Roblox Script"
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextSize = 11
SubLabel.TextColor3 = NEON_CYAN
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.ZIndex = 3
SubLabel.Parent = Header

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -44, 0, 14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 60)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.ZIndex = 5
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

-- ══ SCROLL FRAME for content ══
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -65)
ScrollFrame.Position = UDim2.new(0, 0, 0, 65)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = NEON_CYAN
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 900)
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = ScrollFrame

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.PaddingTop = UDim.new(0, 10)
Padding.Parent = ScrollFrame

-- ══════════════════════════════════════
--         HELPER: CREATE SECTION
-- ══════════════════════════════════════
local function createSection(title, color)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.BackgroundTransparency = 1
    Section.Parent = ScrollFrame

    local SectionLine = Instance.new("Frame")
    SectionLine.Size = UDim2.new(1, 0, 0, 1)
    SectionLine.Position = UDim2.new(0, 0, 0.5, 0)
    SectionLine.BackgroundColor3 = color or NEON_CYAN
    SectionLine.BackgroundTransparency = 0.5
    SectionLine.BorderSizePixel = 0
    SectionLine.Parent = Section

    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(0, 160, 1, 0)
    SectionLabel.Position = UDim2.new(0.5, -80, 0, 0)
    SectionLabel.BackgroundColor3 = DARK_BG
    SectionLabel.BorderSizePixel = 0
    SectionLabel.Text = title
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextSize = 12
    SectionLabel.TextColor3 = color or NEON_CYAN
    SectionLabel.Parent = Section

    return Section
end

-- ══════════════════════════════════════
--         HELPER: CREATE TOGGLE CARD
-- ══════════════════════════════════════
local function createToggleCard(labelText, accentColor, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 52)
    Card.BackgroundColor3 = CARD_BG
    Card.BorderSizePixel = 0
    Card.Parent = ScrollFrame

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 10)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = accentColor
    CardStroke.Thickness = 1
    CardStroke.Transparency = 0.6
    CardStroke.Parent = Card

    local CardGlow = Instance.new("UIGradient")
    CardGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, accentColor),
        ColorSequenceKeypoint.new(1, DARK_BG),
    })
    CardGlow.Rotation = 0
    CardGlow.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.92),
        NumberSequenceKeypoint.new(1, 1),
    })
    CardGlow.Parent = Card

    local IconDot = Instance.new("Frame")
    IconDot.Size = UDim2.new(0, 8, 0, 8)
    IconDot.Position = UDim2.new(0, 14, 0.5, -4)
    IconDot.BackgroundColor3 = accentColor
    IconDot.BorderSizePixel = 0
    IconDot.Parent = Card
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = IconDot

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -90, 1, 0)
    Label.Position = UDim2.new(0, 30, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 13
    Label.TextColor3 = Color3.fromRGB(220, 220, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    -- Toggle Switch
    local ToggleBG = Instance.new("Frame")
    ToggleBG.Size = UDim2.new(0, 46, 0, 24)
    ToggleBG.Position = UDim2.new(1, -58, 0.5, -12)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    ToggleBG.BorderSizePixel = 0
    ToggleBG.Parent = Card
    local TBGCorner = Instance.new("UICorner")
    TBGCorner.CornerRadius = UDim.new(1, 0)
    TBGCorner.Parent = ToggleBG

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -9)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(100, 100, 130)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleBG
    local TCCorner = Instance.new("UICorner")
    TCCorner.CornerRadius = UDim.new(1, 0)
    TCCorner.Parent = ToggleCircle

    local isOn = false
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Card

    ToggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            TweenService:Create(ToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = accentColor}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 25, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(CardStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
        else
            TweenService:Create(ToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 50)}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(100, 100, 130)
            }):Play()
            TweenService:Create(CardStroke, TweenInfo.new(0.2), {Transparency = 0.6}):Play()
        end
        callback(isOn)
    end)

    return Card, function() return isOn end
end

-- ══════════════════════════════════════
--         HELPER: CREATE SLIDER
-- ══════════════════════════════════════
local function createSlider(labelText, minVal, maxVal, defaultVal, accentColor, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 68)
    Card.BackgroundColor3 = CARD_BG
    Card.BorderSizePixel = 0
    Card.Parent = ScrollFrame

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 10)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = accentColor
    CardStroke.Thickness = 1
    CardStroke.Transparency = 0.5
    CardStroke.Parent = Card

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -70, 0, 22)
    SliderLabel.Position = UDim2.new(0, 12, 0, 8)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = labelText
    SliderLabel.Font = Enum.Font.GothamSemibold
    SliderLabel.TextSize = 12
    SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 230)
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = Card

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 55, 0, 22)
    ValueLabel.Position = UDim2.new(1, -65, 0, 8)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(defaultVal)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 13
    ValueLabel.TextColor3 = accentColor
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Card

    local TrackBG = Instance.new("Frame")
    TrackBG.Size = UDim2.new(1, -24, 0, 6)
    TrackBG.Position = UDim2.new(0, 12, 0, 40)
    TrackBG.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    TrackBG.BorderSizePixel = 0
    TrackBG.Parent = Card
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = TrackBG

    local fillPercent = (defaultVal - minVal) / (maxVal - minVal)

    local TrackFill = Instance.new("Frame")
    TrackFill.Size = UDim2.new(fillPercent, 0, 1, 0)
    TrackFill.BackgroundColor3 = accentColor
    TrackFill.BorderSizePixel = 0
    TrackFill.Parent = TrackBG
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = TrackFill

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(fillPercent, -8, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = TrackBG
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local KnobGlow = Instance.new("UIStroke")
    KnobGlow.Color = accentColor
    KnobGlow.Thickness = 2
    KnobGlow.Parent = Knob

    local dragging = false

    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Size = UDim2.new(1, 0, 1, 0)
    SliderBtn.BackgroundTransparency = 1
    SliderBtn.Text = ""
    SliderBtn.ZIndex = 5
    SliderBtn.Parent = TrackBG

    SliderBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    RunService.Heartbeat:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = TrackBG.AbsolutePosition
            local trackSize = TrackBG.AbsoluteSize
            local relX = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            local value = math.floor(minVal + relX * (maxVal - minVal))
            TrackFill.Size = UDim2.new(relX, 0, 1, 0)
            Knob.Position = UDim2.new(relX, -8, 0.5, -8)
            ValueLabel.Text = tostring(value)
            callback(value)
        end
    end)

    return Card
end

-- ══════════════════════════════════════
--         HELPER: CREATE ACTION BUTTON
-- ══════════════════════════════════════
local function createActionButton(labelText, accentColor, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = Color3.fromRGB(10, 10, 28)
    Btn.BorderSizePixel = 0
    Btn.Text = labelText
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.TextColor3 = accentColor
    Btn.Parent = ScrollFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 10)
    BtnCorner.Parent = Btn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = accentColor
    BtnStroke.Thickness = 1.5
    BtnStroke.Parent = Btn

    local BtnGrad = Instance.new("UIGradient")
    BtnGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, accentColor),
        ColorSequenceKeypoint.new(1, DARK_BG),
    })
    BtnGrad.Rotation = 0
    BtnGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.88),
        NumberSequenceKeypoint.new(1, 1),
    })
    BtnGrad.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = accentColor}):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(10, 10, 28)}):Play()
        callback()
    end)

    Btn.MouseEnter:Connect(function()
        TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Thickness = 2.5}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Thickness = 1.5}):Play()
    end)

    return Btn
end

-- ══════════════════════════════════════
--              STATUS BAR
-- ══════════════════════════════════════
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, 0, 0, 28)
StatusBar.BackgroundColor3 = Color3.fromRGB(6, 6, 20)
StatusBar.BorderSizePixel = 0
StatusBar.ZIndex = 5
StatusBar.Parent = MainFrame

-- Position at bottom of scroll area
local StatusBarCorner = Instance.new("UICorner")
StatusBarCorner.CornerRadius = UDim.new(0, 10)
StatusBarCorner.Parent = StatusBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "● NEON HUB — Ready"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 10
StatusLabel.TextColor3 = NEON_GREEN
StatusLabel.ZIndex = 6
StatusLabel.Parent = StatusBar

local function setStatus(msg, color)
    StatusLabel.Text = "● " .. msg
    StatusLabel.TextColor3 = color or NEON_GREEN
end

-- ══════════════════════════════════════
--         BUILD THE UI SECTIONS
-- ══════════════════════════════════════

-- ── SECTION: MOVEMENT ──
createSection("✈  MOVEMENT", NEON_CYAN)

-- Fly Toggle
createToggleCard("🚀  Fly Mode", NEON_CYAN, function(state)
    flyEnabled = state
    setStatus(state and "Fly Mode ON — Use WASD + Space/Shift" or "Fly Mode OFF", state and NEON_CYAN or NEON_GREEN)

    if state then
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Name = "FlyBV"
        bv.Parent = RootPart
        flyBodyVelocity = bv

        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.P = 1e4
        bg.Name = "FlyBG"
        bg.Parent = RootPart
        flyBodyGyro = bg

        Humanoid.PlatformStand = true
    else
        Humanoid.PlatformStand = false
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
        flyBodyVelocity = nil
        flyBodyGyro = nil
    end
end)

-- Fly Speed Slider
createSlider("✈  Fly Speed", 10, 300, flySpeed, NEON_CYAN, function(v)
    flySpeed = v
end)

-- Walk Speed Toggle
createToggleCard("⚡  Speed Boost", NEON_YELLOW, function(state)
    speedEnabled = state
    Humanoid.WalkSpeed = state and walkSpeed or 16
    setStatus(state and "Speed Boost ON" or "Speed Boost OFF", state and NEON_YELLOW or NEON_GREEN)
end)

-- Walk Speed Slider
createSlider("🏃  Walk Speed", 16, 200, 16, NEON_YELLOW, function(v)
    walkSpeed = v
    if speedEnabled then
        Humanoid.WalkSpeed = v
    end
end)

-- ── SECTION: JUMP ──
createSection("🦘  JUMP", NEON_PINK)

-- Jump Power Slider
createSlider("⬆  Jump Power", 50, 500, 50, NEON_PINK, function(v)
    jumpPower = v
    Humanoid.JumpPower = v
end)

-- Infinite Jump
createToggleCard("♾  Infinite Jump", NEON_PINK, function(state)
    infiniteJumpEnabled = state
    setStatus(state and "Infinite Jump ON" or "Infinite Jump OFF", state and NEON_PINK or NEON_GREEN)
end)

-- ── SECTION: PLAYER ──
createSection("🛡  PLAYER", NEON_PURPLE)

-- God Mode
createToggleCard("💀  God Mode", NEON_PURPLE, function(state)
    godModeEnabled = state
    if state then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
    else
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
    end
    setStatus(state and "God Mode ON — Immortal!" or "God Mode OFF", state and NEON_PURPLE or NEON_GREEN)
end)

-- Noclip
createToggleCard("👻  Noclip", NEON_ORANGE, function(state)
    noclipEnabled = state
    setStatus(state and "Noclip ON" or "Noclip OFF", state and NEON_ORANGE or NEON_GREEN)
end)

-- Anti-AFK
createToggleCard("⏰  Anti-AFK", NEON_GREEN, function(state)
    antiAFKEnabled = state
    setStatus(state and "Anti-AFK ON" or "Anti-AFK OFF", state and NEON_GREEN or NEON_GREEN)
end)

-- ── SECTION: UTILITIES ──
createSection("🔧  UTILITIES", NEON_ORANGE)

-- Reset Character
createActionButton("🔄  Reset Character", NEON_ORANGE, function()
    Humanoid.Health = 0
    setStatus("Character Reset!", NEON_ORANGE)
end)

-- Rejoin Server
createActionButton("🔃  Rejoin Server", NEON_YELLOW, function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:Teleport(game.PlaceId, Player)
end)

-- Sit
createActionButton("🪑  Sit Down", NEON_CYAN, function()
    Humanoid.Sit = true
    setStatus("Player is sitting", NEON_CYAN)
end)

-- Invisible (Server Visual Only)
createToggleCard("🔮  Semi-Invisible", NEON_PURPLE, function(state)
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            TweenService:Create(part, TweenInfo.new(0.5), {
                Transparency = state and 0.8 or 0
            }):Play()
        end
    end
    setStatus(state and "Semi-Invisible ON" or "Invisible OFF", state and NEON_PURPLE or NEON_GREEN)
end)

-- ── SECTION: ESP ──
createSection("👁  ESP / VISUALS", NEON_GREEN)

createToggleCard("🎯  Player ESP (Names)", NEON_GREEN, function(state)
    espEnabled = state
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local existing = head:FindFirstChild("ESPBillboard")
                if state then
                    if not existing then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "ESPBillboard"
                        bb.Size = UDim2.new(0, 80, 0, 30)
                        bb.StudsOffset = Vector3.new(0, 3, 0)
                        bb.AlwaysOnTop = true
                        bb.Parent = head
                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.Text = plr.Name
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 14
                        lbl.TextColor3 = NEON_GREEN
                        lbl.Parent = bb
                    end
                else
                    if existing then existing:Destroy() end
                end
            end
        end
    end
    setStatus(state and "ESP ON" or "ESP OFF", state and NEON_GREEN or NEON_GREEN)
end)

-- Fullbright
createToggleCard("☀  Fullbright", NEON_YELLOW, function(state)
    local Lighting = game:GetService("Lighting")
    Lighting.Brightness = state and 10 or 2
    Lighting.ClockTime = state and 14 or Lighting.ClockTime
    setStatus(state and "Fullbright ON" or "Fullbright OFF", state and NEON_YELLOW or NEON_GREEN)
end)

-- ══════════════════════════════════════
--          FLY LOGIC (Heartbeat)
-- ══════════════════════════════════════
RunService.Heartbeat:Connect(function()
    if flyEnabled and flyBodyVelocity and flyBodyGyro then
        local camera = workspace.CurrentCamera
        local cf = camera.CFrame
        local direction = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + cf.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - cf.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - cf.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + cf.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0, 1, 0)
        end

        flyBodyVelocity.Velocity = direction.Magnitude > 0 and direction.Unit * flySpeed or Vector3.new(0, 0, 0)
        flyBodyGyro.CFrame = cf
    end

    -- Noclip logic
    if noclipEnabled then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    -- God Mode health
    if godModeEnabled then
        if Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end
end)

-- ══════════════════════════════════════
--        INFINITE JUMP LOGIC
-- ══════════════════════════════════════
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ══════════════════════════════════════
--        ANTI-AFK LOGIC
-- ══════════════════════════════════════
local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    if antiAFKEnabled then
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)

-- ══════════════════════════════════════
--        DRAGGING LOGIC
-- ══════════════════════════════════════
local draggingUI = false
local dragStart = nil
local frameStart = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        draggingUI = true
        dragStart = input.Position
        frameStart = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingUI and (input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            frameStart.X.Scale,
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        draggingUI = false
    end
end)

-- ══════════════════════════════════════
--       OPEN / CLOSE LOGIC
-- ══════════════════════════════════════
local function closeUI()
    isUIOpen = false
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 190,
                             MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + 280)
    }):Play()
    task.wait(0.3)
    MainFrame.Visible = false
    MiniButton.Visible = true
    miniGlowTween:Play()
end

local function openUI()
    isUIOpen = true
    MiniButton.Visible = false
    miniGlowTween:Pause()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 560)
    }):Play()
end

CloseBtn.MouseButton1Click:Connect(closeUI)
MiniButton.MouseButton1Click:Connect(openUI)

-- X key shortcut
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.X then
        if isUIOpen then
            closeUI()
        else
            openUI()
        end
    end
end)

-- ══════════════════════════════════════
--       CHARACTER RESPAWN HANDLING
-- ══════════════════════════════════════
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    flyEnabled = false
    flyBodyVelocity = nil
    flyBodyGyro = nil
    setStatus("Character Respawned — Re-enable features", NEON_ORANGE)
end)

-- ══════════════════════════════════════
--          ENTRANCE ANIMATION
-- ══════════════════════════════════════
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 380, 0, 560)
}):Play()

-- Status bar position
StatusBar.Position = UDim2.new(0, 0, 1, -28)

print("✅ NEON HUB v2.0 — Loaded Successfully!")
print("📌 Press X to toggle UI | Drag the header to move")
