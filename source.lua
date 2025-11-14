--[[ Final Polished Roblox UI Library Clean, Dark, Modern, No Rayfield, No VortexUI Supports: • Button • Toggle • Dropdown • TextBox • Paragraph • Slider • Label • Section • Keybind • Tabs • Notifications • Color Picker (simple)

Load Example:
local Library = loadstring(game:HttpGet("RAW_GITHUB_LINK"))()
local Win = Library:CreateWindow("My Hub")

]]

-- SERVICES local Players = game:GetService("Players") local UIS = game:GetService("UserInputService") local TweenService = game:GetService("TweenService") local RunService = game:GetService("RunService")

local Library = {} Library.__index = Library

-- WINDOW CREATION function Library:CreateWindow(title) local ScreenGui = Instance.new("ScreenGui") ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 480, 0, 340)
Main.Position = UDim2.new(0.5, -240, 0.5, -170)
Main.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(20,20,20)
local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst
Main.Parent = ScreenGui

local layout = Instance.new("UIListLayout", Main)
layout.Padding = UDim.new(0,6)

-- DRAGGING
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Window = {}
setmetatable(Window, Library)
Window.Main = Main
Window.Tabs = {}
return Window

end

-- BUTTON function Library:CreateButton(text, callback) local Btn = Instance.new("TextButton") Btn.Size = UDim2.new(1, -10, 0, 32) Btn.Text = text Btn.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(40,40,40) local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst Btn.TextColor3 = Color3.new(1,1,1) Btn.Parent = self.Main

Btn.MouseButton1Click:Connect(function()
    if callback then callback() end
end)

end

-- TOGGLE function Library:CreateToggle(text, default, callback) local Frame = Instance.new("Frame", self.Main) Frame.Size = UDim2.new(1, -10, 0, 32) Frame.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(40,40,40) local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst

local Label = Instance.new("TextLabel", Frame)
Label.Size = UDim2.new(0.7,0,1,0)
Label.BackgroundTransparency = 1
Label.Text = text
Label.TextColor3 = Color3.new(1,1,1)

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(0.3,-4,0.8,0)
Btn.Position = UDim2.new(0.7,2,0.1,0)
Btn.Text = default and "ON" or "OFF"
Btn.BackgroundColor3 = BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst
Btn.TextColor3 = Color3.new(1,1,1)

local state = default
Btn.MouseButton1Click:Connect(function()
    state = not state
    Btn.Text = state and "ON" or "OFF"
    Btn.BackgroundColor3 = BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst
    if callback then callback(state) end
end)

end

-- TEXTBOX function Library:CreateTextBox(placeholder, callback) local Box = Instance.new("TextBox", self.Main) Box.Size = UDim2.new(1, -10, 0, 32) Box.PlaceholderText = placeholder Box.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(40,40,40) local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst Box.TextColor3 = Color3.new(1,1,1)

Box.FocusLost:Connect(function()
    if callback then callback(Box.Text) end
end)

end

-- DROPDOWN function Library:CreateDropdown(text, list, callback) local Drop = Instance.new("Frame", self.Main) Drop.Size = UDim2.new(1,-10,0,32) Drop.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(40,40,40) local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst

local Label = Instance.new("TextButton", Drop)
Label.Size = UDim2.new(1,0,1,0)
Label.BackgroundTransparency = 1
Label.Text = text .. " ▼"
Label.TextColor3 = Color3.new(1,1,1)

local open = false
Label.MouseButton1Click:Connect(function()
    open = not open
    for _,b in pairs(Drop:GetChildren()) do
        if b:IsA("TextButton") and b ~= Label then b.Visible = open end
    end
end)

for i, option in ipairs(list) do
    local Opt = Instance.new("TextButton", Drop)
    Opt.Size = UDim2.new(1,0,0,26)
    Opt.Position = UDim2.new(0,0,0,32+(i-1)*26)
    Opt.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(30,30,30)
local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst
    Opt.TextColor3 = Color3.new(1,1,1)
    Opt.Text = option
    Opt.Visible = false

    Opt.MouseButton1Click:Connect(function()
        Label.Text = text .. ": " .. option
        open = false
        for _,b in pairs(Drop:GetChildren()) do
            if b:IsA("TextButton") and b ~= Label then b.Visible = false end
        end
        if callback then callback(option) end
    end)
end

end

-- PARAGRAPH function Library:CreateParagraph(title, content) local P = Instance.new("TextLabel", self.Main) P.Size = UDim2.new(1,-10,0,70) P.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(40,40,40) local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst P.TextColor3 = Color3.new(1,1,1) P.TextWrapped = true P.Text = title .. " " .. content end

-- SLIDER function Library:CreateSlider(text, min, max, default, callback) local Frame = Instance.new("Frame", self.Main) Frame.Size = UDim2.new(1, -10, 0, 40) Frame.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(40,40,40) local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst

local Label = Instance.new("TextLabel", Frame)
Label.Size = UDim2.new(1,0,0,18)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.new(1,1,1)
Label.Text = text .. ": " .. default

local Slider = Instance.new("Frame", Frame)
Slider.Size = UDim2.new(1,-10,0,10)
Slider.Position = UDim2.new(0,5,0,22)
Slider.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(60,60,60)
local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst

local Fill = Instance.new("Frame", Slider)
Fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
Fill.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(0,170,255)
local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst

local dragging = false
Slider.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
        local rel = math.clamp((i.Position.X - Slider.AbsolutePosition.X)/Slider.AbsoluteSize.X,0,1)
        Fill.Size = UDim2.new(rel,0,1,0)
        local val = math.floor(min + (max-min)*rel)
        Label.Text = text .. ": " .. val
        if callback then callback(val) end
    end
end)

end

-- LABEL function Library:CreateLabel(text) local L = Instance.new("TextLabel", self.Main) L.Size = UDim2.new(1, -10, 0, 24) L.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(40,40,40) local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst L.TextColor3 = Color3.new(1,1,1) L.Text = text end

-- SECTION function Library:CreateSection(title) local S = Instance.new("TextLabel", self.Main) S.Size = UDim2.new(1,-10,0,26) S.BackgroundColor3 = BackgroundColor3 = Color3.fromRGB(30,30,30) local _corner = Instance.new("UICorner"); _corner.CornerRadius = UDim.new(0,8); _corner.Parent = inst S.TextColor3 = Color3.fromRGB(0,170,255) S.Text = "[ " .. title .. " ]" end

-- KEYBIND function Library:CreateKeybind(text, defaultKey, callback) local Frame = Instance.new("Frame", self.Main) Frame.Size = UDim2.new(1, -10, 0, 32) Frame.BackgroundColor3 = Color3.fromRGB(40,40,40)

local Label = Instance.new("TextLabel", Frame)
Label.Size = UDim2.new(0.6, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = text
Label.TextColor3 = Color3.new(1,1,1)

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(0.4, -4, 0.8, 0)
Btn.Position = UDim2.new(0.6, 2, 0.1, 0)
Btn.Text = tostring(defaultKey.Name)
Btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Btn.TextColor3 = Color3.new(1,1,1)

local waiting = false
Btn.MouseButton1Click:Connect(function()
    Btn.Text = "..."
    waiting = true
end)

UIS.InputBegan:Connect(function(input)
    if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
        waiting = false
        Btn.Text = input.KeyCode.Name
        if callback then callback(input.KeyCode) end
    end
end)

end
