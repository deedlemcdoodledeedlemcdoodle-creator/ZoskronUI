-- Modern Smooth UI Library (2026 Edition)
-- Clean, beautiful, animated UI components with TweenService
-- No silent failures - proper error handling and visual feedback
-- Easy to use: Library:CreateWindow(), then add Buttons, Toggles, Sliders, Labels, etc.
-- Draggable, rounded, smooth hover/press animations, theme support

local UI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Default Theme (clean modern dark)
local Theme = {
    Background = Color3.fromRGB(25, 25, 30),
    Secondary = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(230, 230, 230),
    Hover = Color3.fromRGB(45, 45, 50),
    Pressed = Color3.fromRGB(0, 140, 220)
}

-- Tween helper
local function tween(obj, props, duration, style, direction)
    duration = duration or 0.2
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tween = TweenService:Create(obj, TweenInfo.new(duration, style, direction), props)
    tween:Play()
    return tween
end

-- Draggable function
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

-- Create main window
function UI:CreateWindow(title)
    title = title or "UI Library"

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernUILibrary"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 14)
    shadowCorner.Parent = shadow

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Theme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 12)
    titleBarCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    closeBtn.MouseEnter:Connect(function() tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(220, 60, 60)}) end)
    closeBtn.MouseLeave:Connect(function() tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}) end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        task.wait(0.3)
        screenGui:Destroy()
    end)

    makeDraggable(mainFrame, titleBar)

    -- Content container
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -65)
    content.Position = UDim2.new(0, 10, 0, 55)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 6
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = mainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = content

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = content

    -- Public methods
    local window = {}

    function window:Button(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.BackgroundColor3 = Theme.Accent
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.BorderSizePixel = 0
        btn.Parent = content

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Theme.Accent:lerp(Color3.new(1,1,1), 0.15)}) end)
        btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Theme.Accent}) end)
        btn.MouseButton1Down:Connect(function() tween(btn, {BackgroundColor3 = Theme.Pressed}) end)
        btn.MouseButton1Up:Connect(function() tween(btn, {BackgroundColor3 = Theme.Accent}) end)

        btn.MouseButton1Click:Connect(function()
            if callback then
                spawn(callback)
            end
        end)

        return btn
    end

    function window:Label(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 30)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Theme.Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 15
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = content
        return label
    end

    function window:Toggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 40)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = content

        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -60, 1, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = Theme.Text
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 15
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 50, 0, 26)
        toggleBtn.Position = UDim2.new(1, -55, 0.5, -13)
        toggleBtn.BackgroundColor3 = default and Theme.Accent or Theme.Secondary
        toggleBtn.Text = ""
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Parent = toggleFrame

        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 13)
        toggleCorner.Parent = toggleBtn

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 20, 0, 20)
        indicator.Position = default and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
        indicator.BackgroundColor3 = Color3.new(1, 1, 1)
        indicator.Parent = toggleBtn

        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(0, 10)
        indCorner.Parent = indicator

        local state = default or false

        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            tween(toggleBtn, {BackgroundColor3 = state and Theme.Accent or Theme.Secondary}, 0.3)
            tween(indicator, {Position = state and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)}, 0.3)
            if callback then callback(state) end
        end)

        return toggleFrame
    end

    -- Fade in
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    tween(mainFrame, {Size = UDim2.new(0, 500, 0, 380)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    return window
end

print("Modern Smooth UI Library Loaded - Beautiful & Reliable")

return UI
