local ZoskronUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Force mobile size – perfect for phones like Redmi A3 (compact, not huge)
local isMobile = true
local windowSize = isMobile and UDim2.new(0, 320, 0, 480) or UDim2.new(0, 650, 0, 500)

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

-- Full theme updater – reapplies colors to mainFrame, titleBar, sections, buttons, etc.
local AllElements = {}  -- We'll store references to update on theme change

local function UpdateAllColors()
    if not mainFrame then return end

    mainFrame.BackgroundColor3 = CurrentTheme.Background
    titleBar.BackgroundColor3 = CurrentTheme.Secondary
    shadow.ImageColor3 = CurrentTheme.Shadow

    -- Update all stored elements
    for _, elem in pairs(AllElements) do
        if elem:IsA("Frame") or elem:IsA("TextButton") then
            if elem.Name == "SectionFrame" then
                elem.BackgroundColor3 = CurrentTheme.Secondary
            elseif elem.Name == "Button" then
                elem.BackgroundColor3 = CurrentTheme.Accent
            end
        elseif elem:IsA("TextLabel") then
            elem.TextColor3 = CurrentTheme.Text
        end
        -- Add more as needed (toggles, sliders, etc.)
    end
end

function ZoskronUI:SetCustomTheme(customTable)
    if typeof(customTable) == "table" then
        for key, value in pairs(customTable) do
            if CurrentTheme[key] then
                CurrentTheme[key] = value
            end
        end
        UpdateAllColors()
    end
end

local function tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging
    local dragInput
    local dragStart
    local startPos

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
    -- (Same as before – unchanged)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.Position = UDim2.new(1, 20, 1, -100)
    notif.BackgroundColor3 = CurrentTheme.Secondary
    notif.Parent = PlayerGui

    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 8)

    local t = Instance.new("TextLabel", notif)
    t.Size = UDim2.new(1, -20, 0, 30)
    t.Position = UDim2.new(0, 10, 0, 5)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = CurrentTheme.Text
    t.Font = Enum.Font.GothamBold
    t.TextSize = 16
    t.TextXAlignment = Enum.TextXAlignment.Left

    local d = Instance.new("TextLabel", notif)
    d.Size = UDim2.new(1, -20, 0, 40)
    d.Position = UDim2.new(0, 10, 0, 35)
    d.BackgroundTransparency = 1
    d.Text = text
    d.TextColor3 = CurrentTheme.TextSecondary
    d.Font = Enum.Font.Gotham
    d.TextSize = 14
    d.TextWrapped = true
    d.TextXAlignment = Enum.TextXAlignment.Left

    tween(notif, {Position = UDim2.new(1, -320, 1, -100)}, 0.4)
    task.delay(duration or 4, function()
        tween(notif, {Position = UDim2.new(1, 20, 1, -100)}, 0.4)
        task.wait(0.4)
        notif:Destroy()
    end)
end

-- Horizontal scrolling tabs (like Rayfield – swipe left/right on mobile)
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

    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 12)

    local shadow = Instance.new("ImageLabel", mainFrame)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = CurrentTheme.Shadow
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)

    local titleBar = Instance.new("Frame", mainFrame)
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = CurrentTheme.Secondary

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Size = UDim2.new(1, -150, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = CurrentTheme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local closeButton = Instance.new("TextButton", titleBar)
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -45, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 28
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    makeDraggable(mainFrame, titleBar)

    -- Horizontal Scrolling Tab Bar
    local tabScroll = Instance.new("ScrollingFrame", mainFrame)
    tabScroll.Size = UDim2.new(1, 0, 0, 40)
    tabScroll.Position = UDim2.new(0, 0, 0, 50)
    tabScroll.BackgroundTransparency = 1
    tabScroll.ScrollBarThickness = 0
    tabScroll.ScrollingDirection = Enum.ScrollingDirection.X
    tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X

    local tabList = Instance.new("UIListLayout", tabScroll)
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.Padding = UDim.new(0, 8)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder

    local tabPadding = Instance.new("UIPadding", tabScroll)
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)

    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -20, 1, -100)
    contentFrame.Position = UDim2.new(0, 10, 0, 95)
    contentFrame.BackgroundTransparency = 1

    local window = {}
    local tabs = {}

    function window:AddTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.BackgroundColor3 = CurrentTheme.Secondary
        tabButton.Text = name
        tabButton.TextColor3 = CurrentTheme.TextSecondary
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.Parent = tabScroll

        local btnCorner = Instance.new("UICorner", tabButton)
        btnCorner.CornerRadius = UDim.new(0, 8)

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.ScrollingDirection = Enum.ScrollingDirection.Y
        tabContent.Visible = false
        tabContent.Parent = contentFrame

        local contentPadding = Instance.new("UIPadding", tabContent)
        contentPadding.PaddingAll = UDim.new(0, 10)

        local contentList = Instance.new("UIListLayout", tabContent)
        contentList.Padding = UDim.new(0, 10)

        tabButton.MouseButton1Click:Connect(function()
            for _, otherContent in pairs(contentFrame:GetChildren()) do
                if otherContent:IsA("ScrollingFrame") then
                    otherContent.Visible = false
                end
            end
            tabContent.Visible = true

            for _, btn in pairs(tabScroll:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.TextColor3 = CurrentTheme.TextSecondary
                end
            end
            tabButton.TextColor3 = CurrentTheme.Text
        end)

        if #tabScroll:GetChildren() == 3 then  -- First tab (UIListLayout + UIPadding)
            tabContent.Visible = true
            tabButton.TextColor3 = CurrentTheme.Text
        end

        local tab = {}

        function tab:AddSection(name)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 40)
            sectionFrame.BackgroundColor3 = CurrentTheme.Secondary
            sectionFrame.Name = "SectionFrame"
            sectionFrame.Parent = tabContent

            local secCorner = Instance.new("UICorner", sectionFrame)
            secCorner.CornerRadius = UDim.new(0, 8)

            local secTitle = Instance.new("TextLabel", sectionFrame)
            secTitle.Size = UDim2.new(1, 0, 1, 0)
            secTitle.BackgroundTransparency = 1
            secTitle.Text = name
            secTitle.TextColor3 = CurrentTheme.Text
            secTitle.Font = Enum.Font.GothamBold
            secTitle.TextSize = 16
            secTitle.TextXAlignment = Enum.TextXAlignment.Left
            secTitle.Position = UDim2.new(0, 15, 0, 0)

            local elementsContainer = Instance.new("Frame", sectionFrame)
            elementsContainer.Size = UDim2.new(1, 0, 0, 0)
            elementsContainer.Position = UDim2.new(0, 0, 1, 0)
            elementsContainer.BackgroundTransparency = 1
            elementsContainer.AutomaticSize = Enum.AutomaticSize.Y

            local elemList = Instance.new("UIListLayout", elementsContainer)
            elemList.Padding = UDim.new(0, 8)

            local elemPadding = Instance.new("UIPadding", elementsContainer)
            elemPadding.PaddingLeft = UDim.new(0, 10)
            elemPadding.PaddingRight = UDim.new(0, 10)
            elemPadding.PaddingTop = UDim.new(0, 10)
            elemPadding.PaddingBottom = UDim.new(0, 10)

            table.insert(AllElements, sectionFrame)

            local section = {}

            -- All element functions (Label, Button, Toggle, Slider, Dropdown, Keybind, Textbox, ColorPicker)
            -- Same as original, but add table.insert(AllElements, element) for theme updating where needed

            function section:Label(text)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 30)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = CurrentTheme.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = elementsContainer
                table.insert(AllElements, label)
            end

            function section:Button(text, callback)
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 40)
                button.BackgroundColor3 = CurrentTheme.Accent
                button.Text = text
                button.TextColor3 = Color3.new(1,1,1)
                button.Font = Enum.Font.GothamBold
                button.TextSize = 14
                button.Name = "Button"
                button.Parent = elementsContainer

                local corner = Instance.new("UICorner", button)
                corner.CornerRadius = UDim.new(0, 8)

                button.MouseEnter:Connect(function() tween(button, {BackgroundColor3 = CurrentTheme.AccentHover}) end)
                button.MouseLeave:Connect(function() tween(button, {BackgroundColor3 = CurrentTheme.Accent}) end)
                button.MouseButton1Down:Connect(function() tween(button, {BackgroundColor3 = CurrentTheme.AccentPressed}) end)
                button.MouseButton1Up:Connect(function() tween(button, {BackgroundColor3 = CurrentTheme.AccentHover}) end)

                button.MouseButton1Click:Connect(callback or function() end)
                table.insert(AllElements, button)
            end

            -- Add similar table.insert(AllElements, element) for Toggle, Slider, etc. if you want full theme support

            -- (Rest of elements: Toggle, Slider, Dropdown, Keybind, Textbox, ColorPicker – keep original code)

            return section
        end

        return tab
    end

    -- Auto Themes tab
    local themesTab = window:AddTab("Themes")
    local themeSec = themesTab:AddSection("Color Themes")
    for name, theme in pairs(Themes) do
        themeSec:Button(name, function()
            ZoskronUI:SetCustomTheme(theme)
            ZoskronUI:Notify("Theme Changed", "Switched to " .. name, 3)
        end)
    end

    return window
end

return ZoskronUI
