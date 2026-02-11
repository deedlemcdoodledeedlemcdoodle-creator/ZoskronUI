local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Icons = {}
pcall(function()
    Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/deedlemcdoodledeedlemcdoodle-creator/SpectravaxHub/refs/heads/main/everylucideassetin.lua"))()
end)

local Aether = {
    Themes = {
        Dark = {Main = Color3.fromRGB(18, 18, 20), Accent = Color3.fromRGB(115, 90, 255), Text = Color3.fromRGB(180, 180, 185), Secondary = Color3.fromRGB(28, 28, 32), BoldText = Color3.fromRGB(255, 255, 255)},
        Light = {Main = Color3.fromRGB(240, 240, 245), Accent = Color3.fromRGB(80, 50, 230), Text = Color3.fromRGB(60, 60, 65), Secondary = Color3.fromRGB(220, 220, 225), BoldText = Color3.fromRGB(0, 0, 0)},
        Midnight = {Main = Color3.fromRGB(5, 5, 5), Accent = Color3.fromRGB(255, 255, 255), Text = Color3.fromRGB(140, 140, 140), Secondary = Color3.fromRGB(15, 15, 15), BoldText = Color3.fromRGB(255, 255, 255)},
        Cyber = {Main = Color3.fromRGB(5, 5, 12), Accent = Color3.fromRGB(0, 255, 150), Text = Color3.fromRGB(160, 160, 180), Secondary = Color3.fromRGB(12, 12, 25), BoldText = Color3.fromRGB(255, 255, 255)},
        Ocean = {Main = Color3.fromRGB(10, 22, 35), Accent = Color3.fromRGB(0, 180, 255), Text = Color3.fromRGB(180, 200, 220), Secondary = Color3.fromRGB(20, 35, 50), BoldText = Color3.fromRGB(255, 255, 255)},
        Rose = {Main = Color3.fromRGB(25, 18, 22), Accent = Color3.fromRGB(255, 120, 150), Text = Color3.fromRGB(200, 180, 190), Secondary = Color3.fromRGB(40, 28, 35), BoldText = Color3.fromRGB(255, 255, 255)},
        Emerald = {Main = Color3.fromRGB(15, 25, 18), Accent = Color3.fromRGB(40, 220, 120), Text = Color3.fromRGB(180, 200, 185), Secondary = Color3.fromRGB(25, 35, 28), BoldText = Color3.fromRGB(255, 255, 255)},
        Amber = {Main = Color3.fromRGB(22, 18, 12), Accent = Color3.fromRGB(255, 180, 50), Text = Color3.fromRGB(200, 190, 180), Secondary = Color3.fromRGB(35, 30, 25), BoldText = Color3.fromRGB(255, 255, 255)},
        Amethyst = {Main = Color3.fromRGB(18, 15, 28), Accent = Color3.fromRGB(180, 100, 255), Text = Color3.fromRGB(190, 180, 200), Secondary = Color3.fromRGB(30, 25, 40), BoldText = Color3.fromRGB(255, 255, 255)},
        Crimson = {Main = Color3.fromRGB(20, 12, 12), Accent = Color3.fromRGB(255, 60, 60), Text = Color3.fromRGB(200, 180, 180), Secondary = Color3.fromRGB(35, 20, 20), BoldText = Color3.fromRGB(255, 255, 255)},
        Frost = {Main = Color3.fromRGB(225, 235, 245), Accent = Color3.fromRGB(50, 150, 255), Text = Color3.fromRGB(80, 100, 120), Secondary = Color3.fromRGB(200, 215, 230), BoldText = Color3.fromRGB(20, 40, 60)},
        Vivid = {Main = Color3.fromRGB(35, 35, 38), Accent = Color3.fromRGB(255, 0, 115), Text = Color3.fromRGB(220, 220, 220), Secondary = Color3.fromRGB(45, 45, 50), BoldText = Color3.fromRGB(255, 255, 255)}
    }
}

function Aether:Notify(cfg)
    local SG = CoreGui:FindFirstChild("Aether_Notifs") or Instance.new("ScreenGui", CoreGui)
    SG.Name = "Aether_Notifs"
    local Tray = SG:FindFirstChild("Tray") or Instance.new("Frame", SG)
    if not Tray.Name == "Tray" then
        Tray.Name = "Tray"
        Tray.Size, Tray.Position, Tray.BackgroundTransparency = UDim2.new(0, 250, 1, 0), UDim2.new(1, -260, 0, 0), 1
        local L = Instance.new("UIListLayout", Tray)
        L.VerticalAlignment, L.Padding = "Bottom", UDim.new(0, 10)
    end
    local N = Instance.new("Frame", Tray)
    N.Size, N.BackgroundColor3 = UDim2.new(1, 0, 0, 60), Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", N)
    local T = Instance.new("TextLabel", N)
    T.Text, T.Size, T.Position, T.TextColor3, T.Font, T.TextSize = cfg.Content, UDim2.new(1, -20, 1, -20), UDim2.new(0, 10, 0, 10), Color3.new(1,1,1), "GothamBold", 12
    T.TextWrapped, T.BackgroundTransparency = true, 1
    task.delay(cfg.Time or 3, function() N:Destroy() end)
end

function Aether:CreateWindow(cfg)
    local Win = {Theme = self.Themes[cfg.Theme or "Dark"], Tabs = {}, CurrentTab = nil}
    local SG = Instance.new("ScreenGui", CoreGui)
    local Main = Instance.new("Frame", SG)
    Main.Size, Main.Position, Main.BackgroundColor3, Main.ClipsDescendants = UDim2.new(0, 420, 0, 280), UDim2.new(0.5, -210, 0.5, -140), Win.Theme.Main, true
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Win.Theme.Secondary

    local DragS, DragI, DragSt, StartP
    Main.InputBegan:Connect(function(i)
        if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            DragS = true DragSt = i.Position StartP = Main.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then DragS = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if DragS and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local Delta = i.Position - DragSt
            Main.Position = UDim2.new(StartP.X.Scale, StartP.X.Offset + Delta.X, StartP.Y.Scale, StartP.Y.Offset + Delta.Y)
        end
    end)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size, Sidebar.BackgroundColor3 = UDim2.new(0, 110, 1, 0), Win.Theme.Secondary
    Instance.new("UICorner", Sidebar)
    local PFP = Instance.new("ImageLabel", Sidebar)
    PFP.Size, PFP.Position = UDim2.new(0, 50, 0, 50), UDim2.new(0.5, -25, 0, 15)
    PFP.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    Instance.new("UICorner", PFP).CornerRadius = UDim.new(1, 0)
    local TabScroll = Instance.new("ScrollingFrame", Sidebar)
    TabScroll.Size, TabScroll.Position, TabScroll.BackgroundTransparency, TabScroll.ScrollBarThickness = UDim2.new(1, 0, 1, -85), UDim2.new(0, 0, 0, 75), 1, 0
    Instance.new("UIListLayout", TabScroll).HorizontalAlignment = "Center"

    local Container = Instance.new("Frame", Main)
    Container.Size, Container.Position, Container.BackgroundTransparency = UDim2.new(1, -125, 1, -10), UDim2.new(0, 120, 0, 5), 1

    function Win:Tab(name, icon)
        local T = {Active = false}
        local b = Instance.new("TextButton", TabScroll)
        b.Size, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0.85, 0, 0, 30), name, Win.Theme.Main, Win.Theme.Text
        Instance.new("UICorner", b)
        local C = Instance.new("ScrollingFrame", Container)
        C.Size, C.Visible, C.BackgroundTransparency, C.ScrollBarThickness = UDim2.new(1, 0, 1, 0), false, 1, 0
        Instance.new("UIListLayout", C).Padding = UDim.new(0, 5)

        local function show()
            for _, v in pairs(Win.Tabs) do v.C.Visible = false v.b.TextColor3 = Win.Theme.Text end
            C.Visible = true b.TextColor3 = Win.Theme.Accent
        end
        b.Activated:Connect(show)
        T.b, T.C = b, C
        table.insert(Win.Tabs, T)
        if #Win.Tabs == 1 then show() end

        function T:Button(n, cb)
            local btn = Instance.new("TextButton", C)
            btn.Size, btn.BackgroundColor3, btn.Text, btn.TextColor3 = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, n, Win.Theme.Text
            Instance.new("UICorner", btn)
            btn.Activated:Connect(cb)
        end

        function T:Toggle(n, cb)
            local s = false
            local btn = Instance.new("TextButton", C)
            btn.Size, btn.BackgroundColor3, btn.Text, btn.TextColor3 = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, n.." [OFF]", Win.Theme.Text
            Instance.new("UICorner", btn)
            btn.Activated:Connect(function()
                s = not s
                btn.Text, btn.TextColor3 = n..(s and " [ON]" or " [OFF]"), s and Win.Theme.Accent or Win.Theme.Text
                cb(s)
            end)
        end

        function T:Slider(n, min, max, cb)
            local f = Instance.new("Frame", C)
            f.Size, f.BackgroundColor3 = UDim2.new(0.95, 0, 0, 45), Win.Theme.Secondary
            Instance.new("UICorner", f)
            local l = Instance.new("TextLabel", f)
            l.Text, l.Size, l.Position, l.TextColor3, l.BackgroundTransparency = n.." : "..min, UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 5), Win.Theme.Text, 1
            local bg = Instance.new("Frame", f)
            bg.Size, bg.Position, bg.BackgroundColor3 = UDim2.new(1, -20, 0, 4), UDim2.new(0, 10, 0, 35), Win.Theme.Main
            local fill = Instance.new("Frame", bg)
            fill.Size, fill.BackgroundColor3 = UDim2.new(0, 0, 1, 0), Win.Theme.Accent
            local function upd(i)
                local p = math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                local v = math.floor(min + (max - min) * p)
                fill.Size, l.Text = UDim2.new(p, 0, 1, 0), n.." : "..v
                cb(v)
            end
            bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then upd(i) local m = UIS.InputChanged:Connect(function(i2) if i2.UserInputType == Enum.UserInputType.MouseMovement or i2.UserInputType == Enum.UserInputType.Touch then upd(i2) end end) UIS.InputEnded:Connect(function(i3) if i3.UserInputType == Enum.UserInputType.MouseButton1 or i3.UserInputType == Enum.UserInputType.Touch then m:Disconnect() end end) end end)
        end

        function T:Dropdown(n, list, cb)
            local b = Instance.new("TextButton", C)
            b.Size, b.BackgroundColor3, b.Text, b.TextColor3 = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, n.." +", Win.Theme.Text
            Instance.new("UICorner", b)
            local d = Instance.new("Frame", C)
            d.Size, d.Visible, d.BackgroundColor3 = UDim2.new(0.95, 0, 0, 0), false, Win.Theme.Secondary
            local dl = Instance.new("UIListLayout", d)
            b.Activated:Connect(function() d.Visible = not d.Visible d.Size = d.Visible and UDim2.new(1, 0, 0, dl.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 0) end)
            for _, v in pairs(list) do
                local o = Instance.new("TextButton", d)
                o.Size, o.Text, o.BackgroundColor3, o.TextColor3, o.BorderSizePixel = UDim2.new(1, 0, 0, 25), v, Win.Theme.Secondary, Win.Theme.Text, 0
                o.Activated:Connect(function() b.Text = n.." : "..v d.Visible = false d.Size = UDim2.new(1, 0, 0, 0) cb(v) end)
            end
        end

        return T
    end

    local function Info()
        local bc = "rgb("..math.floor(Win.Theme.BoldText.R*255)..","..math.floor(Win.Theme.BoldText.G*255)..","..math.floor(Win.Theme.BoldText.B*255)..")"
        local i = Instance.new("TextLabel", Container)
        i.Size, i.Position, i.BackgroundTransparency, i.TextColor3, i.RichText = UDim2.new(1, 0, 0, 100), UDim2.new(0,0,0,50), 1, Win.Theme.Text, true
        i.Text = "Your display name is: <font color='"..bc.."'><b>"..LocalPlayer.DisplayName.."</b></font>\nYour username is: <font color='"..bc.."'><b>"..LocalPlayer.Name.."</b></font>\nAnd you're: <font color='"..bc.."'><b>".. (LocalPlayer.AccountAge % 365) .." days, ".. math.floor(LocalPlayer.AccountAge / 365) .." years</b></font> old"
        task.delay(5, function() i:Destroy() end)
    end
    Info()

    return Win
end

return Aether
