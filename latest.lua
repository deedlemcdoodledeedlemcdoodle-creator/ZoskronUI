local ZoskronUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Force mobile window size (320x480) for your Redmi A3 – keeps it compact and perfect
-- Keeps UserInputService for smooth dragging and input handling
local isMobile = true  -- This overrides detection – always uses the small, mobile-friendly size
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

ZoskronUI.Themes = Themes

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
    local loadingSubtitle = options.LoadingSubtitle or "Loading..."

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZoskronUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = windowSize
    mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    mainFrame.BackgroundColor3 = CurrentTheme.Background
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = CurrentTheme.Shadow
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = CurrentTheme.Secondary
    titleBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -150, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = CurrentTheme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -45, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = CurrentTheme.Text
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 24
    closeButton.Parent = titleBar
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    makeDraggable(mainFrame, titleBar)

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tabContainer

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -100)
    contentFrame.Position = UDim2.new(0, 10, 0, 90)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    local window = {}

    function window:AddTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 120, 1, 0)
        tabButton.BackgroundColor3 = CurrentTheme.Secondary
        tabButton.Text = name
        tabButton.TextColor3 = CurrentTheme.TextSecondary
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.Parent = tabContainer

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.ScrollingDirection = Enum.ScrollingDirection.Y
        tabContent.Visible = false
        tabContent.Parent = contentFrame

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.Parent = tabContent

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 10)
        list.Parent = tabContent

        tabButton.MouseButton1Click:Connect(function()
            for _, other in pairs(contentFrame:GetChildren()) do
                if other:IsA("ScrollingFrame") then
                    other.Visible = false
                end
            end
            tabContent.Visible = true
            for _, btn in pairs(tabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.TextColor3 = CurrentTheme.TextSecondary
                end
            end
            tabButton.TextColor3 = CurrentTheme.Text
        end)

        if #tabContainer:GetChildren() == 1 then  -- First tab
            tabContent.Visible = true
            tabButton.TextColor3 = CurrentTheme.Text
        end

        local tab = {}

        function tab:AddSection(name)
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, 0, 0, 40)
            section.BackgroundColor3 = CurrentTheme.Secondary
            section.Parent = tabContent

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = section

            local secTitle = Instance.new("TextLabel")
            secTitle.Size = UDim2.new(1, 0, 1, 0)
            secTitle.BackgroundTransparency = 1
            secTitle.Text = name
            secTitle.TextColor3 = CurrentTheme.Text
            secTitle.Font = Enum.Font.GothamBold
            secTitle.TextSize = 16
            secTitle.TextXAlignment = Enum.TextXAlignment.Left
            secTitle.Position = UDim2.new(0, 15, 0, 0)
            secTitle.Parent = section

            local elementsFrame = Instance.new("Frame")
            elementsFrame.Size = UDim2.new(1, 0, 0, 0)
            elementsFrame.Position = UDim2.new(0, 0, 1, 0)
            elementsFrame.BackgroundTransparency = 1
            elementsFrame.AutomaticSize = Enum.AutomaticSize.Y
            elementsFrame.Parent = section

            local elemList = Instance.new("UIListLayout")
            elemList.Padding = UDim.new(0, 8)
            elemList.Parent = elementsFrame

            local elemPadding = Instance.new("UIPadding")
            elemPadding.PaddingLeft = UDim.new(0, 10)
            elemPadding.PaddingRight = UDim.new(0, 10)
            elemPadding.PaddingTop = UDim.new(0, 10)
            elemPadding.PaddingBottom = UDim.new(0, 10)
            elemPadding.Parent = elementsFrame

            local sectionObj = {}

            function sectionObj:Label(text)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 30)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = CurrentTheme.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = elementsFrame
            end

            function sectionObj:Button(text, callback)
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 40)
                button.BackgroundColor3 = CurrentTheme.Accent
                button.Text = text
                button.TextColor3 = Color3.new(1,1,1)
                button.Font = Enum.Font.GothamBold
                button.TextSize = 14
                button.Parent = elementsFrame

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = button

                button.MouseEnter:Connect(function()
                    tween(button, {BackgroundColor3 = CurrentTheme.AccentHover})
                end)
                button.MouseLeave:Connect(function()
                    tween(button, {BackgroundColor3 = CurrentTheme.Accent})
                end)
                button.MouseButton1Down:Connect(function()
                    tween(button, {BackgroundColor3 = CurrentTheme.AccentPressed})
                end)
                button.MouseButton1Up:Connect(function()
                    tween(button, {BackgroundColor3 = CurrentTheme.AccentHover})
                end)

                button.MouseButton1Click:Connect(callback or function() end)
            end

            function sectionObj:Toggle(text, default, callback)
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Size = UDim2.new(1, 0, 0, 40)
                toggleFrame.BackgroundTransparency = 1
                toggleFrame.Parent = elementsFrame

                local toggleText = Instance.new("TextLabel")
                toggleText.Size = UDim2.new(1, -60, 1, 0)
                toggleText.BackgroundTransparency = 1
                toggleText.Text = text
                toggleText.TextColor3 = CurrentTheme.Text
                toggleText.Font = Enum.Font.Gotham
                toggleText.TextSize = 14
                toggleText.TextXAlignment = Enum.TextXAlignment.Left
                toggleText.Parent = toggleFrame

                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 50, 0, 25)
                toggleBtn.Position = UDim2.new(1, -55, 0.5, -12.5)
                toggleBtn.BackgroundColor3 = default and CurrentTheme.Accent or CurrentTheme.Secondary
                toggleBtn.Text = ""
                toggleBtn.Parent = toggleFrame

                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 12)
                toggleCorner.Parent = toggleBtn

                local state = default or false

                toggleBtn.MouseButton1Click:Connect(function()
                    state = not state
                    tween(toggleBtn, {BackgroundColor3 = state and CurrentTheme.Accent or CurrentTheme.Secondary})
                    if callback then callback(state) end
                end)
            end

            function sectionObj:Slider(text, min, max, default, callback)
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, 0, 0, 60)
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Parent = elementsFrame

                local sliderText = Instance.new("TextLabel")
                sliderText.Size = UDim2.new(1, 0, 0, 20)
                sliderText.BackgroundTransparency = 1
                sliderText.Text = text
                sliderText.TextColor3 = CurrentTheme.Text
                sliderText.Font = Enum.Font.Gotham
                sliderText.TextSize = 14
                sliderText.TextXAlignment = Enum.TextXAlignment.Left
                sliderText.Parent = sliderFrame

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 50, 0, 20)
                valueLabel.Position = UDim2.new(1, -60, 0, 0)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(default or min)
                valueLabel.TextColor3 = CurrentTheme.Text
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextSize = 14
                valueLabel.Parent = sliderFrame

                local sliderBar = Instance.new("Frame")
                sliderBar.Size = UDim2.new(1, 0, 0, 10)
                sliderBar.Position = UDim2.new(0, 0, 0, 30)
                sliderBar.BackgroundColor3 = CurrentTheme.Secondary
                sliderBar.Parent = sliderFrame

                local sliderFill = Instance.new("Frame")
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderFill.BackgroundColor3 = CurrentTheme.Accent
                sliderFill.Parent = sliderBar

                local sliderKnob = Instance.new("Frame")
                sliderKnob.Size = UDim2.new(0, 20, 0, 20)
                sliderKnob.Position = UDim2.new((default - min) / (max - min), -10, 0, -5)
                sliderKnob.BackgroundColor3 = CurrentTheme.Accent
                sliderKnob.Parent = sliderBar

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = sliderKnob

                local corners = {Instance.new("UICorner"), Instance.new("UICorner")}
                corners[1].CornerRadius = UDim.new(0, 5)
                corners[1].Parent = sliderBar
                corners[2].CornerRadius = UDim.new(0, 5)
                corners[2].Parent = sliderFill

                local dragging = false

                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                        local value = math.floor(min + (max - min) * relativeX)
                        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                        sliderKnob.Position = UDim2.new(relativeX, -10, 0, -5)
                        valueLabel.Text = tostring(value)
                        if callback then callback(value) end
                    end
                end)

                if callback then callback(default) end
            end

            function sectionObj:Dropdown(text, options, defaultIndex, callback)
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
                dropdownFrame.BackgroundTransparency = 1
                dropdownFrame.Parent = elementsFrame

                local dropdownText = Instance.new("TextLabel")
                dropdownText.Size = UDim2.new(1, -40, 1, 0)
                dropdownText.BackgroundTransparency = 1
                dropdownText.Text = text
                dropdownText.TextColor3 = CurrentTheme.Text
                dropdownText.Font = Enum.Font.Gotham
                dropdownText.TextSize = 14
                dropdownText.TextXAlignment = Enum.TextXAlignment.Left
                dropdownText.Parent = dropdownFrame

                local dropdownBtn = Instance.new("TextButton")
                dropdownBtn.Size = UDim2.new(0, 30, 0, 30)
                dropdownBtn.Position = UDim2.new(1, -35, 0, 5)
                dropdownBtn.BackgroundColor3 = CurrentTheme.Secondary
                dropdownBtn.Text = "▼"
                dropdownBtn.TextColor3 = CurrentTheme.Text
                dropdownBtn.Font = Enum.Font.GothamBold
                dropdownBtn.Parent = dropdownFrame

                local current = options[defaultIndex or 1]

                local listFrame = Instance.new("Frame")
                listFrame.Size = UDim2.new(1, 0, 0, #options * 35)
                listFrame.Position = UDim2.new(0, 0, 1, 5)
                listFrame.BackgroundColor3 = CurrentTheme.Secondary
                listFrame.Visible = false
                listFrame.Parent = dropdownFrame

                local listCorner = Instance.new("UICorner")
                listCorner.CornerRadius = UDim.new(0, 8)
                listCorner.Parent = listFrame

                for i, opt in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1, 0, 0, 35)
                    optBtn.Position = UDim2.new(0, 0, 0, (i-1)*35)
                    optBtn.BackgroundTransparency = i % 2 == 0 and 0.1 or 0
                    optBtn.Text = opt
                    optBtn.TextColor3 = CurrentTheme.Text
                    optBtn.Font = Enum.Font.Gotham
                    optBtn.Parent = listFrame

                    optBtn.MouseButton1Click:Connect(function()
                        current = opt
                        dropdownBtn.Text = "▼"
                        listFrame.Visible = false
                        if callback then callback(opt) end
                    end)
                end

                dropdownBtn.MouseButton1Click:Connect(function()
                    listFrame.Visible = not listFrame.Visible
                    dropdownBtn.Text = listFrame.Visible and "▲" or "▼"
                end)

                if callback then callback(current) end
            end

            function sectionObj:Keybind(text, defaultKey, callback)
                local keybindFrame = Instance.new("Frame")
                keybindFrame.Size = UDim2.new(1, 0, 0, 40)
                keybindFrame.BackgroundTransparency = 1
                keybindFrame.Parent = elementsFrame

                local keybindText = Instance.new("TextLabel")
                keybindText.Size = UDim2.new(1, -80, 1, 0)
                keybindText.BackgroundTransparency = 1
                keybindText.Text = text
                keybindText.TextColor3 = CurrentTheme.Text
                keybindText.Font = Enum.Font.Gotham
                keybindText.TextSize = 14
                keybindText.TextXAlignment = Enum.TextXAlignment.Left
                keybindText.Parent = keybindFrame

                local keybindBtn = Instance.new("TextButton")
                keybindBtn.Size = UDim2.new(0, 70, 0, 30)
                keybindBtn.Position = UDim2.new(1, -75, 0, 5)
                keybindBtn.BackgroundColor3 = CurrentTheme.Secondary
                keybindBtn.Text = defaultKey and defaultKey.Name or "None"
                keybindBtn.TextColor3 = CurrentTheme.Text
                keybindBtn.Font = Enum.Font.Gotham
                keybindBtn.Parent = keybindFrame

                local binding = false

                keybindBtn.MouseButton1Click:Connect(function()
                    keybindBtn.Text = "..."
                    binding = true
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if binding and input.KeyCode ~= Enum.KeyCode.Unknown then
                        keybindBtn.Text = input.KeyCode.Name
                        binding = false
                        if callback then callback(input.KeyCode) end
                    end
                end)
            end

            function sectionObj:Textbox(text, placeholder, callback)
                local textboxFrame = Instance.new("Frame")
                textboxFrame.Size = UDim2.new(1, 0, 0, 40)
                textboxFrame.BackgroundTransparency = 1
                textboxFrame.Parent = elementsFrame

                local textboxLabel = Instance.new("TextLabel")
                textboxLabel.Size = UDim2.new(1, 0, 0, 20)
                textboxLabel.BackgroundTransparency = 1
                textboxLabel.Text = text
                textboxLabel.TextColor3 = CurrentTheme.Text
                textboxLabel.Font = Enum.Font.Gotham
                textboxLabel.TextSize = 14
                textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                textboxLabel.Parent = textboxFrame

                local textbox = Instance.new("TextBox")
                textbox.Size = UDim2.new(1, 0, 0, 30)
                textbox.Position = UDim2.new(0, 0, 0, 20)
                textbox.BackgroundColor3 = CurrentTheme.Secondary
                textbox.PlaceholderText = placeholder
                textbox.Text = ""
                textbox.TextColor3 = CurrentTheme.Text
                textbox.Font = Enum.Font.Gotham
                textbox.Parent = textboxFrame

                local tbCorner = Instance.new("UICorner")
                tbCorner.CornerRadius = UDim.new(0, 8)
                tbCorner.Parent = textbox

                textbox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and callback then
                        callback(textbox.Text)
                    end
                end)
            end

            function sectionObj:ColorPicker(text, defaultColor, callback)
                local pickerFrame = Instance.new("Frame")
                pickerFrame.Size = UDim2.new(1, 0, 0, 40)
                pickerFrame.BackgroundTransparency = 1
                pickerFrame.Parent = elementsFrame

                local pickerText = Instance.new("TextLabel")
                pickerText.Size = UDim2.new(1, -60, 1, 0)
                pickerText.BackgroundTransparency = 1
                pickerText.Text = text
                pickerText.TextColor3 = CurrentTheme.Text
                pickerText.Font = Enum.Font.Gotham
                pickerText.TextSize = 14
                pickerText.TextXAlignment = Enum.TextXAlignment.Left
                pickerText.Parent = pickerFrame

                local colorBtn = Instance.new("TextButton")
                colorBtn.Size = UDim2.new(0, 50, 0, 30)
                colorBtn.Position = UDim2.new(1, -55, 0, 5)
                colorBtn.BackgroundColor3 = defaultColor or Color3.fromRGB(255,255,255)
                colorBtn.Text = ""
                colorBtn.Parent = pickerFrame

                local colorCorner = Instance.new("UICorner")
                colorCorner.CornerRadius = UDim.new(0, 8)
                colorCorner.Parent = colorBtn

                colorBtn.MouseButton1Click:Connect(function()
                    -- Simple color picker (you can expand this)
                    local hue = math.random()
                    local color = Color3.fromHSV(hue, 1, 1)
                    colorBtn.BackgroundColor3 = color
                    if callback then callback(color) end
                end)

                if callback then callback(defaultColor) end
            end

            return sectionObj
        end

        return tab
    end

    -- Auto-add Themes tab (optional, but common)
    local themesTab = window:AddTab("Themes")
    local themesSection = themesTab:AddSection("Color Themes")

    for name, theme in pairs(Themes) do
        themesSection:Button(name, function()
            ZoskronUI:SetCustomTheme(theme)
            ZoskronUI:Notify("Theme Applied", "Switched to " .. name, 3)
            -- Reapply theme to existing elements would require more code, but basic works
        end)
    end

    return window
end

return ZoskronUI
