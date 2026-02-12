local InterfaceSuite = {}
InterfaceSuite.__index = InterfaceSuite

local TweenService = game:GetService("TweenService")
local LMG2L = {}

LMG2L["ScreenGui_1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
LMG2L["ScreenGui_1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling

LMG2L["Main Frame_2"] = Instance.new("Frame", LMG2L["ScreenGui_1"])
LMG2L["Main Frame_2"].BorderSizePixel = 0
LMG2L["Main Frame_2"].BackgroundColor3 = Color3.fromRGB(24, 24, 24)
LMG2L["Main Frame_2"].Size = UDim2.new(0, 404, 0, 252)
LMG2L["Main Frame_2"].Position = UDim2.new(0, 246, 0, 26)
LMG2L["Main Frame_2"].Name = "Main Frame"
Instance.new("UICorner", LMG2L["Main Frame_2"])
local strokeMain = Instance.new("UIStroke", LMG2L["Main Frame_2"])
strokeMain.Thickness = 3
strokeMain.Color = Color3.fromRGB(68, 68, 68)

LMG2L["Title_5"] = Instance.new("TextLabel", LMG2L["ScreenGui_1"])
LMG2L["Title_5"].TextWrapped = true
LMG2L["Title_5"].TextScaled = true
LMG2L["Title_5"].BackgroundTransparency = 1
LMG2L["Title_5"].TextColor3 = Color3.fromRGB(255, 255, 255)
LMG2L["Title_5"].Font = Enum.Font.ArialBold
LMG2L["Title_5"].Size = UDim2.new(0, 258, 0, 22)
LMG2L["Title_5"].Position = UDim2.new(0, 388, 0, 256)
LMG2L["Title_5"].Name = "Title"

LMG2L["ScrollingFrame_6"] = Instance.new("ScrollingFrame", LMG2L["ScreenGui_1"])
LMG2L["ScrollingFrame_6"].Active = true
LMG2L["ScrollingFrame_6"].BackgroundColor3 = Color3.fromRGB(83, 83, 83)
LMG2L["ScrollingFrame_6"].Size = UDim2.new(0, 130, 0, 166)
LMG2L["ScrollingFrame_6"].Position = UDim2.new(0, 250, 0, 30)
Instance.new("UICorner", LMG2L["ScrollingFrame_6"])
Instance.new("UIListLayout", LMG2L["ScrollingFrame_6"])

local function createButton(name, text, pos)
    local btn = Instance.new("TextButton", LMG2L["ScreenGui_1"])
    btn.Text = text
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = pos
    btn.Name = name
    Instance.new("UICorner", btn)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(69, 69, 69)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return btn
end

LMG2L["Destroy gui button_b"] = createButton("Destroy gui button", "×", UDim2.new(0, 610, 0, 26))
LMG2L["Minimize Button_1a"] = createButton("Minimize Button", "-", UDim2.new(0, 522, 0, 26))
LMG2L["Fullsize Button_1d"] = createButton("Fullsize Button", "□", UDim2.new(0, 566, 0, 26))

LMG2L["Container_e"] = Instance.new("Frame", LMG2L["ScreenGui_1"])
LMG2L["Container_e"].BorderSizePixel = 0
LMG2L["Container_e"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LMG2L["Container_e"].Size = UDim2.new(0, 256, 0, 176)
LMG2L["Container_e"].Position = UDim2.new(0, 388, 0, 74)
Instance.new("UICorner", LMG2L["Container_e"])
Instance.new("UIStroke", LMG2L["Container_e"]).Thickness = 2

LMG2L["Scrolling for Container_11"] = Instance.new("ScrollingFrame", LMG2L["Container_e"])
LMG2L["Scrolling for Container_11"].Active = true
LMG2L["Scrolling for Container_11"].BackgroundColor3 = Color3.fromRGB(84, 84, 84)
LMG2L["Scrolling for Container_11"].Size = UDim2.new(0, 248, 0, 168)
LMG2L["Scrolling for Container_11"].Position = UDim2.new(0, 4, 0, 4)
Instance.new("UICorner", LMG2L["Scrolling for Container_11"])
Instance.new("UIListLayout", LMG2L["Scrolling for Container_11"])

LMG2L["Player's Profile Picture_20"] = Instance.new("ImageLabel", LMG2L["ScreenGui_1"])
LMG2L["Player's Profile Picture_20"].BorderSizePixel = 0
LMG2L["Player's Profile Picture_20"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LMG2L["Player's Profile Picture_20"].Image = "rbxthumb://type=AvatarHeadShot&id="..game.Players.LocalPlayer.UserId.."&w=420&h=420"
LMG2L["Player's Profile Picture_20"].Size = UDim2.new(0, 72, 0, 72)
LMG2L["Player's Profile Picture_20"].Position = UDim2.new(0, 250, 0, 200)
Instance.new("UICorner", LMG2L["Player's Profile Picture_20"]).CornerRadius = UDim.new(0, 10)

function InterfaceSuite:CreateTab(name)
    local tabBtn = Instance.new("TextButton", LMG2L["ScrollingFrame_6"])
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.Size = UDim2.new(0, 116, 0, 44)
    tabBtn.Font = Enum.Font.Arial
    Instance.new("UICorner", tabBtn)
    return tabBtn
end

function InterfaceSuite:CreateButton(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(132, 132, 132)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Size = UDim2.new(0, 236, 0, 42)
    btn.Font = Enum.Font.Arial
    Instance.new("UICorner", btn)
    Instance.new("UIStroke", btn).Thickness = 1.6
    btn.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)})
        tween:Play()
        tween.Completed:Wait()
        local tweenBack = TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(132, 132, 132)})
        tweenBack:Play()
        callback()
    end)
    return btn
end

function InterfaceSuite:CreateLabel(name, parent)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Text = name
    lbl.BackgroundColor3 = Color3.fromRGB(132, 132, 132)
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Size = UDim2.new(0, 236, 0, 42)
    lbl.Font = Enum.Font.Arial
    Instance.new("UICorner", lbl)
    Instance.new("UIStroke", lbl).Thickness = 1.6
    return lbl
end

LMG2L["Minimize Button_1a"].MouseButton1Click:Connect(function()
    local goal = {Size = UDim2.new(0, 404, 0, 0)}
    if LMG2L["Main Frame_2"].Size.Y.Scale == 0 and LMG2L["Main Frame_2"].Size.Y.Offset == 0 then
        goal = {Size = UDim2.new(0, 404, 0, 252)}
    end
    TweenService:Create(LMG2L["Main Frame_2"], TweenInfo.new(0.25), goal):Play()
end)

LMG2L["Fullsize Button_1d"].MouseButton1Click:Connect(function()
    local frame = LMG2L["Main Frame_2"]
    local goal = {Size = UDim2.new(0, 800, 0, 600)}
    if frame.Size == UDim2.new(0, 800, 0, 600) then
        goal = {Size = UDim2.new(0, 404, 0, 252)}
    end
    TweenService:Create(frame, TweenInfo.new(0.25), goal):Play()
end)

LMG2L["Destroy gui button_b"].MouseButton1Click:Connect(function()
    TweenService:Create(LMG2L["ScreenGui_1"], TweenInfo.new(0.25), {GroupTransparency = 1}):Play()
    task.wait(0.25)
    LMG2L["ScreenGui_1"]:Destroy()
end)

InterfaceSuite.LMG2L = LMG2L
return InterfaceSuite
