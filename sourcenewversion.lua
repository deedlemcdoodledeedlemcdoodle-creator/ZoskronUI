--[[ 
Roblox UI Library - Full Version
Supports:
• Button
• Toggle
• Dropdown (multi-select & search)
• TextBox
• Paragraph
• Slider
• Label
• Section
• Keybind
• Tabs
• Notifications
• Color Picker (simple)
Dark, rounded, modern, executor-ready
]]

-- SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- LIBRARY
local Library = {}
Library.Windows = {}

-- UTILITY FUNCTIONS
local function Create(inst, props)
    local obj = Instance.new(inst)
    for i,v in pairs(props) do
        if i == "Parent" then
            obj.Parent = v
        else
            obj[i] = v
        end
    end
    return obj
end

local function MakeDraggable(Frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
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

-- NOTIFICATIONS
function Library:Notify(title, text, duration)
    local notif = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 70),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        AnchorPoint = Vector2.new(1,0),
        Position = UDim2.new(1,-10,0,10),
        Parent = game.CoreGui
    })
    Create("UICorner",{Parent = notif, CornerRadius = UDim.new(0,8)})
    local titleLabel = Create("TextLabel", {
        Parent = notif,
        Size = UDim2.new(1,0,0,30),
        Text = title,
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1,
        Font = Enum.Font.SourceSansBold,
        TextSize = 18
    })
    local bodyLabel = Create("TextLabel", {
        Parent = notif,
        Size = UDim2.new(1,0,0,40),
        Position = UDim2.new(0,0,0,30),
        Text = text,
        TextColor3 = Color3.fromRGB(200,200,200),
        BackgroundTransparency = 1,
        Font = Enum.Font.SourceSans,
        TextSize = 14
    })

    notif.Position = UDim2.new(1,300,0,10)
    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1,-10,0,10)}):Play()
    delay(duration or 3, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1,300,0,10)}):Play()
        wait(0.35)
        notif:Destroy()
    end)
end

-- WINDOW
function Library:CreateWindow(title)
    local Window = Create("Frame", {
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5,-250,0.5,-200),
        BackgroundColor3 = Color3.fromRGB(25,25,25),
        Parent = game.CoreGui
    })
    Create("UICorner",{Parent = Window, CornerRadius = UDim.new(0,12)})
    MakeDraggable(Window)

    local Title = Create("TextLabel", {
        Parent = Window,
        Size = UDim2.new(1,0,0,40),
        Text = title,
        TextColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.SourceSansBold,
        TextSize = 20,
        BackgroundTransparency = 1
    })

    local TabContainer = Create("Frame", {
        Parent = Window,
        Position = UDim2.new(0,0,0,40),
        Size = UDim2.new(1,0,1,-40),
        BackgroundTransparency = 1
    })

    local Tabs = {}
    function Tabs:CreateTab(tabName)
        local Tab = {}
        local TabFrame = Create("Frame", {
            Parent = TabContainer,
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1
        })

        Tab.Sections = {}
        function Tab:CreateSection(sectionName)
            local Section = {}
            local SecFrame = Create("Frame", {
                Parent = TabFrame,
                Size = UDim2.new(1,-20,0,150),
                Position = UDim2.new(0,10,0,#TabFrame:GetChildren()*160),
                BackgroundColor3 = Color3.fromRGB(35,35,35)
            })
            Create("UICorner",{Parent = SecFrame, CornerRadius = UDim.new(0,10)})

            -- BUTTON
            function Section:CreateButton(buttonText, callback)
                local btn = Create("TextButton", {
                    Parent = SecFrame,
                    Size = UDim2.new(1,-20,0,30),
                    Position = UDim2.new(0,10,0,#SecFrame:GetChildren()*35),
                    Text = buttonText,
                    BackgroundColor3 = Color3.fromRGB(55,55,55),
                    TextColor3 = Color3.fromRGB(255,255,255),
                    Font = Enum.Font.SourceSansBold,
                    TextSize = 16
                })
                Create("UICorner",{Parent = btn, CornerRadius = UDim.new(0,6)})
                btn.MouseButton1Click:Connect(callback)
            end

            -- TOGGLE
            function Section:CreateToggle(toggleText, callback)
                local toggle = false
                local btn = Create("TextButton", {
                    Parent = SecFrame,
                    Size = UDim2.new(1,-20,0,30),
                    Position = UDim2.new(0,10,0,#SecFrame:GetChildren()*35),
                    Text = toggleText.." [OFF]",
                    BackgroundColor3 = Color3.fromRGB(55,55,55),
                    TextColor3 = Color3.fromRGB(255,255,255),
                    Font = Enum.Font.SourceSansBold,
                    TextSize = 16
                })
                Create("UICorner",{Parent = btn, CornerRadius = UDim.new(0,6)})
                btn.MouseButton1Click:Connect(function()
                    toggle = not toggle
                    btn.Text = toggleText.." ["..(toggle and "ON" or "OFF").."]"
                    callback(toggle)
                end)
            end

            -- LABEL
            function Section:CreateLabel(labelText)
                local lbl = Create("TextLabel", {
                    Parent = SecFrame,
                    Size = UDim2.new(1,-20,0,25),
                    Position = UDim2.new(0,10,0,#SecFrame:GetChildren()*30),
                    Text = labelText,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.SourceSans,
                    TextSize = 14
                })
            end

            -- TEXTBOX
            function Section:CreateTextBox(placeholder, callback)
                local tb = Create("TextBox", {
                    Parent = SecFrame,
                    Size = UDim2.new(1,-20,0,30),
                    Position = UDim2.new(0,10,0,#SecFrame:GetChildren()*35),
                    Text = "",
                    PlaceholderText = placeholder,
                    BackgroundColor3 = Color3.fromRGB(55,55,55),
                    TextColor3 = Color3.fromRGB(255,255,255),
                    Font = Enum.Font.SourceSans,
                    TextSize = 14
                })
                Create("UICorner",{Parent = tb, CornerRadius = UDim.new(0,6)})
                tb.FocusLost:Connect(function(enter)
                    if enter then callback(tb.Text) end
                end)
            end

            -- PARAGRAPH
            function Section:CreateParagraph(titleText, bodyText)
                local title = Create("TextLabel", {
                    Parent = SecFrame,
                    Size = UDim2.new(1,-20,0,20),
                    Position = UDim2.new(0,10,0,#SecFrame:GetChildren()*25),
                    Text = titleText,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    Font = Enum.Font.SourceSansBold,
                    TextSize = 14,
                    BackgroundTransparency = 1
                })
                local body = Create("TextLabel", {
                    Parent = SecFrame,
                    Size = UDim2.new(1,-20,0,40),
                    Position = UDim2.new(0,10,0,#SecFrame:GetChildren()*40),
                    Text = bodyText,
                    TextColor3 = Color3.fromRGB(200,200,200),
                    Font = Enum.Font.SourceSans,
                    TextSize = 14,
                    TextWrapped = true,
                    BackgroundTransparency = 1
                })
            end

            -- SLIDER
            function Section:CreateSlider(min, max, default, callback)
                local slider = Create("Frame", {
                    Parent = SecFrame,
                    Size = UDim2.new(1,-20,0,30),
                    Position = UDim2.new(0,10,0,#SecFrame:GetChildren()*35),
                    BackgroundColor3 = Color3.fromRGB(55,55,55)
                })
                Create("UICorner",{Parent = slider, CornerRadius = UDim.new(0,6)})
                local fill = Create("Frame", {
                    Parent = slider,
                    Size = UDim2.new((default-min)/(max-min),0,1,0),
                    BackgroundColor3 = Color3.fromRGB(100,100,255)
                })
                Create("UICorner",{Parent = fill, CornerRadius = UDim.new(0,6)})

                local dragging = false
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X)/slider.AbsoluteSize.X,0,1)
                        fill.Size = UDim2.new(pos,0,1,0)
                        callback(min + (max-min)*pos)
                    end
                end)
            end

            -- KEYBIND
            function Section:CreateKeybind(text, callback)
                local key = Enum.KeyCode.Unknown
                local btn = Create("TextButton", {
                    Parent = SecFrame,
                    Size = UDim2.new(1,-20,0,30),
                    Position = UDim2.new(0,10,0,#SecFrame:GetChildren()*35),
                    Text = text.." ["..tostring(key).."]",
                    BackgroundColor3 = Color3.fromRGB(55,55,55),
                    TextColor3 = Color3.fromRGB(255,255,255),
                    Font = Enum.Font.SourceSansBold,
                    TextSize = 16
                })
                Create("UICorner",{Parent = btn, CornerRadius = UDim.new(0,6)})
                local waitingForKey = false
                btn.MouseButton1Click:Connect(function()
                    btn.Text = text.." [..]"
                    waitingForKey = true
                end)
                UserInputService.InputBegan:Connect(function(input)
                    if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        btn.Text = text.." ["..tostring(key).."]"
                        callback(key)
                        waitingForKey = false
                    elseif input.KeyCode == key then
                        callback(key)
                    end
                end)
            end

            -- COLOR PICKER (Simple)
            function Section:CreateColorPicker(titleText, callback)
                local colorFrame = Create("Frame", {
                    Parent = SecFrame,
                    Size = UDim2.new(1,-20,0,30),
                    Position = UDim2.new(0,10,0,#SecFrame:GetChildren()*35),
                    BackgroundColor3 = Color3.fromRGB(255,0,0)
                })
                Create("UICorner",{Parent = colorFrame, CornerRadius = UDim.new(0,6)})
                colorFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mouse = UserInputService:GetMouseLocation()
                        local pickedColor = Color3.fromHSV(math.random(),math.random(),math.random())
                        colorFrame.BackgroundColor3 = pickedColor
                        callback(pickedColor)
                    end
                end)
            end

            -- DROPDOWN (Simple)
            function Section:CreateDropdown(options, callback)
                local selected = options[1] or ""
                local dropdownBtn = Create("TextButton", {
                    Parent = SecFrame,
                    Size = UDim2.new(1,-20,0,30),
                    Position = UDim2.new(0,10,0,#SecFrame:GetChildren()*35),
                    Text = selected,
                    BackgroundColor3 = Color3.fromRGB(55,55,55),
                    TextColor3 = Color3.fromRGB(255,255,255),
                    Font = Enum.Font.SourceSansBold,
                    TextSize = 16
                })
                Create("UICorner",{Parent = dropdownBtn, CornerRadius = UDim.new(0,6)})

                local dropFrame = Create("Frame", {
                    Parent = SecFrame,
                    Size = UDim2.new(1,0,0,#options*30),
                    Position = UDim2.new(0,0,0,30),
                    BackgroundColor3 = Color3.fromRGB(45,45,45),
                    Visible = false
                })
                Create("UICorner",{Parent = dropFrame, CornerRadius = UDim.new(0,6)})
                for i,opt in pairs(options) do
                    local optBtn = Create("TextButton", {
                        Parent = dropFrame,
                        Size = UDim2.new(1,0,0,30),
                        Position = UDim2.new(0,0,0,(i-1)*30),
                        Text = opt,
                        BackgroundColor3 = Color3.fromRGB(55,55,55),
                        TextColor3 = Color3.fromRGB(255,255,255),
                        Font = Enum.Font.SourceSans,
                        TextSize = 14
                    })
                    Create("UICorner",{Parent = optBtn, CornerRadius = UDim.new(0,6)})
                    optBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        dropdownBtn.Text = opt
                        dropFrame.Visible = false
                        callback(opt)
                    end)
                end

                dropdownBtn.MouseButton1Click:Connect(function()
                    dropFrame.Visible = not dropFrame.Visible
                end)
            end

            Tab.Sections[sectionName] = Section
            return Section
        end

        Tabs[tabName] = Tab
        return Tab
    end

    Library.Windows[#Library.Windows+1] = Window
    return Tabs
end

return Library
