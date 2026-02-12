local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local UI = {}
local Sections = {}
local CurrentSection = nil

local Themes = {
	Dark = {Main=Color3.fromRGB(24,24,24),Container=Color3.fromRGB(35,35,35),Element=Color3.fromRGB(132,132,132),Tab=Color3.fromRGB(66,66,66),Text=Color3.fromRGB(255,255,255),Accent=Color3.fromRGB(0,170,255)},
	Ocean = {Main=Color3.fromRGB(18,33,43),Container=Color3.fromRGB(24,52,70),Element=Color3.fromRGB(40,90,120),Tab=Color3.fromRGB(30,70,90),Text=Color3.fromRGB(255,255,255),Accent=Color3.fromRGB(0,255,200)},
	Blood = {Main=Color3.fromRGB(30,0,0),Container=Color3.fromRGB(45,5,5),Element=Color3.fromRGB(120,20,20),Tab=Color3.fromRGB(80,10,10),Text=Color3.fromRGB(255,255,255),Accent=Color3.fromRGB(255,0,0)},
	Nature = {Main=Color3.fromRGB(20,35,20),Container=Color3.fromRGB(30,50,30),Element=Color3.fromRGB(60,100,60),Tab=Color3.fromRGB(45,80,45),Text=Color3.fromRGB(255,255,255),Accent=Color3.fromRGB(150,255,150)},
	Midnight = {Main=Color3.fromRGB(10,10,20),Container=Color3.fromRGB(15,15,30),Element=Color3.fromRGB(45,45,85),Tab=Color3.fromRGB(30,30,60),Text=Color3.fromRGB(255,255,255),Accent=Color3.fromRGB(140,100,255)}
}

local CurrentTheme = Themes.Dark

local function StyleElement(obj)
	obj.Size = UDim2.new(0, 260, 0, 40)
	obj.BackgroundColor3 = CurrentTheme.Element
	obj.TextColor3 = CurrentTheme.Text
	obj.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Bold)
	obj.TextSize = 16
	Instance.new("UICorner", obj).CornerRadius = UDim.new(0, 6)
	local s = Instance.new("UIStroke", obj)
	s.Thickness = 1.5
	s.Transparency = 0.6
end

function UI:UpdateTheme()
	if not UI._Main then return end
	UI._Main.BackgroundColor3 = CurrentTheme.Main
	UI._Container.BackgroundColor3 = CurrentTheme.Container
	for _, tab in ipairs(UI._Tabs:GetChildren()) do
		if tab:IsA("TextButton") then tab.BackgroundColor3 = CurrentTheme.Tab end
	end
end

function UI:Launch()
	local ScreenGui = Instance.new("ScreenGui", PlayerGui)
	ScreenGui.ResetOnSpawn = false
	
	local Main = Instance.new("Frame", ScreenGui)
	Main.Size = UDim2.new(0, 450, 0, 300)
	Main.Position = UDim2.new(0.5, -225, 0.5, -150)
	Main.BackgroundColor3 = CurrentTheme.Main
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

	local Tabs = Instance.new("ScrollingFrame", Main)
	Tabs.Size = UDim2.new(0, 130, 1, -20)
	Tabs.Position = UDim2.new(0, 10, 0, 10)
	Tabs.BackgroundTransparency = 1
	Tabs.ScrollBarThickness = 0
	Instance.new("UIListLayout", Tabs).Padding = UDim.new(0, 8)

	local Container = Instance.new("ScrollingFrame", Main)
	Container.Size = UDim2.new(1, -160, 1, -20)
	Container.Position = UDim2.new(0, 150, 0, 10)
	Container.BackgroundColor3 = CurrentTheme.Container
	Container.ScrollBarThickness = 2
	Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)
	local CL = Instance.new("UIListLayout", Container)
	CL.Padding = UDim.new(0, 8)
	CL.HorizontalAlignment = Enum.HorizontalAlignment.Center

	UI._Tabs = Tabs
	UI._Container = Container
	UI._Main = Main
	UI._Gui = ScreenGui
end

function UI:InsertSection(Text)
	local Tab = Instance.new("TextButton", UI._Tabs)
	Tab.Size = UDim2.new(1, -10, 0, 35)
	Tab.Text = Text
	Tab.BackgroundColor3 = CurrentTheme.Tab
	Tab.TextColor3 = CurrentTheme.Text
	Instance.new("UICorner", Tab)
	
	local Folder = Instance.new("Folder", UI._Gui)
	Sections[Text] = Folder
	
	Tab.MouseButton1Click:Connect(function()
		UI._Container:ClearAllChildren()
		local L = Instance.new("UIListLayout", UI._Container)
		L.Padding = UDim.new(0, 8)
		L.HorizontalAlignment = Enum.HorizontalAlignment.Center
		for _, v in ipairs(Folder:GetChildren()) do
			v.Parent = UI._Container
		end
	end)
	CurrentSection = Text
end

function UI:InsertButton(Text, Callback)
	local Button = Instance.new("TextButton")
	Button.Text = Text
	StyleElement(Button)
	Button.MouseButton1Click:Connect(function() if Callback then Callback() end end)
	Button.Parent = Sections[CurrentSection]
end

function UI:InsertLabel(Text)
	local Label = Instance.new("TextLabel")
	Label.Text = Text
	StyleElement(Label)
	Label.Parent = Sections[CurrentSection]
end

function UI:InsertToggle(Text, Callback)
	local Toggled = false
	local ToggleFrame = Instance.new("TextButton")
	ToggleFrame.Text = "  " .. Text
	ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
	StyleElement(ToggleFrame)

	local Track = Instance.new("Frame", ToggleFrame)
	Track.Size = UDim2.new(0, 40, 0, 20)
	Track.Position = UDim2.new(1, -50, 0.5, -10)
	Track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

	local Knob = Instance.new("Frame", Track)
	Knob.Size = UDim2.new(0, 16, 0, 16)
	Knob.Position = UDim2.new(0, 2, 0.5, -8)
	Knob.BackgroundColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

	ToggleFrame.MouseButton1Click:Connect(function()
		Toggled = not Toggled
		local targetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
		local targetColor = Toggled and CurrentTheme.Accent or Color3.fromRGB(50, 50, 50)
		
		TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
		TweenService:Create(Track, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundColor3 = targetColor}):Play()
		
		if Callback then Callback(Toggled) end
	end)
	ToggleFrame.Parent = Sections[CurrentSection]
end

function UI:InsertTheme(Text)
	local ThemeBtn = Instance.new("TextButton")
	ThemeBtn.Text = "Theme: " .. Text
	StyleElement(ThemeBtn)
	ThemeBtn.MouseButton1Click:Connect(function()
		if Themes[Text] then
			CurrentTheme = Themes[Text]
			UI:UpdateTheme()
			UI._Container:ClearAllChildren()
			local L = Instance.new("UIListLayout", UI._Container)
			L.Padding = UDim.new(0, 8)
			L.HorizontalAlignment = Enum.HorizontalAlignment.Center
		end
	end)
	ThemeBtn.Parent = Sections[CurrentSection]
end
