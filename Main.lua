-- ╔═══════════════════════════════════════════════════════════════╗
-- ║        DELTA EXECUTOR ADVANCED SCRIPT - ROBLOX              ║
-- ║              Created by: Professional Developer              ║
-- ╚═══════════════════════════════════════════════════════════════╝

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetWorkspace()
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                    متغيرات النظام الأساسية                   ║
-- ╚═══════════════════════════════════════════════════════════════╝

local Config = {
    -- إعدادات الطيران
    Flying = false,
    FlySpeed = 50,
    MaxFlySpeed = 150,
    MinFlySpeed = 10,
    
    -- إعدادات النط
    JumpPower = 50,
    MaxJumpPower = 200,
    
    -- اختراق الجدران
    WallBreak = false,
    
    -- الاستهداف
    TargetPlayer = nil,
    TargetMode = false,
    
    -- الأيم بوت
    AimBot = false,
    AimBotFOV = 100,
    
    -- التأثيرات
    LagReduction = false,
    ShaderEnabled = false,
    AntiKnockback = false,
    ReverseKnockback = false,
    
    -- الفلنق
    FlungEnabled = false,
    FlungPower = 100,
    
    -- الإدارة
    AdminCommands = true,
    
    -- الحفظ والتحميل
    SavedPositions = {},
    SavedConfigs = {}
}

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                      نظام واجهة المستخدم                     ║
-- ╚═══════════════════════════════════════════════════════════════╝

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaExecutorGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function CreateButton(Name, Position, Size, Text, Callback)
    local Button = Instance.new("TextButton")
    Button.Name = Name
    Button.Position = Position
    Button.Size = Size
    Button.Text = Text
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.TextColor3 = Color3.fromRGB(0, 255, 100)
    Button.BorderSizePixel = 2
    Button.BorderColor3 = Color3.fromRGB(0, 255, 100)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.Parent = ScreenGui
    
    Button.MouseButton1Click:Connect(Callback)
    return Button
end

local function CreateTextBox(Name, Position, Size, PlaceholderText)
    local TextBox = Instance.new("TextBox")
    TextBox.Name = Name
    TextBox.Position = Position
    TextBox.Size = Size
    TextBox.PlaceholderText = PlaceholderText
    TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TextBox.TextColor3 = Color3.fromRGB(0, 255, 100)
    TextBox.BorderSizePixel = 2
    TextBox.BorderColor3 = Color3.fromRGB(0, 255, 100)
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 12
    TextBox.Parent = ScreenGui
    return TextBox
end

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                      نظام الطيران المتقدم                    ║
-- ╚═══════════════════════════════════════════════════════════════╝

local FlyConnection
local FlySpeed_Display = CreateTextBox("FlySpeedBox", UDim2.new(0, 10, 0, 10), UDim2.new(0, 100, 0, 25), "سرعة الطيران")

local function StartFlying()
    if Config.Flying then return end
    Config.Flying = true
    
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BodyVelocity.Parent = RootPart
    
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BodyGyro.Parent = RootPart
    
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not Config.Flying then
            BodyVelocity:Destroy()
            BodyGyro:Destroy()
            FlyConnection:Disconnect()
            return
        end
        
        local Camera = workspace.CurrentCamera
        local MoveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            MoveDirection = MoveDirection + (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            MoveDirection = MoveDirection - (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            MoveDirection = MoveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            MoveDirection = MoveDirection + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            MoveDirection = MoveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            MoveDirection = MoveDirection - Vector3.new(0, 1, 0)
        end
        
        if MoveDirection.Magnitude > 0 then
            MoveDirection = MoveDirection.Unit
        end
        
        BodyVelocity.Velocity = MoveDirection * Config.FlySpeed
        BodyGyro.CFrame = Camera.CFrame
    end)
end

local function StopFlying()
    Config.Flying = false
end

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                    نظام اختراق الجدران                       ║
-- ╚═══════════════════════════════════════════════════════════════╝

local function EnableWallBreak()
    Config.WallBreak = true
    for _, Part in pairs(Character:GetDescendants()) do
        if Part:IsA("BasePart") then
            Part.CanCollide = false
        end
    end
    
    Character.DescendantAdded:Connect(function(Descendant)
        if Descendant:IsA("BasePart") then
            Descendant.CanCollide = false
        end
    end)
end

local function DisableWallBreak()
    Config.WallBreak = false
    for _, Part in pairs(Character:GetDescendants()) do
        if Part:IsA("BasePart") then
            Part.CanCollide = true
        end
    end
end

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                    نظام الاستهداف المتقدم                    ║
-- ╚═══════════════════════════════════════════════════════════════╝

local TargetNameBox = CreateTextBox("TargetNameBox", UDim2.new(0, 10, 0, 50), UDim2.new(0, 150, 0, 25), "اسم اللاعب")

local function FindPlayerByName(Name)
    for _, Player in pairs(Players:GetPlayers()) do
        if Player.Name:lower():find(Name:lower()) then
            return Player
        end
    end
    return nil
end

local function BangPlayer(TargetPlayer)
    if not TargetPlayer or not TargetPlayer.Character then return end
    
    local TargetHumanoid = TargetPlayer.Character:FindFirstChild("Humanoid")
    local TargetRootPart = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if TargetHumanoid and TargetRootPart then
        -- Bang من الأمام
        local BangVelocity = Instance.new("BodyVelocity")
        BangVelocity.Velocity = (TargetRootPart.Position - RootPart.Position).Unit * 100
        BangVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BangVelocity.Parent = TargetRootPart
        
        game:GetService("Debris"):AddItem(BangVelocity, 0.1)
        
        -- Bang من الخلف
        wait(0.05)
        local BangVelocity2 = Instance.new("BodyVelocity")
        BangVelocity2.Velocity = (RootPart.Position - TargetRootPart.Position).Unit * 100
        BangVelocity2.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BangVelocity2.Parent = TargetRootPart
        
        game:GetService("Debris"):AddItem(BangVelocity2, 0.1)
        
        -- Bang من الرأس
        wait(0.05)
        local Head = TargetPlayer.Character:FindFirstChild("Head")
        if Head then
            local HeadBang = Instance.new("BodyVelocity")
            HeadBang.Velocity = Vector3.new(0, 100, 0)
            HeadBang.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            HeadBang.Parent = Head
            game:GetService("Debris"):AddItem(HeadBang, 0.1)
        end
    end
end

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                      نظام الفلنق المتقدم                     ║
-- ╚═══════════════════════════════════════════════════════════════╝

local function FlungPlayer(TargetPlayer)
    if not TargetPlayer or not TargetPlayer.Character then return end
    
    local TargetRootPart = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if TargetRootPart then
        local Flung = Instance.new("BodyVelocity")
        Flung.Velocity = Vector3.new(
            math.random(-Config.FlungPower, Config.FlungPower),
            Config.FlungPower * 2,
            math.random(-Config.FlungPower, Config.FlungPower)
        )
        Flung.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        Flung.Parent = TargetRootPart
        
        game:GetService("Debris"):AddItem(Flung, 0.5)
    end
end

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                      نظام حفظ المواقع                        ║
-- ╚═══════════════════════════════════════════════════════════════╝

local function SavePosition(Name)
    Config.SavedPositions[Name] = RootPart.Position
    print("✓ تم حفظ الموقع: " .. Name)
end

local function LoadPosition(Name)
    if Config.SavedPositions[Name] then
        RootPart.Position = Config.SavedPositions[Name]
        print("✓ تم التنقل إلى: " .. Name)
    end
end

local function DeletePosition(Name)
    Config.SavedPositions[Name] = nil
    print("✓ تم حذف الموقع: " .. Name)
end

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                    نظام تقليل التأخير (Lag)                  ║
-- ╚═══════════════════════════════════════════════════════════════╝

local function EnableLagReduction()
    Config.LagReduction = true
    
    for _, Part in pairs(Workspace:GetDescendants()) do
        if Part:IsA("BasePart") and Part.Parent ~= Character then
            Part.CanCollide = false
        end
    end
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if Config.LagReduction then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer and Player.Character then
                    for _, Part in pairs(Player.Character:GetDescendants()) do
                        if Part:IsA("BasePart") then
                            Part.CanCollide = false
                        end
                    end
                end
            end
        end
    end)
end

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                    نظام الأيم بوت المتقدم                    ║
-- ╚═══════════════════════════════════════════════════════════════╝

local function EnableAimBot()
    Config.AimBot = true
    
    RunService.RenderStepped:Connect(function()
        if not Config.AimBot or not Config.TargetPlayer or not Config.TargetPlayer.Character then return end
        
        local TargetHead = Config.TargetPlayer.Character:FindFirstChild("Head")
        if TargetHead then
            local Camera = workspace.CurrentCamera
            local Direction = (TargetHead.Position - Camera.CFrame.Position).Unit
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Direction)
        end
    end)
end

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                    نظام مضاد الضربات                         ║
-- ╚═══════════════════════════════════════════════════════════════╝

local function EnableAntiKnockback()
    Config.AntiKnockback = true
    
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = RootPart
    
    RunService.Heartbeat:Connect(function()
        if Config.AntiKnockback then
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                    نظام الضربة العكسية                       ║
-- ╚═══════════════════════════════════════════════════════════════╝

local function EnableReverseKnockback()
    Config.ReverseKnockback = true
    
    RunService.Heartbeat:Connect(function()
        if Config.ReverseKnockback and RootPart.AssemblyLinearVelocity.Magnitude > 50 then
            RootPart.AssemblyLinearVelocity = -RootPart.AssemblyLinearVelocity
        end
    end)
end

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                    نظام أوامر الإدمن                         ║
-- ╚═══════════════════════════════════════════════════════════════╝

local AdminCommands = {
    ["kill"] = function(Args)
        if Args[1] then
            local Target = FindPlayerByName(Args[1])
            if Target and Target.Character then
                Target.Character:BreakJoints()
            end
        end
    end,
    
    ["teleport"] = function(Args)
        if Args[1] then
            local Target = FindPlayerByName(Args[1])
            if Target and Target.Character then
                RootPart.Position = Target.Character.HumanoidRootPart.Position
            end
        end
    end,
    
    ["bring"] = function(Args)
        if Args[1] then
            local Target = FindPlayerByName(Args[1])
            if Target and Target.Character then
                Target.Character.HumanoidRootPart.Position = RootPart.Position
            end
        end
    end,
    
    ["speed"] = function(Args)
        if Args[1] then
            Config.FlySpeed = tonumber(Args[1]) or 50
        end
    end,
    
    ["jump"] = function(Args)
        if Args[1] then
            Config.JumpPower = tonumber(Args[1]) or 50
            Humanoid.JumpPower = Config.JumpPower
        end
    end
}

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                      إنشاء الأزرار والواجهة                   ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- الصف الأول
CreateButton("FlyBtn", UDim2.new(0, 10, 0, 40), UDim2.new(0, 80, 0, 30), "تفعيل الطيران", function()
    if Config.Flying then
        StopFlying()
    else
        StartFlying()
    end
end)

CreateButton("WallBtn", UDim2.new(0, 100, 0, 40), UDim2.new(0, 80, 0, 30), "اختراق جدران", function()
    if Config.WallBreak then
        DisableWallBreak()
    else
        EnableWallBreak()
    end
end)

CreateButton("LagBtn", UDim2.new(0, 190, 0, 40), UDim2.new(0, 80, 0, 30), "تقليل Lag", function()
    EnableLagReduction()
end)

-- الصف الثاني
CreateButton("BangBtn", UDim2.new(0, 10, 0, 80), UDim2.new(0, 80, 0, 30), "Bang", function()
    local TargetName = TargetNameBox.Text
    local Target = FindPlayerByName(TargetName)
    if Target then
        BangPlayer(Target)
    end
end)

CreateButton("FlungBtn", UDim2.new(0, 100, 0, 80), UDim2.new(0, 80, 0, 30), "Flung", function()
    local TargetName = TargetNameBox.Text
    local Target = FindPlayerByName(TargetName)
    if Target then
        FlungPlayer(Target)
    end
end)

CreateButton("AimBtn", UDim2.new(0, 190, 0, 80), UDim2.new(0, 80, 0, 30), "Aim Bot", function()
    local TargetName = TargetNameBox.Text
    Config.TargetPlayer = FindPlayerByName(TargetName)
    if Config.TargetPlayer then
        EnableAimBot()
    end
end)

-- الصف الثالث
CreateButton("AntiKBBtn", UDim2.new(0, 10, 0, 120), UDim2.new(0, 80, 0, 30), "مضاد ضربات", function()
    EnableAntiKnockback()
end)

CreateButton("ReverseKBBtn", UDim2.new(0, 100, 0, 120), UDim2.new(0, 80, 0, 30), "ضربة عكسية", function()
    EnableReverseKnockback()
end)

CreateButton("SavePosBtn", UDim2.new(0, 190, 0, 120), UDim2.new(0, 80, 0, 30), "حفظ موقع", function()
    SavePosition("Position_" .. os.time())
end)

-- الصف الرابع
CreateButton("LoadPosBtn", UDim2.new(0, 10, 0, 160), UDim2.new(0, 80, 0, 30), "تحميل موقع", function()
    local Positions = {}
    for Name, _ in pairs(Config.SavedPositions) do
        table.insert(Positions, Name)
    end
    if #Positions > 0 then
        LoadPosition(Positions[1])
    end
end)

CreateButton("DeletePosBtn", UDim2.new(0, 100, 0, 160), UDim2.new(0, 80, 0, 30), "حذف موقع", function()
    local Positions = {}
    for Name, _ in pairs(Config.SavedPositions) do
        table.insert(Positions, Name)
    end
    if #Positions > 0 then
        DeletePosition(Positions[1])
    end
end)

CreateButton("TeleportBtn", UDim2.new(0, 190, 0, 160), UDim2.new(0, 80, 0, 30), "تنقل لاعب", function()
    local TargetName = TargetNameBox.Text
    local Target = FindPlayerByName(TargetName)
    if Target and Target.Character then
        RootPart.Position = Target.Character.HumanoidRootPart.Position
    end
end)

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                    اختصارات لوحة المفاتيح                    ║
-- ╚═══════════════════════════════════════════════════════════════╝

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    
    if Input.KeyCode == Enum.KeyCode.F then
        if Config.Flying then
            StopFlying()
        else
            StartFlying()
        end
    elseif Input.KeyCode == Enum.KeyCode.G then
        EnableWallBreak()
    elseif Input.KeyCode == Enum.KeyCode.H then
        Config.JumpPower = 100
        Humanoid.JumpPower = Config.JumpPower
    elseif Input.KeyCode == Enum.KeyCode.J then
        local TargetName = TargetNameBox.Text
        local Target = FindPlayerByName(TargetName)
        if Target then
            BangPlayer(Target)
        end
    end
end)

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║                    تحديث سرعة الطيران الديناميكي              ║
-- ╚═══════════════════════════════════════════════════════════════╝

RunService.Heartbeat:Connect(function()
    if FlySpeed_Display.Text ~= "" then
        local NewSpeed = tonumber(FlySpeed_Display.Text)
        if NewSpeed and NewSpeed >= Config.MinFlySpeed and NewSpeed <= Config.MaxFlySpeed then
            Config.FlySpeed = NewSpeed
        end
    end
end)

print("✓ تم تحميل السكربت بنجاح!")
print("اضغط F لتفعيل الطيران")
print("اضغط G لاختراق الجدران")
print("اضغط H لزيادة قوة النط")
print("اضغط J لـ Bang اللاعب المستهدف")
