--[[


╭━━━━╮╱/////╭╮////////////
╰━━╮━┃╱╱╱╱╱┃┃╱╱╱╱╱╱╱╱╱╱
╱╱╭╯╭╋━━┳━━┫┃╭┳━━┳━┳━━╮
╱╭╯╭╯┃╭╮┃━━┫╰╯┻━━┫╭┫╭╮┃
╭╯━╰━┫╰╯┣━━┃╭╮╮╱╱┃┃┃╰╯┃
╰━━━━┻━━┻━━┻╯╰╯╱╱╰╯╰━━╯
╱╱╱╱
╱╱╱╱
╭━━╮
┃╭╮┃
┃┃┃┃
╰╯╰╯


Author/Creator: SpectravaxISBACK.

20/11/2025.

]]

local Zoskron = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer and LocalPlayer:GetMouse()

-- Config storage
local CONFIG_FOLDER = "Zoskron"
local CONFIG_FILE = "Zoskron/config.json"

local function safeIsFolder(p)
    if type(isfolder) == "function" then
        return isfolder(p)
    end
    return false
end

local function safeMakeFolder(p)
    if type(makefolder) == "function" then
        pcall(makefolder, p)
    end
end

local function safeIsFile(p)
    if type(isfile) == "function" then
        return isfile(p)
    end
    return false
end

local function safeReadFile(p)
    if type(readfile) == "function" then
        return readfile(p)
    end
    return nil
end

local function safeWriteFile(p, d)
    if type(writefile) == "function" then
        pcall(writefile, p, d)
    end
end

if not safeIsFolder(CONFIG_FOLDER) then
    safeMakeFolder(CONFIG_FOLDER)
end

local function saveConfig(tbl)
    local ok, json = pcall(function()
        return HttpService:JSONEncode(tbl)
    end)
    if ok then
        safeWriteFile(CONFIG_FILE, json)
    end
end

local function loadConfig()
    if safeIsFile(CONFIG_FILE) then
        local content = safeReadFile(CONFIG_FILE)
        if content then
            local ok, tbl = pcall(function()
                return HttpService:JSONDecode(content)
            end)
            if ok and type(tbl) == "table" then
                return tbl
            end
        end
    end
    return {}
end

local Config = loadConfig()

-- Default settings
Config.Theme = Config.Theme or "Dark"
Config.BackgroundTransparency = Config.BackgroundTransparency or 0
Config.Minimized = Config.Minimized or false
Config.Values = Config.Values or {}

-- Helpers
local function tnew(props)
    local ins = Instance.new(props.Class or "Frame")
    for k, v in pairs(props) do
        if k ~= "Class" and k ~= "Parent" then
            pcall(function()
                ins[k] = v
            end)
        end
    end
    if props.Parent then
        ins.Parent = props.Parent
    end
    return ins
end

local Themes = {
    Dark = {
        Main = Color3.fromRGB(32, 32, 32),
        Sidebar = Color3.fromRGB(24, 24, 24),
        Tab = Color3.fromRGB(44, 44, 44),
        Element = Color3.fromRGB(60, 60, 60),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Placeholder = Color3.fromRGB(180, 180, 180)
    },
    Light = {
        Main = Color3.fromRGB(245, 245, 245),
        Sidebar = Color3.fromRGB(230, 230, 230),
        Tab = Color3.fromRGB(255, 255, 255),
        Element = Color3.fromRGB(220, 220, 220),
        Accent = Color3.fromRGB(0, 120, 200),
        Text = Color3.fromRGB(10, 10, 10),
        Placeholder = Color3.fromRGB(110, 110, 110)
    }
}

local CoreGui = game:GetService("CoreGui")

local function newScreenGui(name)
    local sg = Instance.new("ScreenGui")
    sg.Name = name or "ZoskronUI"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = CoreGui
    return sg
end

local function tween(instance, props, time, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Sine, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(instance, info, props)
    tw:Play()
    return tw
end

function Zoskron:CreateWindow(title)
    title = title or "ZoskronUI"
    local ScreenGui = newScreenGui(title)
    local theme = Themes[Config.Theme] or Themes.Dark

    local Main = tnew{
        Class = "Frame",
        Name = "MainWindow",
        Size = UDim2.new(0, 600, 0, 360),
        Position = UDim2.new(0.5, -300, 0.5, -180),
        BackgroundColor3 = theme.Main,
        Parent = ScreenGui,
        Active = true,
        Draggable = true
    }

    Main.BackgroundTransparency = Config.BackgroundTransparency or 0

    local TopBar = tnew{
        Class = "Frame",
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = Main
    }

    local TitleLabel = tnew{
        Class = "TextLabel",
        Name = "Title",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = theme.Text,
        Parent = TopBar
    }
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ControlsContainer = tnew{
        Class = "Frame",
        Name = "Controls",
        Size = UDim2.new(0, 300, 1, 0),
        Position = UDim2.new(1, -310, 0, 0),
        BackgroundTransparency = 1,
        Parent = TopBar
    }

    local MinBtn = tnew{
        Class = "TextButton",
        Name = "Minimize",
        Size = UDim2.new(0, 40, 0, 24),
        Position = UDim2.new(1, -40, 0, 6),
        BackgroundColor3 = theme.Element,
        Text = "-",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = theme.Text,
        Parent = TopBar
    }
    MinBtn.Modal = false

    local ThemeBtn = tnew{
        Class = "TextButton",
        Name = "ThemeBtn",
        Size = UDim2.new(0, 80, 0, 24),
        Position = UDim2.new(1, -150, 0, 6),
        BackgroundColor3 = theme.Element,
        Text = Config.Theme .. " Theme",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = theme.Text,
        Parent = TopBar
    }

    local BgLabel = tnew{
        Class = "TextLabel",
        Name = "BgLabel",
        Size = UDim2.new(0, 110, 0, 24),
        Position = UDim2.new(1, -260, 0, 6),
        BackgroundTransparency = 1,
        Text = "BG Trans:",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = theme.Text,
        Parent = TopBar
    }
    BgLabel.TextXAlignment = Enum.TextXAlignment.Right

    local BgValueLabel = tnew{
        Class = "TextLabel",
        Name = "BgVal",
        Size = UDim2.new(0, 40, 0, 24),
        Position = UDim2.new(1, -145, 0, 6),
        BackgroundColor3 = theme.Element,
        Text = tostring(math.floor((Main.BackgroundTransparency * 100))) .. "%",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = theme.Text,
        Parent = TopBar
    }
    BgValueLabel.TextXAlignment = Enum.TextXAlignment.Center

    local SaveCfgBtn = tnew{
        Class = "TextButton",
        Name = "SaveCfg",
        Size = UDim2.new(0, 40, 0, 24),
        Position = UDim2.new(1, -200, 0, 6),
        BackgroundColor3 = theme.Element,
        Text = "Save",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = theme.Text,
        Parent = TopBar
    }

    local Sidebar = tnew{
        Class = "Frame",
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, -36),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = theme.Sidebar,
        Parent = Main
    }

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 6)
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local SearchBox = tnew{
        Class = "TextBox",
        Name = "SearchBox",
        Size = UDim2.new(1, -12, 0, 28),
        Position = UDim2.new(0, 6, 0, 6),
        BackgroundColor3 = theme.Element,
        Text = "",
        PlaceholderText = "Search tabs...",
        Font = Enum.Font.Gotham,
        TextColor3 = theme.Text,
        Parent = Sidebar
    }
    SearchBox.PlaceholderTextColor3 = theme.Placeholder

    local Pages = tnew{
        Class = "Folder",
        Name = "Pages",
        Parent = Main
    }

    local PagesFrame = tnew{
        Class = "Frame",
        Name = "PagesFrame",
        Size = UDim2.new(1, -150, 1, -36),
        Position = UDim2.new(0, 150, 0, 36),
        BackgroundColor3 = theme.Tab,
        Parent = Main
    }

    local PagesLayout = Instance.new("UIListLayout", PagesFrame)
    PagesLayout.Padding = UDim.new(0, 8)
    PagesLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function setMinimized(state)
        Config.Minimized = state
        saveConfig(Config)
        if state then
            tween(PagesFrame, { Size = UDim2.new(1, -150, 0, 0) }, 0.25)
            tween(Sidebar, { Size = UDim2.new(0, 150, 1, 0) }, 0.25)
            tween(Main, { Size = UDim2.new(0, 600, 0, 36) }, 0.25)
        else
            tween(Main, { Size = UDim2.new(0, 600, 0, 360) }, 0.25)
            tween(PagesFrame, { Size = UDim2.new(1, -150, 1, -36) }, 0.25)
            tween(Sidebar, { Size = UDim2.new(0, 150, 1, -36) }, 0.25)
        end
    end

    if Config.Minimized then
        setMinimized(true)
    end

    MinBtn.MouseButton1Click:Connect(function()
        setMinimized(not Config.Minimized)
    end)

    ThemeBtn.MouseButton1Click:Connect(function()
        if Config.Theme == "Dark" then
            Config.Theme = "Light"
        else
            Config.Theme = "Dark"
        end
        theme = Themes[Config.Theme]
        Main.BackgroundColor3 = theme.Main
        Sidebar.BackgroundColor3 = theme.Sidebar
        PagesFrame.BackgroundColor3 = theme.Tab
        TitleLabel.TextColor3 = theme.Text
        SearchBox.TextColor3 = theme.Text
        SearchBox.PlaceholderTextColor3 = theme.Placeholder
        ThemeBtn.Text = Config.Theme .. " Theme"
        BgValueLabel.TextColor3 = theme.Text
        BgLabel.TextColor3 = theme.Text
        SaveCfgBtn.TextColor3 = theme.Text
        MinBtn.TextColor3 = theme.Text
        saveConfig(Config)
    end)

    BgValueLabel.MouseButton1Click:Connect(function()
        local nv = math.clamp(Main.BackgroundTransparency - 0.1, 0, 1)
        Main.BackgroundTransparency = nv
        Config.BackgroundTransparency = nv
        BgValueLabel.Text = tostring(math.floor((nv * 100))) .. "%"
        saveConfig(Config)
    end)

    BgValueLabel.MouseButton2Click:Connect(function()
        local nv = math.clamp(Main.BackgroundTransparency + 0.1, 0, 1)
        Main.BackgroundTransparency = nv
        Config.BackgroundTransparency = nv
        BgValueLabel.Text = tostring(math.floor((nv * 100))) .. "%"
        saveConfig(Config)
    end)

    SaveCfgBtn.MouseButton1Click:Connect(function()
        saveConfig(Config)
    end)

    local function notify(title, text, time)
        time = time or 2
        local N = tnew{
            Class = "Frame",
            Name = "Notification",
            Size = UDim2.new(0, 300, 0, 48),
            Position = UDim2.new(1, -310, 1, -60),
            BackgroundColor3 = theme.Element,
            Parent = ScreenGui
        }
        local NL = tnew{
            Class = "TextLabel",
            Name = "NL",
            Size = UDim2.new(1, -12, 1, -12),
            Position = UDim2.new(0, 6, 0, 6),
            BackgroundTransparency = 1,
            Text = "[" .. title .. "] " .. text,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = theme.Text,
            Parent = N
        }
        N.AnchorPoint = Vector2.new(1, 1)
        N.Position = UDim2.new(1, -10, 1, -10)
        N.BackgroundTransparency = 1
        tween(N, { BackgroundTransparency = 0 }, 0.15)
        task.spawn(function()
            task.wait(time)
            tween(N, { BackgroundTransparency = 1 }, 0.15)
            task.wait(0.2)
            pcall(function()
                N:Destroy()
            end)
        end)
    end

    local tabs = {}

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(SearchBox.Text or "")
        for _, v in pairs(tabs) do
            local name = string.lower(v.Name or "")
            v.Button.Visible = (q == "" or string.find(name, q) ~= nil)
        end
    end)

    local WindowAPI = {}

    function WindowAPI:MakeTab(opts)
        opts = opts or {}
        local tabName = opts.Name or ("Tab" .. tostring(#tabs + 1))

        local btn = tnew{
            Class = "TextButton",
            Name = tabName .. "_Btn",
            Size = UDim2.new(1, -12, 0, 30),
            BackgroundColor3 = theme.Element,
            Text = tabName,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = theme.Text,
            Parent = Sidebar
        }
        btn.AutoButtonColor = true

        local page = tnew{
            Class = "Frame",
            Name = tabName .. "_Page",
            Size = UDim2.new(1, -20, 0, 200),
            BackgroundTransparency = 1,
            Parent = PagesFrame
        }

        local pInner = tnew{
            Class = "Frame",
            Name = "Inner",
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = theme.Tab,
            Parent = page
        }

        local innerLayout = Instance.new("UIListLayout", pInner)
        innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        innerLayout.Padding = UDim.new(0, 8)

        page.Visible = false

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages:GetChildren()) do
                p.Visible = false
            end
            page.Visible = true
        end)

        if #tabs == 0 then
            btn:CaptureFocus()
            btn:ReleaseFocus()
            btn.MouseButton1Click:Fire()
            page.Visible = true
        end

        local tabObj = {
            Name = tabName,
            Button = btn,
            Page = page,
            Inner = pInner
        }

        function tabObj:AddButton(info)
            info = info or {}
            local b = tnew{
                Class = "TextButton",
                Name = (info.Name or "Button"),
                Size = UDim2.new(1, -16, 0, 36),
                BackgroundColor3 = theme.Element,
                Text = (info.Name or "Button"),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = theme.Text,
                Parent = pInner
            }
            b.MouseButton1Click:Connect(function()
                if info.Callback then
                    pcall(info.Callback)
                end
            end)
            return b
        end

        function tabObj:AddToggle(info)
            info = info or {}
            local id = info.Flag or (tabName .. "_" .. (info.Name or "Toggle"))
            if Config.Values[id] == nil then
                Config.Values[id] = info.Default == true
            end

            local frame = tnew{
                Class = "Frame",
                Size = UDim2.new(1, -16, 0, 36),
                BackgroundColor3 = theme.Tab,
                Parent = pInner
            }

            local label = tnew{
                Class = "TextLabel",
                Text = info.Name or "Toggle",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.75, 0, 1, 0),
                TextColor3 = theme.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                Parent = frame
            }

            local btn = tnew{
                Class = "TextButton",
                Size = UDim2.new(0.2, 0, 0, 24),
                Position = UDim2.new(0.78, 0, 0.1, 0),
                BackgroundColor3 = (Config.Values[id] and Themes[Config.Theme].Accent or Color3.fromRGB(120, 0, 0)),
                Text = "",
                Parent = frame
            }

            btn.MouseButton1Click:Connect(function()
                Config.Values[id] = not Config.Values[id]
                btn.BackgroundColor3 = (Config.Values[id] and Themes[Config.Theme].Accent or Color3.fromRGB(120, 0, 0))
                saveConfig(Config)
                if info.Callback then
                    pcall(info.Callback, Config.Values[id])
                end
            end)

            return { Frame = frame, Button = btn, Label = label }
        end

        function tabObj:AddSlider(info)
            info = info or {}
            local id = info.Flag or (tabName .. "_" .. (info.Name or "Slider"))
            local min = info.Min or 0
            local max = info.Max or 100
            local default = info.Default or min
            if Config.Values[id] == nil then
                Config.Values[id] = default
            end

            local frame = tnew{
                Class = "Frame",
                Size = UDim2.new(1, -16, 0, 52),
                BackgroundColor3 = theme.Tab,
                Parent = pInner
            }

            local label = tnew{
                Class = "TextLabel",
                Text = (info.Name or "Slider") .. " : " .. tostring(Config.Values[id]),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                TextColor3 = theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                Parent = frame
            }

            local bar = tnew{
                Class = "Frame",
                Size = UDim2.new(1, -20, 0, 10),
                Position = UDim2.new(0, 10, 0, 26),
                BackgroundColor3 = Color3.fromRGB(90, 90, 90),
                Parent = frame
            }

            local fill = tnew{
                Class = "Frame",
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Themes[Config.Theme].Accent,
                Parent = bar
            }

            local function setFillFromValue(v)
                local pct = 0
                if max > min then
                    pct = (v - min) / (max - min)
                end
                fill.Size = UDim2.new(pct, 0, 1, 0)
                label.Text = (info.Name or "Slider") .. " : " .. tostring(math.floor(v))
            end

            setFillFromValue(Config.Values[id])

            local dragging = false
            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            bar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            RunService.RenderStepped:Connect(function()
                if dragging and mouse then
                    local x = math.clamp((mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local val = min + (max - min) * x
                    Config.Values[id] = math.floor(val)
                    setFillFromValue(Config.Values[id])
                    if info.Callback then
                        pcall(info.Callback, Config.Values[id])
                    end
                end
            end)

            return { Frame = frame, Set = function(v)
                Config.Values[id] = v
                setFillFromValue(v)
                saveConfig(Config)
            end }
        end

        function tabObj:AddDropdown(info)
            info = info or {}
            local id = info.Flag or (tabName .. "_" .. (info.Name or "Dropdown"))
            local options = info.Options or {}
            if Config.Values[id] == nil and #options > 0 then
                Config.Values[id] = options[1]
            end

            local frame = tnew{
                Class = "Frame",
                Size = UDim2.new(1, -16, 0, 36),
                BackgroundColor3 = theme.Tab,
                Parent = pInner
            }

            local button = tnew{
                Class = "TextButton",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = theme.Element,
                Text = (info.Name or "Select") .. " : " .. tostring(Config.Values[id] or ""),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = theme.Text,
                Parent = frame
            }

            local list = tnew{
                Class = "Frame",
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = theme.Tab,
                Parent = frame
            }
            list.Visible = false

            local ll = Instance.new("UIListLayout", list)
            ll.Padding = UDim.new(0, 4)
            ll.SortOrder = Enum.SortOrder.LayoutOrder

            for _, opt in ipairs(options) do
                local it = tnew{
                    Class = "TextButton",
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = theme.Element,
                    Text = tostring(opt),
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextColor3 = theme.Text,
                    Parent = list
                }
                it.MouseButton1Click:Connect(function()
                    Config.Values[id] = opt
                    button.Text = (info.Name or "Select") .. " : " .. tostring(opt)
                    list.Visible = false
                    saveConfig(Config)
                    if info.Callback then
                        pcall(info.Callback, opt)
                    end
                end)
            end

            button.MouseButton1Click:Connect(function()
                list.Visible = not list.Visible
                local count = #options
                if list.Visible then
                    list.Size = UDim2.new(1, 0, 0, math.clamp(count * 34, 0, 200))
                else
                    list.Size = UDim2.new(1, 0, 0, 0)
                end
            end)

            return { Frame = frame, Button = button }
        end

        function tabObj:AddKeybind(info)
            info = info or {}
            local id = info.Flag or (tabName .. "_" .. (info.Name or "Key"))
            if Config.Values[id] == nil then
                Config.Values[id] = "None"
            end

            local frame = tnew{
                Class = "Frame",
                Size = UDim2.new(1, -16, 0, 36),
                BackgroundColor3 = theme.Tab,
                Parent = pInner
            }

            local label = tnew{
                Class = "TextLabel",
                Text = info.Name or "Keybind",
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                TextColor3 = theme.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                Parent = frame
            }

            local btn = tnew{
                Class = "TextButton",
                Text = tostring(Config.Values[id]),
                Size = UDim2.new(0.35, 0, 0, 24),
                Position = UDim2.new(0.62, 0, 0.1, 0),
                BackgroundColor3 = theme.Element,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = theme.Text,
                Parent = frame
            }

            local waiting = false
            btn.MouseButton1Click:Connect(function()
                waiting = true
                btn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, gp)
                if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
                    waiting = false
                    Config.Values[id] = tostring(input.KeyCode)
                    btn.Text = Config.Values[id]
                    saveConfig(Config)
                elseif not gp then
                    if Config.Values[id] and tostring(input.KeyCode) == Config.Values[id] then
                        if info.Callback then
                            pcall(info.Callback)
                        end
                    end
                end
            end)

            return { Frame = frame, Button = btn }
        end

        function tabObj:AddTextbox(info)
            info = info or {}
            local frame = tnew{
                Class = "Frame",
                Size = UDim2.new(1, -16, 0, 36),
                BackgroundColor3 = theme.Tab,
                Parent = pInner
            }
            local box = tnew{
                Class = "TextBox",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = theme.Element,
                Text = "",
                PlaceholderText = (info.Placeholder or ""),
                TextColor3 = theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Parent = frame
            }
            box.PlaceholderTextColor3 = theme.Placeholder
            box.FocusLost:Connect(function(enter)
                if info.Callback and enter then
                    pcall(info.Callback, box.Text)
                end
            end)
            return box
        end

        function tabObj:Notify(titl, txt, tm)
            notify(titl, txt, tm)
        end

        table.insert(tabs, tabObj)
        Pages[tabName] = page

        return tabObj
    end

    spawn(function()
        while ScreenGui.Parent do
            saveConfig(Config)
            task.wait(8)
        end
    end)

    function WindowAPI:SetTheme(name)
        if Themes[name] then
            Config.Theme = name
            saveConfig(Config)
            ThemeBtn.Text = name .. " Theme"
            ThemeBtn:CaptureFocus()
            ThemeBtn:ReleaseFocus()
        end
    end

    function WindowAPI:GetConfig()
        return Config
    end

    function WindowAPI:Notify(t, m, tm)
        notify(t, m, tm)
    end

    WindowAPI.ScreenGui = ScreenGui
    WindowAPI.Main = Main
    WindowAPI.Sidebar = Sidebar
    WindowAPI.PagesFrame = PagesFrame

    return WindowAPI
end

return Zoskron
