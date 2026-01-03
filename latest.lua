local ZoskronUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local windowSize = isMobile and UDim2.new(0, 320, 0, 480) or UDim2.new(0, 650, 0, 500)
local fullscreenSize = UDim2.new(1, 0, 1, 0)

local Themes = {
    Dark = {Background = Color3.fromRGB(18,18,22), Secondary = Color3.fromRGB(28,28,35), Accent = Color3.fromRGB(0,170,255), AccentHover = Color3.fromRGB(0,190,255), AccentPressed = Color3.fromRGB(0,140,220), Text = Color3.fromRGB(240,240,240), TextSecondary = Color3.fromRGB(180,180,180), Border = Color3.fromRGB(50,50,60), Shadow = Color3.fromRGB(0,0,0)},
    Light = {Background = Color3.fromRGB(240,240,240), Secondary = Color3.fromRGB(220,220,220), Accent = Color3.fromRGB(0,122,255), AccentHover = Color3.fromRGB(0,140,255), AccentPressed = Color3.fromRGB(0,100,220), Text = Color3.fromRGB(30,30,30), TextSecondary = Color3.fromRGB(100,100,100), Border = Color3.fromRGB(200,200,200), Shadow = Color3.fromRGB(150,150,150)},
    Purple = {Background = Color3.fromRGB(30,20,40), Secondary = Color3.fromRGB(40,30,50), Accent = Color3.fromRGB(170,0,255), AccentHover = Color3.fromRGB(190,0,255), AccentPressed = Color3.fromRGB(140,0,220), Text = Color3.fromRGB(240,240,240), TextSecondary = Color3.fromRGB(180,180,180), Border = Color3.fromRGB(60,50,70), Shadow = Color3.fromRGB(0,0,0)},
    Ocean = {Background = Color3.fromRGB(0,50,80), Secondary = Color3.fromRGB(0,70,100), Accent = Color3.fromRGB(0,200,255), AccentHover = Color3.fromRGB(0,220,255), AccentPressed = Color3.fromRGB(0,170,220), Text = Color3.fromRGB(240,240,240), TextSecondary = Color3.fromRGB(180,180,180), Border = Color3.fromRGB(0,100,130), Shadow = Color3.fromRGB(0,0,0)},
    Sunset = {Background = Color3.fromRGB(100,30,20), Secondary = Color3.fromRGB(120,50,40), Accent = Color3.fromRGB(255,100,0), AccentHover = Color3.fromRGB(255,120,0), AccentPressed = Color3.fromRGB(220,80,0), Text = Color3.fromRGB(240,240,240), TextSecondary = Color3.fromRGB(180,180,180), Border = Color3.fromRGB(150,60,50), Shadow = Color3.fromRGB(0,0,0)},
    Neon = {Background = Color3.fromRGB(0,0,0), Secondary = Color3.fromRGB(20,20,20), Accent = Color3.fromRGB(0,255,0), AccentHover = Color3.fromRGB(50,255,50), AccentPressed = Color3.fromRGB(0,200,0), Text = Color3.fromRGB(255,255,255), TextSecondary = Color3.fromRGB(200,200,200), Border = Color3.fromRGB(50,50,50), Shadow = Color3.fromRGB(0,255,0)},
    Pastel = {Background = Color3.fromRGB(240,255,255), Secondary = Color3.fromRGB(220,240,255), Accent = Color3.fromRGB(173,216,230), AccentHover = Color3.fromRGB(193,236,250), AccentPressed = Color3.fromRGB(153,196,210), Text = Color3.fromRGB(50,50,50), TextSecondary = Color3.fromRGB(100,100,100), Border = Color3.fromRGB(200,220,235), Shadow = Color3.fromRGB(180,200,215)},
    Forest = {Background = Color3.fromRGB(20,50,20), Secondary = Color3.fromRGB(30,70,30), Accent = Color3.fromRGB(100,200,100), AccentHover = Color3.fromRGB(120,220,120), AccentPressed = Color3.fromRGB(80,180,80), Text = Color3.fromRGB(240,240,240), TextSecondary = Color3.fromRGB(180,180,180), Border = Color3.fromRGB(50,100,50), Shadow = Color3.fromRGB(0,0,0)},
    Cyber = {Background = Color3.fromRGB(10,10,20), Secondary = Color3.fromRGB(20,20,40), Accent = Color3.fromRGB(255,0,255), AccentHover = Color3.fromRGB(255,50,255), AccentPressed = Color3.fromRGB(200,0,200), Text = Color3.fromRGB(0,255,255), TextSecondary = Color3.fromRGB(100,255,255), Border = Color3.fromRGB(50,0,50), Shadow = Color3.fromRGB(255,0,255)},
    Retro = {Background = Color3.fromRGB(50,30,20), Secondary = Color3.fromRGB(70,50,40), Accent = Color3.fromRGB(200,150,100), AccentHover = Color3.fromRGB(220,170,120), AccentPressed = Color3.fromRGB(180,130,80), Text = Color3.fromRGB(240,240,240), TextSecondary = Color3.fromRGB(180,180,180), Border = Color3.fromRGB(100,80,70), Shadow = Color3.fromRGB(0,0,0)},
    Monochrome = {Background = Color3.fromRGB(30,30,30), Secondary = Color3.fromRGB(50,50,50), Accent = Color3.fromRGB(150,150,150), AccentHover = Color3.fromRGB(170,170,170), AccentPressed = Color3.fromRGB(130,130,130), Text = Color3.fromRGB(200,200,200), TextSecondary = Color3.fromRGB(150,150,150), Border = Color3.fromRGB(80,80,80), Shadow = Color3.fromRGB(0,0,0)}
}

local CurrentTheme = Themes.Dark

function ZoskronUI:SetCustomTheme(customTable)
    if typeof(customTable) == "table" then
        for key, value in pairs(customTable) do
            if CurrentTheme[key] ~= nil then
                CurrentTheme[key] = value
            end
        end
    end
end

local function tween(obj, props, time, style, direction)
    local info = TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function ZoskronUI:Notify(title, text, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.Position = UDim2.new(1, 20, 1, -100)
    notif.BackgroundColor3 = CurrentTheme.Secondary
    notif.Parent = PlayerGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -20, 0, 30)
    t.Position = UDim2.new(0, 10, 0, 5)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = CurrentTheme.Text
    t.Font = Enum.Font.GothamBold
    t.TextSize = 16
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = notif

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -20, 0, 40)
    d.Position = UDim2.new(0, 10, 0, 35)
    d.BackgroundTransparency = 1
    d.Text = text
    d.TextColor3 = CurrentTheme.TextSecondary
    d.Font = Enum.Font.Gotham
    d.TextSize = 14
    d.TextWrapped = true
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = notif

    tween(notif, {Position = UDim2.new(1, -320, 1, -100)}, 0.4)
    task.delay(duration or 4, function()
        tween(notif, {Position = UDim2.new(1, 20, 1, -100)}, 0.4)
        task.wait(0.4)
        notif:Destroy()
    end)
end

function ZoskronUI:CreateWindow(options)
    options = options or {}
    local title = options.Name or "ZoskronUI"
    local loadingTitle = options.LoadingTitle or title
    local loadingSubtitle = options.LoadingSubtitle or "Preparing..."

    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "ZoskronLoading"
    loadingGui.Parent = PlayerGui

    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 300, 0, 160)
    loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
    loadingFrame.BackgroundColor3 = CurrentTheme.Background
    loadingFrame.Parent = loadingGui

    local lcorner = Instance.new("UICorner")
    lcorner.CornerRadius = UDim.new(0, 8)
    lcorner.Parent = loadingFrame

    local ltitle = Instance.new("TextLabel")
    ltitle.Size = UDim2.new(1, 0, 0, 40)
    ltitle.BackgroundTransparency = 1
    ltitle.Text = loadingTitle
    ltitle.TextColor3 = CurrentTheme.Text
    ltitle.Font = Enum.Font.GothamBold
    ltitle.TextSize = 20
    ltitle.Parent = loadingFrame

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0, 50)
    status.BackgroundTransparency = 1
    status.Text = loadingSubtitle
    status.TextColor3 = CurrentTheme.TextSecondary
    status.Font = Enum.Font.Gotham
    status.TextSize = 16
    status.Parent = loadingFrame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -30, 0, 10)
    bar.Position = UDim2.new(0, 15, 0, 90)
    bar.BackgroundColor3 = CurrentTheme.Border
    bar.Parent = loadingFrame

    local bcorner = Instance.new("UICorner")
    bcorner.CornerRadius = UDim.new(0, 5)
    bcorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    fill.Parent = bar

    local fcorner = Instance.new("UICorner")
    fcorner.CornerRadius = UDim.new(0, 5)
    fcorner.Parent = fill

    local percent = Instance.new("TextLabel")
    percent.Size = UDim2.new(1, 0, 0, 20)
    percent.Position = UDim2.new(0, 0, 0, 120)
    percent.BackgroundTransparency = 1
    percent.Text = "0%"
    percent.TextColor3 = CurrentTheme.Text
    percent.Font = Enum.Font.Gotham
    percent.TextSize = 14
    percent.Parent = loadingFrame

    local stages = {"Script is Executed!", "Loading Each Stuffs...", "Script is Loaded!"}
    local percents = {0, 67, 100}

    for i, stage in ipairs(stages) do
        status.Text = stage
        tween(fill, {Size = UDim2.new(percents[i]/100, 0, 1, 0)}, 1.2)
        percent.Text = percents[i] .. "%"
        task.wait(1.5)
    end

    tween(loadingFrame, {BackgroundTransparency = 1}, 0.4)
    for _, child in ipairs(loadingFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.4)
        end
    end
    task.wait(0.4)
    loadingGui:Destroy()

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZoskronUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = windowSize
    mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    mainFrame.BackgroundColor3 = CurrentTheme.Background
    mainFrame.Parent = screenGui

    local mcorner = Instance.new("UICorner")
    mcorner.CornerRadius = UDim.new(0, 12)
    mcorner.Parent = mainFrame

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundColor3 = CurrentTheme.Shadow
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame

    local scorner = Instance.new("UICorner")
    scorner.CornerRadius = UDim.new(0, 14)
    scorner.Parent = shadow

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = CurrentTheme.Secondary
    titleBar.Parent = mainFrame

    local tbcorner = Instance.new("UICorner")
    tbcorner.CornerRadius = UDim.new(0, 12)
    tbcorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -180, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = CurrentTheme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.Parent = titleBar

    local ccorner = Instance.new("UICorner")
    ccorner.CornerRadius = UDim.new(0, 8)
    ccorner.Parent = closeBtn

    closeBtn.MouseEnter:Connect(function() tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(220,60,60)}) end)
    closeBtn.MouseLeave:Connect(function() tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255,80,80)}) end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(mainFrame, {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)}, 0.3)
        task.wait(0.3)
        screenGui:Destroy()
    end)

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
    minimizeBtn.Position = UDim2.new(1, -85, 0.5, -17.5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255,193,7)
    minimizeBtn.Text = "–"
    minimizeBtn.TextColor3 = Color3.new(1,1,1)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 24
    minimizeBtn.Parent = titleBar

    local mincorner = Instance.new("UICorner")
    mincorner.CornerRadius = UDim.new(0, 8)
    mincorner.Parent = minimizeBtn

    local fullscreenBtn = Instance.new("TextButton")
    fullscreenBtn.Size = UDim2.new(0, 35, 0, 35)
    fullscreenBtn.Position = UDim2.new(1, -125, 0.5, -17.5)
    fullscreenBtn.BackgroundColor3 = Color3.fromRGB(76,175,80)
    fullscreenBtn.Text = "□"
    fullscreenBtn.TextColor3 = Color3.new(1,1,1)
    fullscreenBtn.Font = Enum.Font.GothamBold
    fullscreenBtn.TextSize = 18
    fullscreenBtn.Parent = titleBar

    local fscorner = Instance.new("UICorner")
    fscorner.CornerRadius = UDim.new(0, 8)
    fscorner.Parent = fullscreenBtn

    local isMinimized = false
    local isFullscreen = false
    local originalSize = mainFrame.Size
    local originalPos = mainFrame.Position

    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            tween(mainFrame, {Size = UDim2.new(mainFrame.Size.X.Scale, mainFrame.Size.X.Offset, 0, 45)}, 0.3)
        else
            tween(mainFrame, {Size = originalSize}, 0.3)
        end
    end)

    fullscreenBtn.MouseButton1Click:Connect(function()
        isFullscreen = not isFullscreen
        if isFullscreen then
            originalSize = mainFrame.Size
            originalPos = mainFrame.Position
            tween(mainFrame, {Size = fullscreenSize, Position = UDim2.new(0,0,0,0)}, 0.3)
        else
            tween(mainFrame, {Size = originalSize, Position = originalPos}, 0.3)
        end
    end)

    makeDraggable(mainFrame, titleBar)

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -65)
    content.Position = UDim2.new(0, 10, 0, 55)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 6
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = mainFrame

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 10)
    list.Parent = content

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = content

    local window = {}

    function window:Button(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.BackgroundColor3 = CurrentTheme.Accent
        btn.Text = text
        btn.TextColor3 = CurrentTheme.Text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.Parent = content

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = CurrentTheme.AccentHover}) end)
        btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = CurrentTheme.Accent}) end)
        btn.MouseButton1Down:Connect(function() tween(btn, {BackgroundColor3 = CurrentTheme.AccentPressed}) end)
        btn.MouseButton1Up:Connect(function() tween(btn, {BackgroundColor3 = CurrentTheme.Accent}) end)
        btn.MouseButton1Click:Connect(callback or function() end)

        return btn
    end

    function window:Label(text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 30)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = CurrentTheme.Text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 15
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = content
        return lbl
    end

    function window:Toggle(text, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.BackgroundTransparency = 1
        frame.Parent = content

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -60, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = CurrentTheme.Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 15
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local toggle = Instance.new("Frame")
        toggle.Size = UDim2.new(0, 50, 0, 26)
        toggle.Position = UDim2.new(1, -55, 0.5, -13)
        toggle.BackgroundColor3 = CurrentTheme.Border
        toggle.Parent = frame

        local tcorner = Instance.new("UICorner")
        tcorner.CornerRadius = UDim.new(0, 13)
        tcorner.Parent = toggle

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = UDim2.new(0, 4, 0.5, -10)
        knob.BackgroundColor3 = CurrentTheme.Text
        knob.Parent = toggle

        local kcorner = Instance.new("UICorner")
        kcorner.CornerRadius = UDim.new(0, 10)
        kcorner.Parent = knob

        local state = default or false
        if state then
            toggle.BackgroundColor3 = CurrentTheme.Accent
            knob.Position = UDim2.new(1, -24, 0.5, -10)
        end

        toggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                state = not state
                tween(toggle, {BackgroundColor3 = state and CurrentTheme.Accent or CurrentTheme.Border})
                tween(knob, {Position = state and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)})
                if callback then callback(state) end
            end
        end)

        return frame
    end

    tween(mainFrame, {BackgroundTransparency = 0}, 0.4)

    return window
end

return ZoskronUI
