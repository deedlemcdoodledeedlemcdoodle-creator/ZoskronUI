--[[

╭━━━━╮╱╱╱╱╱╭╮╭━╮
╰━━╮━┃╱╱╱╱╱┃┃┃╭╯
╱╱╭╯╭╋━━┳━━┫╰╯╯╱
╱╭╯╭╯┃╭╮┃━━┫╭╮┃╱
╭╯━╰━┫╰╯┣━━┃┃┃╰╮
╰━━━━┻━━┻━━┻╯╰━╯

Made by: SpectravaxISBACK on ScriptBlox
Enjoy!

]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ZosK = {}
local Windows = {}

-- Configs for Color Themes
local ColorThemes = {
    Dark = {
        PrimaryColor = Color3.fromRGB(30, 30, 30),
        SecondaryColor = Color3.fromRGB(20, 20, 20),
        AccentColor = Color3.fromRGB(0, 122, 255),
        TextColor = Color3.new(1, 1, 1)
    },
    Light = {
        PrimaryColor = Color3.fromRGB(240, 240, 240),
        SecondaryColor = Color3.fromRGB(220, 220, 220),
        AccentColor = Color3.fromRGB(0, 122, 255),
        TextColor = Color3.new(0, 0, 0)
    },
    Neon = {
        PrimaryColor = Color3.fromRGB(0, 0, 0),
        SecondaryColor = Color3.fromRGB(10, 10, 10),
        AccentColor = Color3.fromRGB(255, 0, 255),
        TextColor = Color3.new(1, 1, 1)
    },
    -- Add more themes as needed
}

local DefaultOptions = {
    Title = "ZosK Window",
    Transparency = 0,
    Theme = "Dark",
    CornerRadius = 8
}

-- Utility Functions
local function MakeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function Tween(object, properties, time)
    local tweenInfo = TweenInfo.new(time or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function CreateRoundedImage(parent, size, position, imageUrl, cornerRadius)
    local image = Instance.new("ImageLabel")
    image.Size = size
    image.Position = position
    image.BackgroundTransparency = 1
    image.Image = imageUrl
    image.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = image

    return image
end

-- Main Window Creation
function ZosK:CreateWindow(options)
    options = options or {}
    for key, value in pairs(DefaultOptions) do
        if options[key] == nil then
            options[key] = value
        end
    end
    local currentTheme = ColorThemes[options.Theme] or ColorThemes.Dark
    local primaryColor = currentTheme.PrimaryColor
    local secondaryColor = currentTheme.SecondaryColor
    local accentColor = currentTheme.AccentColor
    local textColor = currentTheme.TextColor

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZosK_" .. options.Title:gsub("%s+", "_")
    screenGui.Parent = PlayerGui
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = primaryColor
    mainFrame.BackgroundTransparency = options.Transparency
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, options.CornerRadius)
    uiCorner.Parent = mainFrame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = secondaryColor
    uiStroke.Transparency = 0.5
    uiStroke.Parent = mainFrame

    MakeDraggable(mainFrame)

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = secondaryColor
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, options.CornerRadius)
    titleBarCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -90, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = options.Title
    titleLabel.TextColor3 = textColor
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundColor3 = secondaryColor
    closeBtn.Text = "X"
    closeBtn.TextColor3 = textColor
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, options.CornerRadius)
    closeBtnCorner.Parent = closeBtn

    -- Maximize Button
    local maxBtn = Instance.new("TextButton")
    maxBtn.Size = UDim2.new(0, 30, 0, 30)
    maxBtn.Position = UDim2.new(1, -60, 0, 0)
    maxBtn.BackgroundColor3 = secondaryColor
    maxBtn.Text = "□"
    maxBtn.TextColor3 = textColor
    maxBtn.TextSize = 14
    maxBtn.Font = Enum.Font.Gotham
    maxBtn.BorderSizePixel = 0
    maxBtn.Parent = titleBar

    local originalSize = mainFrame.Size
    local originalPos = mainFrame.Position
    local isMaximized = false
    maxBtn.MouseButton1Click:Connect(function()
        if isMaximized then
            mainFrame.Size = originalSize
            mainFrame.Position = originalPos
            isMaximized = false
        else
            originalSize = mainFrame.Size
            originalPos = mainFrame.Position
            mainFrame.Size = UDim2.new(1, 0, 1, 0)
            mainFrame.Position = UDim2.new(0, 0, 0, 0)
            isMaximized = true
        end
    end)

    local maxBtnCorner = Instance.new("UICorner")
    maxBtnCorner.CornerRadius = UDim.new(0, options.CornerRadius)
    maxBtnCorner.Parent = maxBtn

    -- Toggle (Visibility) Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 30, 0, 30)
    toggleBtn.Position = UDim2.new(1, -90, 0, 0)
    toggleBtn.BackgroundColor3 = secondaryColor
    toggleBtn.Text = "-"
    toggleBtn.TextColor3 = textColor
    toggleBtn.TextSize = 14
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = titleBar
    toggleBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(0, options.CornerRadius)
    toggleBtnCorner.Parent = toggleBtn

    -- Tab Bar
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.Position = UDim2.new(0, 0, 0, 30)
    tabBar.BackgroundColor3 = secondaryColor
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = tabBar

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 5)
    tabPadding.Parent = tabBar

    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, 0, 1, -60)
    contentContainer.Position = UDim2.new(0, 0, 0, 60)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame

    local currentTab = nil
    local tabs = {}

    local window = {options = options, mainFrame = mainFrame, titleBar = titleBar, tabBar = tabBar, titleLabel = titleLabel, closeBtn = closeBtn, maxBtn = maxBtn, toggleBtn = toggleBtn, uiStroke = uiStroke}

    function window:ApplyTheme(themeName)
        local theme = ColorThemes[themeName] or ColorThemes.Dark
        primaryColor = theme.PrimaryColor
        secondaryColor = theme.SecondaryColor
        accentColor = theme.AccentColor
        textColor = theme.TextColor

        mainFrame.BackgroundColor3 = primaryColor
        titleBar.BackgroundColor3 = secondaryColor
        tabBar.BackgroundColor3 = secondaryColor
        uiStroke.Color = secondaryColor
        titleLabel.TextColor3 = textColor
        closeBtn.TextColor3 = textColor
        closeBtn.BackgroundColor3 = secondaryColor
        maxBtn.TextColor3 = textColor
        maxBtn.BackgroundColor3 = secondaryColor
        toggleBtn.TextColor3 = textColor
        toggleBtn.BackgroundColor3 = secondaryColor
        -- Note: To fully update, you'd need to loop through all child elements and update their colors accordingly. For simplicity, restart the UI or implement a recursive update.
    end

    function window:CreateTab(tabName)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.BackgroundColor3 = secondaryColor
        tabButton.Text = tabName
        tabButton.TextColor3 = textColor
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.Gotham
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabBar

        local tabBtnCorner = Instance.new("UICorner")
        tabBtnCorner.CornerRadius = UDim.new(0, options.CornerRadius / 2)
        tabBtnCorner.Parent = tabButton

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = accentColor
        tabContent.Visible = false
        tabContent.Parent = contentContainer

        local contentList = Instance.new("UIListLayout")
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 5)
        contentList.Parent = tabContent

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 5)
        contentPadding.PaddingLeft = UDim.new(0, 5)
        contentPadding.PaddingRight = UDim.new(0, 5)
        contentPadding.Parent = tabContent

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Content.Visible = false
                Tween(currentTab.Button, {BackgroundColor3 = secondaryColor}, 0.2)
            end
            tabContent.Visible = true
            Tween(tabButton, {BackgroundColor3 = accentColor}, 0.2)
            currentTab = {Button = tabButton, Content = tabContent}
        end)

        table.insert(tabs, {Button = tabButton, Content = tabContent})

        if #tabs == 1 then
            tabButton.MouseButton1Click:Fire()
        end

        local tab = {}

        function tab:AddSection(sectionName)
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, 0, 0, 30)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = sectionName
            sectionLabel.TextColor3 = accentColor
            sectionLabel.TextSize = 14
            sectionLabel.Font = Enum.Font.GothamSemibold
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = tabContent

            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y)
        end

        function tab:AddButton(options)
            options = options or {}
            local buttonName = options.Name or "Button"
            local callback = options.Callback or function() end

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 30)
            button.BackgroundColor3 = secondaryColor
            button.Text = buttonName
            button.TextColor3 = textColor
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.BorderSizePixel = 0
            button.Parent = tabContent
            button.MouseButton1Click:Connect(callback)

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, DefaultOptions.CornerRadius / 2)
            btnCorner.Parent = button

            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y)
            return button
        end

        function tab:AddToggle(options)
            options = options or {}
            local toggleName = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end

            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 30)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent

            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(1, -60, 1, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = toggleName
            toggleLabel.TextColor3 = textColor
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame

            local toggleBtn = Instance.new("Frame")
            toggleBtn.Size = UDim2.new(0, 50, 0, 24)
            toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
            toggleBtn.BackgroundColor3 = secondaryColor
            toggleBtn.Parent = toggleFrame

            local toggleBtnCorner = Instance.new("UICorner")
            toggleBtnCorner.CornerRadius = UDim.new(0, 12)
            toggleBtnCorner.Parent = toggleBtn

            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 20, 0, 20)
            toggleCircle.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            toggleCircle.BackgroundColor3 = default and accentColor or Color3.fromRGB(150, 150, 150)
            toggleCircle.Parent = toggleBtn

            local toggleCircleCorner = Instance.new("UICorner")
            toggleCircleCorner.CornerRadius = UDim.new(0, 10)
            toggleCircleCorner.Parent = toggleCircle

            local state = default
            local toggleInput = Instance.new("TextButton")
            toggleInput.Size = UDim2.new(1, 0, 1, 0)
            toggleInput.BackgroundTransparency = 1
            toggleInput.Text = ""
            toggleInput.Parent = toggleBtn
            toggleInput.MouseButton1Click:Connect(function()
                state = not state
                Tween(toggleCircle, {Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2)
                toggleCircle.BackgroundColor3 = state and accentColor or Color3.fromRGB(150, 150, 150)
                callback(state)
            end)

            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y)
            return {Frame = toggleFrame, Set = function(newState) 
                state = newState
                toggleCircle.Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                toggleCircle.BackgroundColor3 = state and accentColor or Color3.fromRGB(150, 150, 150)
            end}
        end

        function tab:AddSlider(options)
            options = options or {}
            local sliderName = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end

            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 40)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContent

            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Size = UDim2.new(1, -50, 0, 20)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = sliderName
            sliderLabel.TextColor3 = textColor
            sliderLabel.TextSize = 14
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(1, -50, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = textColor
            valueLabel.TextSize = 14
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = sliderFrame

            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, 0, 0, 6)
            sliderBar.Position = UDim2.new(0, 0, 1, -10)
            sliderBar.BackgroundColor3 = secondaryColor
            sliderBar.Parent = sliderFrame

            local sliderBarCorner = Instance.new("UICorner")
            sliderBarCorner.CornerRadius = UDim.new(0, 3)
            sliderBarCorner.Parent = sliderBar

            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = accentColor
            sliderFill.Parent = sliderBar

            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(0, 3)
            sliderFillCorner.Parent = sliderFill

            local sliderButton = Instance.new("TextButton")
            sliderButton.Size = UDim2.new(1, 0, 1, 0)
            sliderButton.BackgroundTransparency = 1
            sliderButton.Text = ""
            sliderButton.Parent = sliderBar

            local dragging = false
            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            sliderButton.MouseMoved:Connect(function(x)
                if dragging then
                    local relativeX = math.clamp((x - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * relativeX
                    value = math.round(value)
                    sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    valueLabel.Text = tostring(value)
                    callback(value)
                end
            end)

            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y)
            return {Frame = sliderFrame, Set = function(value)
                local relativeX = (value - min) / (max - min)
                sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                valueLabel.Text = tostring(value)
            end}
        end

        function tab:AddDropdown(options)
            options = options or {}
            local dropdownName = options.Name or "Dropdown"
            local items = options.Items or {}
            local default = options.Default or items[1]
            local callback = options.Callback or function() end

            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.Parent = tabContent

            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Size = UDim2.new(1, -100, 1, 0)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = dropdownName
            dropdownLabel.TextColor3 = textColor
            dropdownLabel.TextSize = 14
            dropdownLabel.Font = Enum.Font.Gotham
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame

            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(0, 150, 0, 30)
            dropdownBtn.Position = UDim2.new(1, -150, 0, 0)
            dropdownBtn.BackgroundColor3 = secondaryColor
            dropdownBtn.Text = default or "Select"
            dropdownBtn.TextColor3 = textColor
            dropdownBtn.TextSize = 14
            dropdownBtn.Font = Enum.Font.Gotham
            dropdownBtn.BorderSizePixel = 0
            dropdownBtn.Parent = dropdownFrame

            local dropdownBtnCorner = Instance.new("UICorner")
            dropdownBtnCorner.CornerRadius = UDim.new(0, options.CornerRadius / 2)
            dropdownBtnCorner.Parent = dropdownBtn

            local dropdownList = Instance.new("ScrollingFrame")
            dropdownList.Size = UDim2.new(0, 150, 0, 0)
            dropdownList.Position = UDim2.new(1, -150, 0, 30)
            dropdownList.BackgroundColor3 = secondaryColor
            dropdownList.BorderSizePixel = 0
            dropdownList.ScrollBarThickness = 4
            dropdownList.ScrollBarImageColor3 = accentColor
            dropdownList.Visible = false
            dropdownList.Parent = dropdownFrame

            local listLayout = Instance.new("UIListLayout")
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Parent = dropdownList

            local listPadding = Instance.new("UIPadding")
            listPadding.PaddingTop = UDim.new(0, 2)
            listPadding.PaddingBottom = UDim.new(0, 2)
            listPadding.Parent = dropdownList

            local function populateList()
                dropdownList:ClearAllChildren()
                listLayout.Parent = nil
                listPadding.Parent = nil
                for _, item in ipairs(items) do
                    local itemBtn = Instance.new("TextButton")
                    itemBtn.Size = UDim2.new(1, 0, 0, 25)
                    itemBtn.BackgroundColor3 = secondaryColor
                    itemBtn.Text = item
                    itemBtn.TextColor3 = textColor
                    itemBtn.TextSize = 14
                    itemBtn.Font = Enum.Font.Gotham
                    itemBtn.BorderSizePixel = 0
                    itemBtn.Parent = dropdownList
                    itemBtn.MouseButton1Click:Connect(function()
                        dropdownBtn.Text = item
                        dropdownList.Visible = false
                        dropdownList.Size = UDim2.new(0, 150, 0, 0)
                        callback(item)
                    end)
                end
                listLayout.Parent = dropdownList
                listPadding.Parent = dropdownList
                dropdownList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
                Tween(dropdownList, {Size = UDim2.new(0, 150, 0, math.min(listLayout.AbsoluteContentSize.Y + 4, 100))}, 0.2)
            end

            populateList()

            dropdownBtn.MouseButton1Click:Connect(function()
                dropdownList.Visible = not dropdownList.Visible
                if dropdownList.Visible then
                    populateList()
                else
                    Tween(dropdownList, {Size = UDim2.new(0, 150, 0, 0)}, 0.2)
                end
            end)

            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y)
            return {Frame = dropdownFrame, SetItems = function(newItems) items = newItems populateList() end, Set = function(value) dropdownBtn.Text = value end}
        end

        function tab:AddKeybind(options)
            options = options or {}
            local keybindName = options.Name or "Keybind"
            local default = options.Default or Enum.KeyCode.Unknown
            local callback = options.Callback or function() end

            local keybindFrame = Instance.new("Frame")
            keybindFrame.Size = UDim2.new(1, 0, 0, 30)
            keybindFrame.BackgroundTransparency = 1
            keybindFrame.Parent = tabContent

            local keybindLabel = Instance.new("TextLabel")
            keybindLabel.Size = UDim2.new(1, -100, 1, 0)
            keybindLabel.BackgroundTransparency = 1
            keybindLabel.Text = keybindName
            keybindLabel.TextColor3 = textColor
            keybindLabel.TextSize = 14
            keybindLabel.Font = Enum.Font.Gotham
            keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            keybindLabel.Parent = keybindFrame

            local keybindBtn = Instance.new("TextButton")
            keybindBtn.Size = UDim2.new(0, 100, 1, 0)
            keybindBtn.Position = UDim2.new(1, -100, 0, 0)
            keybindBtn.BackgroundColor3 = secondaryColor
            keybindBtn.Text = default.Name or "None"
            keybindBtn.TextColor3 = textColor
            keybindBtn.TextSize = 14
            keybindBtn.Font = Enum.Font.Gotham
            keybindBtn.BorderSizePixel = 0
            keybindBtn.Parent = keybindFrame

            local keybindBtnCorner = Instance.new("UICorner")
            keybindBtnCorner.CornerRadius = UDim.new(0, DefaultOptions.CornerRadius / 2)
            keybindBtnCorner.Parent = keybindBtn

            local waitingForBind = false
            keybindBtn.MouseButton1Click:Connect(function()
                waitingForBind = true
                keybindBtn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input)
                if waitingForBind and input.UserInputType == Enum.UserInputType.Keyboard then
                    default = input.KeyCode
                    keybindBtn.Text = input.KeyCode.Name
                    waitingForBind = false
                elseif input.KeyCode == default then
                    callback()
                end
            end)

            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y)
            return keybindFrame
        end

        contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 10)
        end)

        return tab
    end

    -- Bottom Left PFP and Username
    local pfpFrame = Instance.new("Frame")
    pfpFrame.Size = UDim2.new(0, 150, 0, 50)
    pfpFrame.Position = UDim2.new(0, 10, 1, -60)
    pfpFrame.BackgroundColor3 = primaryColor
    pfpFrame.BackgroundTransparency = options.Transparency
    pfpFrame.BorderSizePixel = 0
    pfpFrame.Parent = screenGui

    local pfpCorner = Instance.new("UICorner")
    pfpCorner.CornerRadius = UDim.new(0, options.CornerRadius)
    pfpCorner.Parent = pfpFrame

    local pfpStroke = Instance.new("UIStroke")
    pfpStroke.Color = secondaryColor
    pfpStroke.Transparency = 0.5
    pfpStroke.Parent = pfpFrame

    local thumbnail = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    local profileImage = CreateRoundedImage(pfpFrame, UDim2.new(0, 40, 0, 40), UDim2.new(0, 5, 0.5, -20), thumbnail.Content, 12)  -- Squircle approx

    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Size = UDim2.new(1, -50, 1, 0)
    usernameLabel.Position = UDim2.new(0, 50, 0, 0)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Text = Player.Name
    usernameLabel.TextColor3 = textColor
    usernameLabel.TextSize = 14
    usernameLabel.Font = Enum.Font.Gotham
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.Parent = pfpFrame

    table.insert(Windows, screenGui)
    return window
end

return ZosK
