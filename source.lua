local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Update profile picture
local headshotUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="..player.UserId.."&size=150x150&format=Png&isCircular=true"
LMG2L["Player's Profile Picture_20"].Image = headshotUrl

local UISuite = {}
UISuite.Tabs = {}
UISuite.Elements = {}

-- Function to create a new tab
function UISuite:CreateTab(name)
    local tabButton = Instance.new("TextButton", LMG2L["ScrollingFrame_6"])
    tabButton.Text = name
    tabButton.Size = UDim2.new(0, 116, 0, 44)
    tabButton.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.FontFace = Font.new([[rbxasset://fonts/families/Arial.json]])
    Instance.new("UICorner", tabButton)

    local tabContainer = Instance.new("Frame", LMG2L["Scrolling for Container_11"])
    tabContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Visible = false

    local tabScroll = Instance.new("ScrollingFrame", tabContainer)
    tabScroll.Size = UDim2.new(1, 0, 1, 0)
    tabScroll.BackgroundTransparency = 1
    tabScroll.BorderSizePixel = 0
    tabScroll.CanvasSize = UDim2.new(0,0,0,0)
    tabScroll.ScrollBarThickness = 6
    local layout = Instance.new("UIListLayout", tabScroll)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    tabButton.Activated:Connect(function()
        for _, child in pairs(LMG2L["Scrolling for Container_11"]:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = false
            end
        end
        tabContainer.Visible = true
    end)

    UISuite.Tabs[name] = {Button = tabButton, Container = tabContainer, Scroll = tabScroll, Layout = layout}
    return tabButton
end

-- Function to create elements inside a tab
local function AddElement(tabName, element)
    local tab = UISuite.Tabs[tabName]
    if not tab then return end
    element.Parent = tab.Scroll
    tab.Scroll.CanvasSize = UDim2.new(0,0,0,tab.Layout.AbsoluteContentSize.Y)
    table.insert(UISuite.Elements, element)
end

-- Button
function UISuite:CreateButton(tabName, text, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(0, 236, 0, 42)
    button.BackgroundColor3 = Color3.fromRGB(132, 132, 132)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.FontFace = Font.new([[rbxasset://fonts/families/Arial.json]])
    button.TextWrapped = true
    Instance.new("UICorner", button)
    local stroke = Instance.new("UIStroke", button)
    stroke.Thickness = 1.6
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    if callback then
        button.Activated:Connect(callback)
    end
    AddElement(tabName, button)
    return button
end

-- Label
function UISuite:CreateLabel(tabName, text)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(0, 236, 0, 42)
    label.BackgroundColor3 = Color3.fromRGB(132, 132, 132)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.FontFace = Font.new([[rbxasset://fonts/families/Arial.json]])
    label.TextWrapped = true
    Instance.new("UICorner", label)
    local stroke = Instance.new("UIStroke", label)
    stroke.Thickness = 1.6
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AddElement(tabName, label)
    return label
end

-- Toggle
function UISuite:CreateToggle(tabName, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 236, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(132, 132, 132)
    Instance.new("UICorner", frame)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 1.6
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.FontFace = Font.new([[rbxasset://fonts/families/Arial.json]])
    label.TextWrapped = true

    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0.3, -4, 1, -4)
    toggle.Position = UDim2.new(0.7, 2, 0, 2)
    toggle.Text = "OFF"
    toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", toggle)

    toggle.Activated:Connect(function()
        if toggle.Text == "OFF" then
            toggle.Text = "ON"
            if callback then callback(true) end
        else
            toggle.Text = "OFF"
            if callback then callback(false) end
        end
    end)

    AddElement(tabName, frame)
    return frame
end

-- Dropdown
function UISuite:CreateDropdown(tabName, text, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 236, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(132, 132, 132)
    Instance.new("UICorner", frame)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 1.6
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.FontFace = Font.new([[rbxasset://fonts/families/Arial.json]])
    label.TextWrapped = true

    local dropdown = Instance.new("TextButton", frame)
    dropdown.Size = UDim2.new(0.3, -4, 1, -4)
    dropdown.Position = UDim2.new(0.7, 2, 0, 2)
    dropdown.Text = options[1] or ""
    dropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", dropdown)

    dropdown.Activated:Connect(function()
        local currentIndex = table.find(options, dropdown.Text)
        currentIndex = currentIndex and currentIndex + 1 or 1
        if currentIndex > #options then currentIndex = 1 end
        dropdown.Text = options[currentIndex]
        if callback then callback(dropdown.Text) end
    end)

    AddElement(tabName, frame)
    return frame
end

-- Textbox
function UISuite:CreateTextbox(tabName, placeholder, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 236, 0, 42)
    box.BackgroundColor3 = Color3.fromRGB(132, 132, 132)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderText = placeholder or ""
    box.FontFace = Font.new([[rbxasset://fonts/families/Arial.json]])
    box.TextWrapped = true
    Instance.new("UICorner", box)
    local stroke = Instance.new("UIStroke", box)
    stroke.Thickness = 1.6
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    box.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(box.Text)
        end
    end)

    AddElement(tabName, box)
    return box
end

-- Minimize
LMG2L["Minimize Button_1a"].Activated:Connect(function()
    LMG2L["Main Frame_2"].Visible = not LMG2L["Main Frame_2"].Visible
end)

-- Fullsize
LMG2L["Fullsize Button_1d"].Activated:Connect(function()
    local frame = LMG2L["Main Frame_2"]
    if frame.Size == UDim2.new(0, 404, 0, 252) then
        frame.Size = UDim2.new(0, 200, 0, 126)
    else
        frame.Size = UDim2.new(0, 404, 0, 252)
    end
end)

return LMG2L["ScreenGui_1"], UISuite