local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Icons = {}
pcall(function()
    Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/deedlemcdoodledeedlemcdoodle-creator/SpectravaxHub/refs/heads/main/everylucideassetin.lua"))()
end)

local Aether = {
    Themes = {
        Dark = {Main = Color3.fromRGB(18, 18, 20), Accent = Color3.fromRGB(115, 90, 255), Text = Color3.fromRGB(180, 180, 185), Secondary = Color3.fromRGB(28, 28, 32), BoldText = Color3.fromRGB(255, 255, 255)},
        Amber = {Main = Color3.fromRGB(22, 18, 12), Accent = Color3.fromRGB(255, 180, 50), Text = Color3.fromRGB(200, 190, 180), Secondary = Color3.fromRGB(35, 30, 25), BoldText = Color3.fromRGB(255, 255, 255)},
        Amethyst = {Main = Color3.fromRGB(18, 15, 28), Accent = Color3.fromRGB(180, 100, 255), Text = Color3.fromRGB(190, 180, 200), Secondary = Color3.fromRGB(30, 25, 40), BoldText = Color3.fromRGB(255, 255, 255)}
    },
    Config = {}
}

function Aether:SaveConfig(folder)
    if writefile then writefile(folder.."/settings.json", HttpService:JSONEncode(self.Config)) end
end

function Aether:LoadConfig(folder)
    if isfile and isfile(folder.."/settings.json") then self.Config = HttpService:JSONDecode(readfile(folder.."/settings.json")) end
end

function Aether:CreateWindow(cfg)
    local Win = {Theme = self.Themes[cfg.Theme or "Dark"], Tabs = {}, Folder = cfg.Name or "zKron"}
    if makefolder then pcall(function() makefolder(Win.Folder) end) end
    self:LoadConfig(Win.Folder)

    local SG = Instance.new("ScreenGui", CoreGui)
    local Main = Instance.new("Frame", SG)
    Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 420, 0, 300), UDim2.new(0.5, -210, 0.5, -150), Win.Theme.Main
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Win.Theme.Secondary

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size, Sidebar.BackgroundColor3 = UDim2.new(0, 110, 1, 0), Win.Theme.Secondary
    Instance.new("UICorner", Sidebar)

    local PFP = Instance.new("ImageLabel", Sidebar)
    PFP.Size, PFP.Position = UDim2.new(0, 50, 0, 50), UDim2.new(0.5, -25, 0, 15)
    PFP.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    Instance.new("UICorner", PFP).CornerRadius = UDim.new(1, 0)

    local SearchBox = Instance.new("TextBox", Main)
    SearchBox.Size, SearchBox.Position, SearchBox.BackgroundColor3 = UDim2.new(1, -135, 0, 25), UDim2.new(0, 125, 0, 10), Win.Theme.Secondary
    SearchBox.PlaceholderText, SearchBox.Text, SearchBox.TextColor3, SearchBox.Font, SearchBox.TextSize = "Search elements...", "", Win.Theme.Text, "Gotham", 12
    Instance.new("UICorner", SearchBox)

    local Container = Instance.new("Frame", Main)
    Container.Size, Container.Position, Container.BackgroundTransparency = UDim2.new(1, -125, 1, -50), UDim2.new(0, 120, 0, 45), 1

    local TabScroll = Instance.new("ScrollingFrame", Sidebar)
    TabScroll.Size, TabScroll.Position, TabScroll.BackgroundTransparency, TabScroll.ScrollBarThickness = UDim2.new(1, 0, 1, -85), UDim2.new(0, 0, 0, 75), 1, 0
    Instance.new("UIListLayout", TabScroll).HorizontalAlignment = "Center"

    function Win:CreateTab(name)
        local T = {Elements = {}}
        local b = Instance.new("TextButton", TabScroll)
        b.Size, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0.85, 0, 0, 30), name, Win.Theme.Main, Win.Theme.Text
        Instance.new("UICorner", b)
        
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size, Page.Visible, Page.BackgroundTransparency, Page.ScrollBarThickness = UDim2.new(1, 0, 1, 0), false, 1, 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

        b.Activated:Connect(function()
            for _, v in pairs(Win.Tabs) do v.Page.Visible = false v.b.TextColor3 = Win.Theme.Text end
            Page.Visible = true b.TextColor3 = Win.Theme.Accent
            Win.CurrentTab = T
        end)
        
        T.b, T.Page = b, Page
        table.insert(Win.Tabs, T)
        if #Win.Tabs == 1 then Page.Visible = true b.TextColor3 = Win.Theme.Accent Win.CurrentTab = T end

        function T:AddElement(obj, n)
            table.insert(T.Elements, {Instance = obj, Name = n:lower()})
        end

        function T:Button(n, cb)
            local btn = Instance.new("TextButton", Page)
            btn.Size, btn.BackgroundColor3, btn.Text, btn.TextColor3 = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, n, Win.Theme.Text
            Instance.new("UICorner", btn); btn.Activated:Connect(cb)
            T:AddElement(btn, n)
        end

        function T:Toggle(n, cb)
            local s = Aether.Config[n] or false
            local btn = Instance.new("TextButton", Page)
            btn.Size, btn.BackgroundColor3, btn.Text, btn.TextColor3 = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, n.." ["..(s and "ON" or "OFF").."]", s and Win.Theme.Accent or Win.Theme.Text
            Instance.new("UICorner", btn)
            btn.Activated:Connect(function()
                s = not s; Aether.Config[n] = s; btn.Text, btn.TextColor3 = n.." ["..(s and "ON" or "OFF").."]", s and Win.Theme.Accent or Win.Theme.Text
                Aether:SaveConfig(Win.Folder); cb(s)
            end)
            T:AddElement(btn, n); task.spawn(function() cb(s) end)
        end

        function T:Slider(n, min, max, cb)
            local v = Aether.Config[n] or min
            local f = Instance.new("Frame", Page); f.Size, f.BackgroundColor3 = UDim2.new(0.95, 0, 0, 45), Win.Theme.Secondary
            Instance.new("UICorner", f)
            local l = Instance.new("TextLabel", f); l.Text, l.Size, l.Position, l.TextColor3, l.BackgroundTransparency = n.." : "..v, UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 5), Win.Theme.Text, 1
            local bg = Instance.new("Frame", f); bg.Size, bg.Position, bg.BackgroundColor3 = UDim2.new(1, -20, 0, 4), UDim2.new(0, 10, 0, 35), Win.Theme.Main
            local fill = Instance.new("Frame", bg); fill.Size, fill.BackgroundColor3 = UDim2.new((v-min)/(max-min), 0, 1, 0), Win.Theme.Accent
            local function upd(i)
                local p = math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                v = math.floor(min + (max - min) * p); fill.Size, l.Text = UDim2.new(p, 0, 1, 0), n.." : "..v
                Aether.Config[n] = v; Aether:SaveConfig(Win.Folder); cb(v)
            end
            bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then upd(i) end end)
            T:AddElement(f, n); task.spawn(function() cb(v) end)
        end

        function T:ColorPicker(n, def, cb)
            local btn = Instance.new("TextButton", Page)
            btn.Size, btn.BackgroundColor3, btn.Text, btn.TextColor3 = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, n, Win.Theme.Text
            Instance.new("UICorner", btn)
            local cp = Instance.new("Frame", btn); cp.Size, cp.Position, cp.BackgroundColor3 = UDim2.new(0, 20, 0, 20), UDim2.new(1, -30, 0.5, -10), def
            Instance.new("UICorner", cp); btn.Activated:Connect(function() local nc = Color3.fromHSV(tick()%5/5,1,1) cp.BackgroundColor3 = nc cb(nc) end)
            T:AddElement(btn, n)
        end

        return T
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBox.Text:lower()
        if Win.CurrentTab then
            for _, el in pairs(Win.CurrentTab.Elements) do
                el.Instance.Visible = el.Name:find(query) and true or false
            end
        end
    end)

    return Win
end

return Aether
