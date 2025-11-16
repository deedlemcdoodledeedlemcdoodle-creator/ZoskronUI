-- Simple Executor UI Library
-- Paste in your executor (Synapse, Fluxus, Delta, Codex, Arceus, etc.)

local library = {}

function library:Window(title)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "ExecutorUI"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 420, 0, 300)
    Main.Position = UDim2.new(0.5, -210, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Main.Active = true
    Main.Draggable = true

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)

    local Top = Instance.new("TextLabel", Main)
    Top.Size = UDim2.new(1,0,0,32)
    Top.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Top.Text = title or "Executor UI"
    Top.TextColor3 = Color3.new(1,1,1)
    Top.Font = Enum.Font.GothamBold
    Top.TextSize = 17
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0,10)

    local TabButtons = Instance.new("Frame", Main)
    TabButtons.Size = UDim2.new(0,110,1,-32)
    TabButtons.Position = UDim2.new(0,0,0,32)
    TabButtons.BackgroundColor3 = Color3.fromRGB(35,35,35)
    local List = Instance.new("UIListLayout", TabButtons)
    List.Padding = UDim.new(0,5)

    local Pages = Instance.new("Folder", Main)

    local win = {}
    win.Pages = Pages
    win.Buttons = TabButtons

    function win:Tab(name)
        local Button = Instance.new("TextButton", TabButtons)
        Button.Size = UDim2.new(1,-8,0,28)
        Button.Text = name
        Button.Font = Enum.Font.Gotham
        Button.TextColor3 = Color3.new(1,1,1)
        Button.TextSize = 14
        Button.BackgroundColor3 = Color3.fromRGB(55,55,55)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1,-110,1,-32)
        Page.Position = UDim2.new(0,110,0,32)
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.BackgroundColor3 = Color3.fromRGB(25,25,25)
        Page.Visible = false

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,6)

        Button.MouseButton1Click:Connect(function()
            for _,p in pairs(Pages:GetChildren()) do
                p.Visible = false
            end
            Page.Visible = true
        end)

        local tab = {}
        tab.Page = Page

        -- Button
        function tab:Button(text, callback)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1,-12,0,30)
            B.Text = text
            B.Font = Enum.Font.Gotham
            B.TextSize = 14
            B.TextColor3 = Color3.new(1,1,1)
            B.BackgroundColor3 = Color3.fromRGB(50,50,50)
            B.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        -- Toggle
        function tab:Toggle(text, default, callback)
            local Frame = Instance.new("Frame", Page)
            Frame.Size = UDim2.new(1,-12,0,30)
            Frame.BackgroundTransparency = 1

            local Btn = Instance.new("TextButton", Frame)
            Btn.Size = UDim2.new(0,26,0,26)
            Btn.Position = UDim2.new(0,0,0,2)
            Btn.Text = ""
            Btn.BackgroundColor3 = Color3.fromRGB(80,80,80)

            local Txt = Instance.new("TextLabel", Frame)
            Txt.Size = UDim2.new(1,-32,1,0)
            Txt.Position = UDim2.new(0,32,0,0)
            Txt.BackgroundTransparency = 1
            Txt.Font = Enum.Font.Gotham
            Txt.Text = text
            Txt.TextSize = 14
            Txt.TextColor3 = Color3.new(1,1,1)
            Txt.TextXAlignment = Enum.TextXAlignment.Left

            local state = default or false
            if state then Btn.BackgroundColor3 = Color3.fromRGB(0,170,0) end

            Btn.MouseButton1Click:Connect(function()
                state = not state
                Btn.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(80,80,80)
                if callback then callback(state) end
            end)
        end

        return tab
    end

    return win
end

return library
