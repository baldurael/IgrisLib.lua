--[[
    IgrisLib v2
    Dibuat khusus untuk Mang Nathan 😎
    Style: mirip OrionLib, support Tabs, Buttons, Toggles
    Author: rip_Igrissz x ChatGPT
]]

local TweenService = game:GetService("TweenService")

-- Init Global Library
getgenv().IgrisLib = {}
local IgrisLib = getgenv().IgrisLib

local function create(class, props)
	local inst = Instance.new(class)
	for i, v in pairs(props) do
		inst[i] = v
	end
	return inst
end

function IgrisLib:MakeWindow(data)
	local screenGui = create("ScreenGui", {
		Name = "IgrisUI",
		ResetOnSpawn = false,
		Parent = game:GetService("CoreGui"),
	})

	local mainFrame = create("Frame", {
		Size = UDim2.new(0, 600, 0, 400),
		Position = UDim2.new(0.5, -300, 0.5, -200),
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		Parent = screenGui
	})
	create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = mainFrame})

	local title = create("TextLabel", {
		Text = data.Name or "Igris Hub",
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(255,255,255),
		Font = Enum.Font.GothamBold,
		TextSize = 24,
		Parent = mainFrame
	})

	local tabButtons = {}
	local tabs = {}

	local tabSidebar = create("Frame", {
		Size = UDim2.new(0, 150, 1, -40),
		Position = UDim2.new(0, 0, 0, 40),
		BackgroundColor3 = Color3.fromRGB(30,30,30),
		BorderSizePixel = 0,
		Parent = mainFrame
	})

	local function makeTab(tabData)
		local tabFrame = create("Frame", {
			Size = UDim2.new(1, -150, 1, -40),
			Position = UDim2.new(0, 150, 0, 40),
			BackgroundTransparency = 1,
			Visible = false,
			Name = tabData.Name,
			Parent = mainFrame
		})

		local tabLayout = create("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = tabFrame
		})

		local tabBtn = create("TextButton", {
			Text = tabData.Name,
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			TextColor3 = Color3.new(1,1,1),
			Font = Enum.Font.Gotham,
			TextSize = 16,
			BorderSizePixel = 0,
			Parent = tabSidebar
		})
		table.insert(tabButtons, tabBtn)
		tabs[tabData.Name] = tabFrame

		tabBtn.MouseButton1Click:Connect(function()
			for _, v in pairs(tabs) do v.Visible = false end
			for _, v in pairs(tabButtons) do v.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
			tabFrame.Visible = true
			tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		end)

		return {
			AddLabel = function(text)
				create("TextLabel", {
					Text = text,
					Size = UDim2.new(1, -10, 0, 30),
					TextColor3 = Color3.new(1,1,1),
					BackgroundTransparency = 1,
					Font = Enum.Font.Gotham,
					TextSize = 14,
					Parent = tabFrame
				})
			end,

			AddButton = function(data)
				local btn = create("TextButton", {
					Text = data.Name or "Button",
					Size = UDim2.new(0, 200, 0, 30),
					BackgroundColor3 = Color3.fromRGB(50, 50, 50),
					TextColor3 = Color3.new(1,1,1),
					Font = Enum.Font.Gotham,
					TextSize = 14,
					Parent = tabFrame
				})
				create("UICorner", {Parent = btn})
				btn.MouseButton1Click:Connect(function()
					if data.Callback then data.Callback() end
				end)
			end,

			AddToggle = function(data)
				local toggle = false
				local holder = create("Frame", {
					Size = UDim2.new(0, 200, 0, 30),
					BackgroundTransparency = 1,
					Parent = tabFrame
				})
				create("TextLabel", {
					Text = data.Name or "Toggle",
					Size = UDim2.new(1, -40, 1, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = Color3.new(1,1,1),
					Font = Enum.Font.Gotham,
					TextSize = 14,
					BackgroundTransparency = 1,
					Parent = holder
				})
				local box = create("TextButton", {
					Size = UDim2.new(0, 30, 0, 30),
					Position = UDim2.new(1, -30, 0, 0),
					BackgroundColor3 = Color3.fromRGB(100, 0, 0),
					Text = "",
					Parent = holder
				})
				create("UICorner", {Parent = box})

				box.MouseButton1Click:Connect(function()
					toggle = not toggle
					box.BackgroundColor3 = toggle and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 0)
					if data.Callback then data.Callback(toggle) end
				end)
			end
		}
	end

	return {
		MakeTab = makeTab
	}
end
