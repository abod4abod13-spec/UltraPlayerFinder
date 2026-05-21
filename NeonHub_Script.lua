local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-------------------------------------------------
-- GUI
-------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "UltraPlayerFinder"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-------------------------------------------------
-- Main Frame
-------------------------------------------------

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 240)
main.Position = UDim2.new(0.5, -180, 0.5, -120)
main.BackgroundColor3 = Color3.fromRGB(18,18,28)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,22)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2.5
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Parent = main

-------------------------------------------------
-- Glow Animation
-------------------------------------------------

TweenService:Create(
	stroke,
	TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{
		Color = Color3.fromRGB(255,0,170)
	}
):Play()

-------------------------------------------------
-- Title
-------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "🌌 Ultra Player Finder"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = main

-------------------------------------------------
-- Close Button
-------------------------------------------------

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,32,0,32)
close.Position = UDim2.new(1,-42,0,10)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.TextColor3 = Color3.fromRGB(255,255,255)
close.BackgroundColor3 = Color3.fromRGB(255,70,70)
close.BorderSizePixel = 0
close.Parent = main

Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-------------------------------------------------
-- Player Image
-------------------------------------------------

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0,80,0,80)
avatar.Position = UDim2.new(0.5,-40,0,55)
avatar.BackgroundTransparency = 1
avatar.Image = "rbxassetid://0"
avatar.Parent = main

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1,0)
avatarCorner.Parent = avatar

-------------------------------------------------
-- TextBox
-------------------------------------------------

local box = Instance.new("TextBox")
box.Size = UDim2.new(0.82,0,0,42)
box.Position = UDim2.new(0.09,0,0,145)
box.PlaceholderText = "اكتب اسم اللاعب..."
box.Text = ""
box.Font = Enum.Font.Gotham
box.TextSize = 18
box.TextColor3 = Color3.fromRGB(255,255,255)
box.BackgroundColor3 = Color3.fromRGB(30,30,45)
box.BorderSizePixel = 0
box.Parent = main

Instance.new("UICorner", box).CornerRadius = UDim.new(0,14)

-------------------------------------------------
-- Join Button
-------------------------------------------------

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.65,0,0,42)
button.Position = UDim2.new(0.175,0,1,-55)
button.Text = "🚀 Join Server"
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.TextColor3 = Color3.fromRGB(255,255,255)
button.BackgroundColor3 = Color3.fromRGB(0,140,255)
button.BorderSizePixel = 0
button.Parent = main

Instance.new("UICorner", button).CornerRadius = UDim.new(0,16)

-------------------------------------------------
-- Hover Effect
-------------------------------------------------

button.MouseEnter:Connect(function()
	TweenService:Create(button,TweenInfo.new(0.15),{
		Size = UDim2.new(0.68,0,0,45)
	}):Play()
end)

button.MouseLeave:Connect(function()
	TweenService:Create(button,TweenInfo.new(0.15),{
		Size = UDim2.new(0.65,0,0,42)
	}):Play()
end)

-------------------------------------------------
-- Draggable GUI
-------------------------------------------------

local dragging = false
local dragInput
local dragStart
local startPos

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart

		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-------------------------------------------------
-- Avatar Preview
-------------------------------------------------

box:GetPropertyChangedSignal("Text"):Connect(function()

	local txt = box.Text

	if txt ~= "" then

		local success, userId = pcall(function()
			return Players:GetUserIdFromNameAsync(txt)
		end)

		if success then

			local content, ready = Players:GetUserThumbnailAsync(
				userId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size420x420
			)

			avatar.Image = content
		end
	end
end)

-------------------------------------------------
-- Join System
-------------------------------------------------

button.MouseButton1Click:Connect(function()

	local targetName = box.Text

	if targetName == "" then
		button.Text = "❌ اكتب اسم"
		wait(1)
		button.Text = "🚀 Join Server"
		return
	end

	button.Text = "🔍 Searching..."

	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(targetName)
	end)

	if success then

		local ok, err = pcall(function()

			TeleportService:TeleportToPlaceInstance(
				game.PlaceId,
				game.JobId,
				player,
				nil,
				{
					targetUserId = userId
				}
			)

		end)

		if not ok then
			button.Text = "❌ مو موجود"
			wait(2)
			button.Text = "🚀 Join Server"
		end

	else
		button.Text = "❌ لاعب غلط"
		wait(2)
		button.Text = "🚀 Join Server"
	end
end)
