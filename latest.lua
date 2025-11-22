-- Z-Lite UI Library (SICK MODE VISUAL UPGRADE) -- Includes: Windows, Tabs, Buttons, Labels, Toggles, Sliders, Dropdowns, Notifications

local library = {} library.__index = library

-- NOTIFICATION SYSTEM -- local function createNotification(text) local ScreenGui = game.CoreGui:FindFirstChild("ZLite_UI") if not ScreenGui then return end

local Notify = Instance.new("TextLabel")
Notify.Size = UDim2.new(0, 250, 0, 35)
Notify.Position = UDim2.new(1, -260, 1, -50)
Notify.BackgroundColor3 = Color3.fromRGB(40,40,40)
Notify.TextColor3 = Color3.new(1,1,1)
Notify.Font = Enum.Font.Gotham
Notify.TextSize = 14
Notify.Text = text
Notify.Parent = ScreenGui

task.spawn(function()
    task.wait(2.5)
    Notify:Destroy()
end)

end

-- INIT -- function library.Init() local self = setmetatable({}, library)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZLite_UI"
ScreenGui.Parent = game.CoreGui

self.ScreenGui = ScreenGui
return self

end

-- WINDOW -- function library:Window(title) local window = {} setmetatable(window, window)

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 210)
Frame.Position = UDim2.new(0.5, -130, 0.5, -105)
Frame.Active = true
Frame.Draggable = true
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
-- Gradient
local Grad = Instance.new("UIGradient")
Grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,140,0)), -- Orange
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))      -- Black
})
Grad.Rotation = 90
Grad.Parent = Frame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,12)
Corner.Parent = Frame
Frame.Parent = self.ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 32)
Title.BackgroundColor3 = Color3.fromRGB(45,45,45)
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0,8)
TitleCorner.Parent = Title
Title.Text = title
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 16
Title.Parent = Frame

-- TAB BAR --
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0,0,0,32)
TabBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0,8)
TabCorner.Parent = TabBar
TabBar.Parent = Frame

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabBar

local Pages = Instance.new("Folder")
Pages.Parent = Frame

function window:Tab(name)
    local tab = {}

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 80, 1, 0)
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0,6)
        BtnCorner.Parent = Button
    Button.Text = name
    Button.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.Parent = TabBar

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, -62)
    Page.Position = UDim2.new(0,0,0,62)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = Pages

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 6)
    List.Parent = Page

    -- Switch tab --
    Button.MouseButton1Click:Connect(function()
        for _, p in ipairs(Pages:GetChildren()) do p.Visible = false end
        Page.Visible = true
    end)

    -- Tab Content Functions --

    function tab:Label(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -10, 0, 25)
        Label.Text = text
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.new(1,1,1)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.Parent = Page
    end

    function tab:Button(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -10, 0, 30)
        Btn.Text = text
        Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        local BtnRound = Instance.new("UICorner")
        BtnRound.CornerRadius = UDim.new(0,6)
        BtnRound.Parent = Btn
        Btn.TextColor3 = Color3.new(1,1,1)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        Btn.Parent = Page
        Btn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
    end

    function tab:Toggle(text, default, callback)
        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(1, -10, 0, 30)
        Toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
        local ToggleRound = Instance.new("UICorner")
        ToggleRound.CornerRadius = UDim.new(0,6)
        ToggleRound.Parent = Toggle
        Toggle.TextColor3 = Color3.new(1,1,1)
        Toggle.Font = Enum.Font.Gotham
        Toggle.TextSize = 14
        Toggle.Parent = Page

        local state = default or false
        Toggle.Text = text .. " [" .. (state and "ON" or "OFF") .. "]"

        Toggle.MouseButton1Click:Connect(function()
            state = not state
            Toggle.Text = text .. " [" .. (state and "ON" or "OFF") .. "]"
            if callback then callback(state) end
        end)
    end

    function tab:Slider(text, min, max, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, -10, 0, 35)
        Frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0,8)
        SliderCorner.Parent = Frame
        Frame.Parent = Page

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 15)
        Label.BackgroundTransparency = 1
        Label.Text = text .. ": " .. min
        Label.TextColor3 = Color3.new(1,1,1)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 13
        Label.Parent = Frame

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(1, -10, 0, 8)
        Bar.Position = UDim2.new(0,5,0,22)
        Bar.BackgroundColor3 = Color3.fromRGB(70,70,70)
        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(0,6)
        BarCorner.Parent = Bar
        Bar.Parent = Frame

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new(0,0,1,0)
        Fill.BackgroundColor3 = Color3.fromRGB(170,170,170)
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(0,6)
        FillCorner.Parent = Fill
        Fill.Parent = Bar

        local dragging = false

        Bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)

        game:GetService("UserInputService").InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)

        game:GetService("RunService").RenderStepped:Connect(function()
            if dragging then
                local pos = math.clamp((game:GetService("UserInputService").GetMouseLocation().X - Bar.AbsolutePosition.X), 0, Bar.AbsoluteSize.X)
                Fill.Size = UDim2.new(pos / Bar.AbsoluteSize.X, 0, 1, 0)
                local value = math.floor(min + ((max - min) * (pos / Bar.AbsoluteSize.X)))
                Label.Text = text .. ": " .. value
                if callback then callback(value) end
            end
        end)
    end

    function tab:Dropdown(text, list, callback)
        local Drop = Instance.new("TextButton")
        Drop.Size = UDim2.new(1, -10, 0, 30)
        Drop.BackgroundColor3 = Color3.fromRGB(60,60,60)
        local DropRound = Instance.new("UICorner")
        DropRound.CornerRadius = UDim.new(0,6)
        DropRound.Parent = Drop
        Drop.TextColor3 = Color3.new(1,1,1)
        Drop.Font = Enum.Font.Gotham
        Drop.TextSize = 14
        Drop.Text = text
        Drop.Parent = Page

        local Open = false

        Drop.MouseButton1Click:Connect(function()
            Open = not Open
            if Open then
                for _, v in ipairs(list) do
                    local Opt = Instance.new("TextButton")
                    Opt.Size = UDim2.new(1, -10, 0, 25)
                    Opt.Text = v
                    Opt.BackgroundColor3 = Color3.fromRGB(60,60,60)
                    Opt.TextColor3 = Color3.new(1,1,1)
                    Opt.Font = Enum.Font.Gotham
                    Opt.TextSize = 14
                    Opt.Parent = Page

                    Opt.MouseButton1Click:Connect(function()
                        Drop.Text = text .. ": " .. v
                        if callback then callback(v) end
                    end)
                end
            else
                for _, c in ipairs(Page:GetChildren()) do
                    if c:IsA("TextButton") and c ~= Drop then c:Destroy() end
                end
            end
        end)
    end

    return tab
end

function window:Notify(text)
    createNotification(text)
end

return window

end

return library
