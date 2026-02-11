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
    SG.Name = "zKron_Suite"
    
    local Main = Instance.new("Frame", SG)
    Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 420, 0, 320), UDim2.new(0.5, -210, 0.5, -160), Win.Theme.Main
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Win.Theme.Secondary

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size, Sidebar.BackgroundColor3 = UDim2.new(0, 110, 1, 0), Win.Theme.Secondary
    Instance.new("UICorner", Sidebar)

    local TabScroll = Instance.new("ScrollingFrame", Sidebar)
    TabScroll.Size, TabScroll.Position, TabScroll.BackgroundTransparency, TabScroll.ScrollBarThickness = UDim2.new(1, 0, 1, -110), UDim2.new(0, 0, 0, 10), 1, 0
    Instance.new("UIListLayout", TabScroll).HorizontalAlignment = "Center"
    Instance.new("UIListLayout", TabScroll).Padding = UDim.new(0, 5)

    local BottomSection = Instance.new("Frame", Sidebar)
    BottomSection.Size, BottomSection.Position, BottomSection.BackgroundTransparency = UDim2.new(1, 0, 0, 90), UDim2.new(0, 0, 1, -95), 1

    local PFP = Instance.new("ImageLabel", BottomSection)
    PFP.Size, PFP.Position = UDim2.new(0, 45, 0, 45), UDim2.new(0.5, -22, 0, 0)
    PFP.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    Instance.new("UICorner", PFP).CornerRadius = UDim.new(1, 0)

    local CheckBtn = Instance.new("TextButton", BottomSection)
    CheckBtn.Size, CheckBtn.Position = UDim2.new(0, 80, 0, 30), UDim2.new(0.5, -40, 0, 50)
    CheckBtn.Text, CheckBtn.BackgroundColor3, CheckBtn.TextColor3 = "Check", Win.Theme.Main, Win.Theme.Text
    CheckBtn.Font, CheckBtn.TextSize = "GothamBold", 12
    Instance.new("UICorner", CheckBtn)

    local SearchBox = Instance.new("TextBox", Main)
    SearchBox.Size, SearchBox.Position, SearchBox.BackgroundColor3 = UDim2.new(1, -135, 0, 25), UDim2.new(0, 125, 0, 10), Win.Theme.Secondary
    SearchBox.PlaceholderText, SearchBox.Text, SearchBox.TextColor3, SearchBox.Font, SearchBox.TextSize, SearchBox.Visible = "Search...", "", Win.Theme.Text, "Gotham", 12, false
    Instance.new("UICorner", SearchBox)

    local Container = Instance.new("Frame", Main)
    Container.Size, Container.Position, Container.BackgroundTransparency = UDim2.new(1, -125, 1, -20), UDim2.new(0, 120, 0, 10), 1

    local UserInfoPage = Instance.new("Frame", Container)
    UserInfoPage.Size, UserInfoPage.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
    local bc = "rgb("..math.floor(Win.Theme.BoldText.R*255)..","..math.floor(Win.Theme.BoldText.G*255)..","..math.floor(Win.Theme.BoldText.B*255)..")"
    local info = Instance.new("TextLabel", UserInfoPage)
    info.Size, info.BackgroundTransparency, info.TextColor3, info.Font, info.TextSize, info.RichText = UDim2.new(1, 0, 1, 0), 1, Win.Theme.Text, "Gotham", 14, true
    info.Text = "Display: <font color='"..bc.."'><b>"..LocalPlayer.DisplayName.."</b></font>\nUser: <font color='"..bc.."'><b>"..LocalPlayer.Name.."</b></font>\nAge: <font color='"..bc.."'><b>".. (LocalPlayer.AccountAge % 365) .."d, ".. math.floor(LocalPlayer.AccountAge / 365) .."y</b></font>"

    local MainSuitePage = Instance.new("Frame", Container)
    MainSuitePage.Size, MainSuitePage.BackgroundTransparency, MainSuitePage.Visible = UDim2.new(1, 0, 1, 0), 1, false
    local PageLayout = Instance.new("ScrollingFrame", MainSuitePage)
    PageLayout.Size, PageLayout.BackgroundTransparency, PageLayout.ScrollBarThickness, PageLayout.Position = UDim2.new(1, 0, 1, -40), 1, 0, UDim2.new(0,0,0,40)
    Instance.new("UIListLayout", PageLayout).Padding = UDim.new(0, 5)

    CheckBtn.Activated:Connect(function()
        UserInfoPage.Visible = false
        MainSuitePage.Visible = true
        SearchBox.Visible = true
        Container.Position = UDim2.new(0, 120, 0, 45)
    end)

    function Win:CreateTab(name)
        local T = {Elements = {}}
        local b = Instance.new("TextButton", TabScroll)
        b.Size, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0.85, 0, 0, 30), name, Win.Theme.Main, Win.Theme.Text
        Instance.new("UICorner", b)
        
        b.Activated:Connect(function()
            for _, v in pairs(Win.Tabs) do v.b.TextColor3 = Win.Theme.Text end
            b.TextColor3 = Win.Theme.Accent
            Win.CurrentTab = T
        end)
        
        T.b = b
        table.insert(Win.Tabs, T)
        if #Win.Tabs == 1 then b.TextColor3 = Win.Theme.Accent Win.CurrentTab = T end

        function T:Button(n, ico, cb)
            local btn = Instance.new("TextButton", PageLayout)
            btn.Size, btn.BackgroundColor3, btn.Text, btn.TextColor3 = UDim2.new(0.95, 0, 0, 35), Win.Theme.Secondary, "      "..n, Win.Theme.Text
            btn.TextXAlignment = "Left"; Instance.new("UICorner", btn)
            if ico and Icons[ico] then
                local i = Instance.new("ImageLabel", btn)
                i.Size, i.Position, i.Image, i.BackgroundTransparency, i.ImageColor3 = UDim2.new(0, 20, 0, 20), UDim2.new(0, 5, 0.5, -10), Icons[ico], 1, Win.Theme.Accent
            end
            btn.Activated:Connect(cb)
            table.insert(T.Elements, {Instance = btn, Name = n:lower()})
        end

        return T
    end

    return Win
end

return Aether