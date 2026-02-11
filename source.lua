local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Aether = {
    Themes = {
        Dark = {Main = Color3.fromRGB(20, 20, 22), Accent = Color3.fromRGB(115, 90, 255), Text = Color3.fromRGB(240, 240, 245), Secondary = Color3.fromRGB(35, 35, 40)},
        Light = {Main = Color3.fromRGB(240, 240, 245), Accent = Color3.fromRGB(80, 50, 230), Text = Color3.fromRGB(25, 25, 30), Secondary = Color3.fromRGB(210, 210, 215)},
        Midnight = {Main = Color3.fromRGB(10, 10, 12), Accent = Color3.fromRGB(255, 255, 255), Text = Color3.fromRGB(220, 220, 225), Secondary = Color3.fromRGB(25, 25, 30)},
        Ocean = {Main = Color3.fromRGB(10, 20, 30), Accent = Color3.fromRGB(0, 180, 255), Text = Color3.fromRGB(230, 245, 255), Secondary = Color3.fromRGB(20, 35, 55)},
        Rose = {Main = Color3.fromRGB(25, 15, 20), Accent = Color3.fromRGB(255, 120, 150), Text = Color3.fromRGB(255, 240, 245), Secondary = Color3.fromRGB(45, 30, 35)},
        Emerald = {Main = Color3.fromRGB(12, 22, 15), Accent = Color3.fromRGB(40, 220, 120), Text = Color3.fromRGB(230, 250, 235), Secondary = Color3.fromRGB(25, 40, 30)},
        Amber = {Main = Color3.fromRGB(20, 18, 12), Accent = Color3.fromRGB(255, 180, 50), Text = Color3.fromRGB(250, 245, 230), Secondary = Color3.fromRGB(40, 35, 25)},
        Amethyst = {Main = Color3.fromRGB(18, 12, 25), Accent = Color3.fromRGB(180, 100, 255), Text = Color3.fromRGB(245, 230, 255), Secondary = Color3.fromRGB(35, 25, 45)},
        Crimson = {Main = Color3.fromRGB(20, 10, 10), Accent = Color3.fromRGB(255, 60, 60), Text = Color3.fromRGB(255, 230, 230), Secondary = Color3.fromRGB(40, 20, 20)},
        Cyber = {Main = Color3.fromRGB(5, 5, 10), Accent = Color3.fromRGB(0, 255, 150), Text = Color3.fromRGB(200, 255, 230), Secondary = Color3.fromRGB(20, 20, 40)},
        Frost = {Main = Color3.fromRGB(230, 240, 250), Accent = Color3.fromRGB(100, 180, 255), Text = Color3.fromRGB(40, 60, 80), Secondary = Color3.fromRGB(200, 215, 230)},
        Vivid = {Main = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(255, 0, 110), Text = Color3.fromRGB(255, 255, 255), Secondary = Color3.fromRGB(50, 50, 50)}
    }
}

function Aether:CreateWindow(cfg)
    local Win = {Theme = self.Themes[cfg.Theme or "Dark"], Full = false, Min = false}
    local SG = Instance.new("ScreenGui", (RS:IsStudio() and game.Players.LocalPlayer.PlayerGui or CoreGui))
    local M = Instance.new("Frame", SG)
    M.Size, M.Position, M.BackgroundColor3, M.ClipsDescendants = UDim2.new(0, 420, 0, 280), UDim2.new(0.5, -210, 0.5, -140), Win.Theme.Main, true
    Instance.new("UICorner", M).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", M).Color = Win.Theme.Secondary

    local T = Instance.new("Frame", M)
    T.Size, T.BackgroundTransparency = UDim2.new(1, 0, 0, 35), 1
    local TL = Instance.new("TextLabel", T)
    TL.Text, TL.Size, TL.Position, TL.TextColor3, TL.Font, TL.TextSize, TL.TextXAlignment, TL.BackgroundTransparency = cfg.Name, UDim2.new(1, -110, 1, 0), UDim2.new(0, 12, 0, 0), Win.Theme.Text, "GothamBold", 14, "Left", 1

    local C = Instance.new("ScrollingFrame", M)
    C.Size, C.Position, C.BackgroundTransparency, C.ScrollBarThickness = UDim2.new(1, -10, 1, -45), UDim2.new(0, 5, 0, 40), 1, 0
    local L = Instance.new("UIListLayout", C)
    L.Padding, L.HorizontalAlignment = UDim.new(0, 5), "Center"

    local function HeadBtn(txt, x, cb)
        local b = Instance.new("TextButton", T)
        b.Size, b.Position, b.Text, b.BackgroundColor3, b.TextColor3, b.Font = UDim2.new(0, 25, 0, 25), UDim2.new(1, x, 0.5, -12), txt, Win.Theme.Secondary, Win.Theme.Text, "GothamBold"
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        b.Activated:Connect(cb)
    end
    HeadBtn("X", -35, function() SG:Destroy() end)
    HeadBtn("▢", -65, function() 
        Win.Full = not Win.Full
        TS:Create(M, TweenInfo.new(0.3), {Size = Win.Full and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 420, 0, 280), Position = Win.Full and UDim2.new(0, 0, 0, 0) or UDim2.new(0.5, -210, 0.5, -140)}):Play()
    end)
    HeadBtn("-", -95, function()
        Win.Min = not Win.Min
        TS:Create(M, TweenInfo.new(0.3), {Size = Win.Min and UDim2.new(0, 420, 0, 35) or UDim2.new(0, 420, 0, 280)}):Play()
    end)

    function Win:Button(n, cb)
        local b = Instance.new("TextButton", C)
        b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.Font = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, n, Win.Theme.Text, "Gotham"
        Instance.new("UICorner", b)
        b.Activated:Connect(cb)
    end

    function Win:Toggle(n, cb)
        local s = false
        local b = Instance.new("TextButton", C)
        b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.Font = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, n.." : OFF", Win.Theme.Text, "Gotham"
        Instance.new("UICorner", b)
        b.Activated:Connect(function()
            s = not s
            b.Text, b.TextColor3 = n..(s and " : ON" or " : OFF"), s and Win.Theme.Accent or Win.Theme.Text
            cb(s)
        end)
    end

    function Win:Slider(n, min, max, cb)
        local f = Instance.new("Frame", C)
        f.Size, f.BackgroundColor3 = UDim2.new(0.95, 0, 0, 45), Win.Theme.Secondary
        Instance.new("UICorner", f)
        local l = Instance.new("TextLabel", f)
        l.Text, l.Size, l.Position, l.TextColor3, l.BackgroundTransparency = n.." : "..min, UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 5), Win.Theme.Text, 1
        local bg = Instance.new("Frame", f)
        bg.Size, bg.Position, bg.BackgroundColor3 = UDim2.new(1, -20, 0, 4), UDim2.new(0, 10, 0, 30), Win.Theme.Main
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

    function Win:TextBox(n, p, cb)
        local f = Instance.new("Frame", C)
        f.Size, f.BackgroundColor3 = UDim2.new(0.95, 0, 0, 50), Win.Theme.Secondary
        Instance.new("UICorner", f)
        local i = Instance.new("TextBox", f)
        i.Size, i.Position, i.PlaceholderText, i.Text, i.BackgroundColor3, i.TextColor3 = UDim2.new(1, -20, 0, 25), UDim2.new(0, 10, 0, 20), p, "", Win.Theme.Main, Win.Theme.Text
        Instance.new("UICorner", i)
        i.FocusLost:Connect(function(e) if e then cb(i.Text) end end)
    end

    function Win:Dropdown(n, l, cb)
        local b = Instance.new("TextButton", C)
        b.Size, b.BackgroundColor3, b.Text, b.TextColor3 = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, n.." ▼", Win.Theme.Text
        Instance.new("UICorner", b)
        local d = Instance.new("Frame", C)
        d.Size, d.Visible, d.BackgroundColor3 = UDim2.new(0.95, 0, 0, 0), false, Win.Theme.Secondary
        local dl = Instance.new("UIListLayout", d)
        b.Activated:Connect(function() d.Visible = not d.Visible d.Size = d.Visible and UDim2.new(0.95, 0, 0, dl.AbsoluteContentSize.Y) or UDim2.new(0.95, 0, 0, 0) end)
        for _,v in pairs(l) do
            local o = Instance.new("TextButton", d)
            o.Size, o.Text, o.BackgroundColor3, o.TextColor3, o.BorderSizePixel = UDim2.new(1, 0, 0, 25), v, Win.Theme.Secondary, Win.Theme.Text, 0
            o.Activated:Connect(function() b.Text, d.Visible, d.Size = n.." : "..v, false, UDim2.new(0.95, 0, 0, 0) cb(v) end)
        end
    end

    function Win:ColorPicker(n, cb)
        local b = Instance.new("TextButton", C)
        b.Size, b.BackgroundColor3, b.Text, b.TextColor3 = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, n, Win.Theme.Text
        Instance.new("UICorner", b)
        local p = Instance.new("Frame", b)
        p.Size, p.Position, p.BackgroundColor3 = UDim2.new(0, 20, 0, 20), UDim2.new(1, -30, 0.5, -10), Win.Theme.Accent
        Instance.new("UICorner", p)
        local clrs = {Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,1), Color3.new(1,1,0), Color3.new(1,0,1), Color3.new(1,1,1)}
        local cur = 1 b.Activated:Connect(function() cur = cur < #clrs and cur + 1 or 1 p.BackgroundColor3 = clrs[cur] cb(clrs[cur]) end)
    end

    function Win:Paragraph(t, c_txt)
        local f = Instance.new("Frame", C)
        f.Size, f.BackgroundColor3 = UDim2.new(0.95, 0, 0, 60), Win.Theme.Secondary
        Instance.new("UICorner", f)
        local tl = Instance.new("TextLabel", f)
        tl.Text, tl.Size, tl.Position, tl.TextColor3, tl.Font, tl.BackgroundTransparency = t, UDim2.new(1, -10, 0, 20), UDim2.new(0, 10, 0, 5), Win.Theme.Accent, "GothamBold", 1
        local cl = Instance.new("TextLabel", f)
        cl.Text, cl.Size, cl.Position, cl.TextColor3, cl.TextWrapped, cl.BackgroundTransparency = c_txt, UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 25), Win.Theme.Text, true, 1
    end

    function Win:CopyLabel(t)
        local b = Instance.new("TextButton", C)
        b.Size, b.BackgroundColor3, b.Text, b.TextColor3 = UDim2.new(0.95, 0, 0, 30), Win.Theme.Secondary, "Copy: "..t, Win.Theme.Text
        Instance.new("UICorner", b)
        b.Activated:Connect(function() setclipboard(t) b.Text = "Copied!" task.wait(1) b.Text = "Copy: "..t end)
    end

    function Win:Label(t)
        local l = Instance.new("TextLabel", C)
        l.Size, l.Text, l.TextColor3, l.BackgroundTransparency, l.Font = UDim2.new(0.95, 0, 0, 20), t, Win.Theme.Text, 1, "Gotham"
    end

    return Win
end

local UI = Aether:CreateWindow({Name = "Aether Mobile", Theme = "Cyber"})
UI:Label("Welcome to Aether")
UI:Button("Destroy UI", function() end)
UI:Toggle("Infinite Jump", function(s) end)
UI:Slider("WalkSpeed", 16, 200, function(v) end)
UI:Dropdown("Location", {"Spawn", "City", "Shop"}, function(v) end)
UI:TextBox("Message", "Type here...", function(t) end)
UI:Paragraph("Credits", "Developed for ScriptBlox 2026")
UI:ColorPicker("UI Accent", function(c) end)
UI:CopyLabel("discord.gg/aether")
