-- ✅ IgrisLib v3.1 Beta (Fix GUI, Add Dropdown, Complete) -- Created for Mang Nathan

local TweenService = game:GetService("TweenService") local CoreGui = game:GetService("CoreGui") getgenv().Igris = {} local Igris = getgenv().Igris

Igris.Flags = {}

local function create(c, p) local inst = Instance.new(c) for k, v in pairs(p or {}) do inst[k] = v end return inst end

function Igris:MakeWindow(data) local screen = create("ScreenGui", { Name = "IgrisLibV3", ResetOnSpawn = false, Parent = CoreGui:FindFirstChild("IgrisLibV3") or CoreGui })

local main = create("Frame", {
    Size = UDim2.new(0, 600, 0, 400),
    Position = UDim2.new(0.5, -300, 0.5, -200),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    Parent = screen
})
create("UICorner", {Parent = main})

local tabSide = create("Frame", {
    Size = UDim2.new(0, 150, 1, -40),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    Parent = main
})

local tabs, buttons = {}, {}

local function selectTab(name, btn)
    for _, tf in pairs(tabs) do tf.Visible = false end
    for _, b in pairs(buttons) do b.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
    tabs[name].Visible = true
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end

return {
    MakeTab = function(tabData)
        local tabf = create("Frame", {
            Name = tabData.Name,
            Size = UDim2.new(1, -150, 1, -40),
            Position = UDim2.new(0, 150, 0, 40),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = main
        })
        tabs[tabData.Name] = tabf

        local btn = create("TextButton", {
            Text = tabData.Name,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.Gotham,
            TextSize = 16,
            Parent = tabSide
        })
        buttons[tabData.Name] = btn

        btn.MouseButton1Click:Connect(function()
            selectTab(tabData.Name, btn)
        end)

        create("UIListLayout", {
            Parent = tabf,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local function addButton(data)
            local b = create("TextButton", {
                Text = data.Name or "Button",
                Size = UDim2.new(0, 200, 0, 30),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Parent = tabf
            })
            create("UICorner", {Parent = b})
            b.MouseButton1Click:Connect(data.Callback or function() end)
        end

        local function addToggle(data)
            local f = create("Frame", {
                Size = UDim2.new(0, 200, 0, 30),
                BackgroundTransparency = 1,
                Parent = tabf
            })
            create("TextLabel", {
                Text = data.Name or "Toggle",
                Size = UDim2.new(1, -40, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Parent = f
            })
            local btn = create("TextButton", {
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -30, 0, 0),
                BackgroundColor3 = Color3.fromRGB(100, 0, 0),
                Parent = f
            })
            create("UICorner", {Parent = btn})
            Igris.Flags[data.Flag or data.Name] = {Value = data.Default or false}
            btn.MouseButton1Click:Connect(function()
                local v = not Igris.Flags[data.Flag].Value
                Igris.Flags[data.Flag].Value = v
                btn.BackgroundColor3 = v and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 0)
                if data.Callback then data.Callback(v) end
            end)
            if data.Default then btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0) end
        end

        local function addSlider(data)
            local f = create("Frame", {Size = UDim2.new(0, 200, 0, 30), BackgroundTransparency = 1, Parent = tabf})
            create("TextLabel", {
                Text = data.Name or "Slider",
                Size = UDim2.new(1, -50, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Parent = f
            })
            local tb = create("TextBox", {
                Size = UDim2.new(0, 50, 1, 0),
                Position = UDim2.new(1, -50, 0, 0),
                Text = tostring(data.Default),
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                Parent = f
            })
            create("UICorner", {Parent = tb})
            Igris.Flags[data.Flag or data.Name] = {Value = data.Default}
            tb.FocusLost:Connect(function()
                local num = tonumber(tb.Text)
                if num then
                    num = math.clamp(num, data.Min or 0, data.Max or num)
                    tb.Text = tostring(num)
                    Igris.Flags[data.Flag].Value = num
                    if data.Callback then data.Callback(num) end
                else
                    tb.Text = tostring(Igris.Flags[data.Flag].Value)
                end
            end)
        end

        local function addTextbox(data)
            local tb = create("TextBox", {
                Text = data.Default or "",
                Size = UDim2.new(0, 200, 0, 30),
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                Parent = tabf
            })
            create("UICorner", {Parent = tb})
            tb.FocusLost:Connect(function()
                if data.Callback then data.Callback(tb.Text) end
                if data.TextDisappear then tb.Text = "" end
            end)
        end

        local dropdownRef
        local function addDropdown(data)
            local label = create("TextLabel", {
                Text = data.Name or "Dropdown",
                Size = UDim2.new(0, 200, 0, 20),
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Parent = tabf
            })
            local box = create("TextButton", {
                Text = data.Default or "",
                Size = UDim2.new(0, 200, 0, 30),
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                Parent = tabf
            })
            create("UICorner", {Parent = box})
            local options = data.Options or {}
            box.MouseButton1Click:Connect(function()
                -- cycle next
                local i = table.find(options, box.Text) or 0
                local new = options[(i % #options) + 1]
                box.Text = new
                if data.Callback then data.Callback(new) end
            end)
            dropdownRef = {
                Refresh = function(newOptions, reset)
                    options = newOptions
                    if reset then
                        box.Text = newOptions[1] or ""
                        if data.Callback then data.Callback(box.Text) end
                    end
                end
            }
        end

        tabf.AddButton = addButton
        tabf.AddToggle = addToggle
        tabf.AddSlider = addSlider
        tabf.AddTextbox = addTextbox
        tabf.AddDropdown = addDropdown
        return tabf
    end
}

end

function Igris:MakeNotification(data) local notif = create("ScreenGui", {Parent = CoreGui}) local frame = create("Frame", { Size = UDim2.new(0, 300, 0, 50), Position = UDim2.new(0.5, -150, 0, 50), BackgroundColor3 = Color3.fromRGB(30, 30, 30), Parent = notif }) create("UICorner", {Parent = frame}) create("TextLabel", { Text = data.Name, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 16, Parent = frame }) create("TextLabel", { Text = data.Content, Position = UDim2.new(0, 0, 0, 25), Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.Gotham, TextSize = 14, Parent = frame }) task.delay(data.Time or 3, function() notif:Destroy() end) end

function Igris:Destroy() for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "IgrisLibV3" then v:Destroy() end end end

function Igris:Init() -- Init placeholder for future setup end

