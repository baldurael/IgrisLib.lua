--// GUI Setup
local Player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "CustomHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Tabs = {"Main", "Visual", "Bonus"}
local Buttons = {}
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -100, 1, -10)
ContentFrame.Position = UDim2.new(0, 90, 0, 10)
ContentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ContentFrame.BorderSizePixel = 0

--// Tab Buttons
for i, tabName in ipairs(Tabs) do
	local TabBtn = Instance.new("TextButton", MainFrame)
	TabBtn.Size = UDim2.new(0, 80, 0, 30)
	TabBtn.Position = UDim2.new(0, 5, 0, 10 + (i - 1) * 35)
	TabBtn.Text = tabName
	TabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	TabBtn.TextColor3 = Color3.new(1, 1, 1)
	TabBtn.BorderSizePixel = 0

	Buttons[tabName] = TabBtn
end

--// Utility
function ClearContent()
	for _, child in ipairs(ContentFrame:GetChildren()) do
		if not child:IsA("UIListLayout") then
			child:Destroy()
		end
	end
end

function CreateButton(name, callback)
	local Btn = Instance.new("TextButton", ContentFrame)
	Btn.Size = UDim2.new(1, -10, 0, 30)
	Btn.Text = name
	Btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	Btn.TextColor3 = Color3.new(1,1,1)
	Btn.BorderSizePixel = 0
	Btn.MouseButton1Click:Connect(callback)
end

--// GUI Scale Slider
local function CreateSlider(name)
	local Text = Instance.new("TextLabel", ContentFrame)
	Text.Text = name
	Text.Size = UDim2.new(1, -10, 0, 20)
	Text.TextColor3 = Color3.new(1,1,1)
	Text.BackgroundTransparency = 1

	local Slider = Instance.new("TextButton", ContentFrame)
	Slider.Size = UDim2.new(1, -10, 0, 30)
	Slider.Text = "Adjust GUI Scale"
	Slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	Slider.TextColor3 = Color3.new(1,1,1)
	Slider.MouseButton1Click:Connect(function()
		MainFrame.Size = MainFrame.Size + UDim2.new(0, 20, 0, 20)
	end)
end

--// Tab Functions
local function OpenTab(tabName)
	ClearContent()

	if tabName == "Main" then
		CreateButton("Exit", function()
			ScreenGui:Destroy()
		end)

		CreateButton("Lock Base", function()
			print("Base locked!")
		end)

		CreateButton("Anti Steal", function()
			print("Anti Steal Activated!")
		end)

		CreateSlider("GUI Scale")

	elseif tabName == "Visual" then
		CreateButton("Steal Helper 50", function()
			print("Helped steal 50!")
		end)

		CreateButton("Steal Helper 100", function()
			print("Helped steal 100!")
		end)

		CreateButton("Show Player", function()
			for _, plr in ipairs(game.Players:GetPlayers()) do
				if plr ~= Player then
					print("Player found:", plr.Name)
				end
			end
		end)

		CreateButton("Speed Booster", function()
			Player.Character.Humanoid.WalkSpeed = 50
		end)

	elseif tabName == "Bonus" then
		CreateButton("Jump Booster", function()
			Player.Character.Humanoid.JumpPower = 100
		end)
	end
end

--// Tab Click Events
for tabName, button in pairs(Buttons) do
	button.MouseButton1Click:Connect(function()
		OpenTab(tabName)
	end)
end

-- Default to open Main tab
OpenTab("Main")
