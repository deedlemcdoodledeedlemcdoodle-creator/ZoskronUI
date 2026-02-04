--Zoskron UI IT'S COOOOOOOOOOOOL
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

-- dragging
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
pad.PaddingAll = UDim.new(0, 14)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	main.Size = UDim2.fromOffset(300, layout.AbsoluteContentSize.Y + 28)
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,28)
title.BackgroundTransparency = 1
title.Text = "MiniUI"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Left
title.TextColor3 = Color3.fromRGB(235,235,235)
title.Parent = main

-- exposed API
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
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1,0,0,50)
	holder.BackgroundTransparency = 1
	holder.Parent = main

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,0,18)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = Color3.fromRGB(220,220,220)
	label.Text = text.." : "..default
	label.Parent = holder

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1,0,0,10)
	bar.Position = UDim2.fromOffset(0,28)
	bar.BackgroundColor3 = Color3.fromRGB(35,35,35)
	bar.Parent = holder
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale((default-min)/(max-min),1)
	fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
	fill.Parent = bar
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

	local dragging = false
	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local x = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			fill.Size = UDim2.fromScale(x,1)
			local v = math.floor(min + (max-min)*x)
			label.Text = text.." : "..v
			if callback then callback(v) end
		end
	end)
end

function UI:Dropdown(text, options, callback)
	local open = false

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,36)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(220,220,220)
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.AutoButtonColor = false
	btn.Parent = main
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

	local list = Instance.new("Frame")
	list.Size = UDim2.new(1,0,0,0)
	list.ClipsDescendants = true
	list.BackgroundColor3 = Color3.fromRGB(25,25,25)
	list.Parent = main
	Instance.new("UICorner", list).CornerRadius = UDim.new(0,12)

	local l = Instance.new("UIListLayout", list)

	btn.MouseButton1Click:Connect(function()
		open = not open
		tween(list,0.25,{Size=open and UDim2.fromOffset(300,#options*32) or UDim2.new(1,0,0,0)})
	end)

	for _,v in ipairs(options) do
		local o = Instance.new("TextButton")
		o.Size = UDim2.new(1,0,0,32)
		o.Text = v
		o.Font = Enum.Font.Gotham
		o.TextSize = 13
		o.TextColor3 = Color3.fromRGB(220,220,220)
		o.BackgroundTransparency = 1
		o.Parent = list

		o.MouseButton1Click:Connect(function()
			btn.Text = text..": "..v
			open = false
			tween(list,0.25,{Size=UDim2.new(1,0,0,0)})
			if callback then callback(v) end
		end)
	end
end

function UI:CopyLabel(text, link)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,0,36)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	frame.Parent = main
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,-60,1,0)
	lbl.Position = UDim2.fromOffset(10,0)
	lbl.BackgroundTransparency = 1
	lbl.TextXAlignment = Left
	lbl.Text = text
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextColor3 = Color3.fromRGB(220,220,220)
	lbl.Parent = frame

	local copy = Instance.new("TextButton")
	copy.Size = UDim2.fromOffset(50,22)
	copy.Position = UDim2.fromScale(1,0.5)
	copy.AnchorPoint = Vector2.new(1,0.5)
	copy.Text = "Copy"
	copy.Font = Enum.Font.GothamBold
	copy.TextSize = 12
	copy.TextColor3 = Color3.fromRGB(0,0,0)
	copy.BackgroundColor3 = Color3.fromRGB(0,170,255)
	copy.Parent = frame
	Instance.new("UICorner", copy).CornerRadius = UDim.new(1,0)

	copy.MouseButton1Click:Connect(function()
		setclipboard(link)
		copy.Text = "Copied"
		task.delay(1,function()
			copy.Text = "Copy"
		end)
	end)
end

return UI
