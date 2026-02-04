--ZOSKRON UI LIBRARY BROOOOOOOOO
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local function tween(obj, t, props)
	TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local gui = Instance.new("ScreenGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300, 60)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
Instance.new("UIStroke", main).Color = Color3.fromRGB(55,55,55)

-- drag
do
	local dragging, start, pos
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			start = i.Position
			pos = main.Position
		end
	end)
	main.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - start
			main.Position = UDim2.fromOffset(pos.X.Offset + d.X, pos.Y.Offset + d.Y)
		end
	end)
end

local layout = Instance.new("UIListLayout", main)
layout.Padding = UDim.new(0, 10)

local pad = Instance.new("UIPadding", main)
pad.PaddingTop = UDim.new(0, 14)
pad.PaddingBottom = UDim.new(0, 14)
pad.PaddingLeft = UDim.new(0, 14)
pad.PaddingRight = UDim.new(0, 14)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	main.Size = UDim2.fromOffset(300, layout.AbsoluteContentSize.Y + 28)
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,28)
title.BackgroundTransparency = 1
title.Text = "MiniUI"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Left
title.TextColor3 = Color3.fromRGB(235,235,235)
title.Parent = main

-- API Table
local UI = {}

function UI:Button(text, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,36)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.fromRGB(220,220,220)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.AutoButtonColor = false
	b.Parent = main
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	b.MouseEnter:Connect(function()
		tween(b,0.15,{BackgroundColor3=Color3.fromRGB(45,45,45)})
	end)
	b.MouseLeave:Connect(function()
		tween(b,0.15,{BackgroundColor3=Color3.fromRGB(30,30,30)})
	end)
	b.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
end

function UI:Slider(text, min, max, default, callback)
	-- slider implementation (same)
end

function UI:Dropdown(text, options, callback)
	-- dropdown implementation (same)
end

function UI:CopyLabel(text, link)
	-- copy label implementation (same)
end

return UI
