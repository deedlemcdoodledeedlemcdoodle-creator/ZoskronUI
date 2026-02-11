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

function Aether:CreateWindow(cfg)
    local Win = {Theme = self.Themes[cfg.Theme or "Dark"], Tabs = {}, Folder = cfg.Name or "zKron"}
    if makefolder then pcall(function() makefolder(Win.Folder) end) end

    local SG = Instance.new("ScreenGui", CoreGui)
    local Main = Instance.new("Frame", SG)
    Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 420, 0, 300), UDim2.new(0.5, -210, 0.5, -150), Win.Theme.Main
    Instance.new("UICorner", Main)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Win.Theme.Secondary

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size, Sidebar.BackgroundColor3 = UDim2.new(0, 110, 1, 0), Win.Theme.Secondary
    Instance.new("UICorner", Sidebar)

    local TabScroll = Instance.new("ScrollingFrame", Sidebar)
    TabScroll.Size, TabScroll.Position, TabScroll.BackgroundTransparency, TabScroll.ScrollBarThickness = UDim2.new(1, 0, 1, -85), UDim2.new(0, 0, 0, 75), 1, 0
    Instance.new("UIListLayout", TabScroll).HorizontalAlignment = "Center"
    Instance.new("UIListLayout", TabScroll).Padding = UDim.new(0, 5)

    local Container = Instance.new("Frame", Main)
    Container.Size, Container.Position, Container.BackgroundTransparency = UDim2.new(1, -125, 1, -20), UDim2.new(0, 120, 0, 10), 1

    function Win:CreateTab(name)
        local T = {}
        local b = Instance.new("TextButton", TabScroll)
        b.Size, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0.85, 0, 0, 30), name, Win.Theme.Main, Win.Theme.Text
        Instance.new("UICorner", b)
        
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size, Page.Visible, Page.BackgroundTransparency, Page.ScrollBarThickness = UDim2.new(1, 0, 1, 0), false, 1, 0
        local L = Instance.new("UIListLayout", Page)
        L.Padding = UDim.new(0, 5)

        b.Activated:Connect(function()
            for _, v in pairs(Win.Tabs) do v.Page.Visible = false v.b.TextColor3 = Win.Theme.Text end
            Page.Visible = true b.TextColor3 = Win.Theme.Accent
        end)
        
        T.b, T.Page = b, Page
        table.insert(Win.Tabs, T)
        if #Win.Tabs == 1 then Page.Visible = true b.TextColor3 = Win.Theme.Accent end

        function T:Button(n, ico, cb)
            local btn = Instance.new("TextButton", Page)
            btn.Size, btn.BackgroundColor3, btn.Text, btn.TextColor3 = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, "      "..n, Win.Theme.Text
            btn.TextXAlignment = "Left"
            Instance.new("UICorner", btn)
            if ico and Icons[ico] then
                local i = Instance.new("ImageLabel", btn)
                i.Size, i.Position, i.Image, i.BackgroundTransparency, i.ImageColor3 = UDim2.new(0, 20, 0, 20), UDim2.new(0, 5, 0.5, -10), Icons[ico], 1, Win.Theme.Accent
            end
            btn.Activated:Connect(cb)
        end

        return T
    end

    local Settings = Win:CreateTab("Settings")
    
    Settings:Button("Save Config", "save", function()
        if writefile then writefile(Win.Folder.."/config.json", HttpService:JSONEncode(Aether.Config)) end
    end)

    Settings:Button("Load Config", "download", function()
        if isfile and isfile(Win.Folder.."/config.json") then
            Aether.Config = HttpService:JSONDecode(readfile(Win.Folder.."/config.json"))
        end
    end)

    Settings:Button("Destroy UI", "trash", function() SG:Destroy() end)

    return Win
end

return Aether