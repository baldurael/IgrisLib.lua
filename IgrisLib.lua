-- GUI Custom Tanpa Library oleh Mang Nathan

-- Buat ScreenGui utama
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "IgrisCustomGUI"
gui.ResetOnSpawn = false

-- Tombol buka/tutup GUI
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "ToggleGUI"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
toggleBtn.Image = "rbxassetid://89064255145708"
toggleBtn.BackgroundTransparency = 1
toggleBtn.Draggable = true
toggleBtn.Parent = gui

-- Frame utama GUI
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = gui

-- Drag support untuk frame
local drag = Instance.new("LocalScript", mainFrame)
drag.Source = [[
local UIS = game:GetService("UserInputService")
local frame = script.Parent

local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
]]

-- Fungsi buka/tutup GUI
local toggleScript = Instance.new("LocalScript", toggleBtn)
toggleScript.Source = [[
local btn = script.Parent
local gui = btn.Parent:WaitForChild("MainFrame")

btn.MouseButton1Click:Connect(function()
	gui.Visible = not gui.Visible
end)
]]

-- Tab buttons
local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, 0, 0, 30)
tabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabHolder.BorderSizePixel = 0
tabHolder.Parent = mainFrame

local tabs = {"Main", "Bonus"}
local pages = {}

for i, name in ipairs(tabs) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 80, 1, 0)
	btn.Position = UDim2.new(0, (i-1)*90, 0, 0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	btn.TextColor3 = Color3.fromRGB(180, 180, 255)
	btn.Parent = tabHolder

	local page = Instance.new("Frame")
	page.Size = UDim2.new(1, 0, 1, -30)
	page.Position = UDim2.new(0, 0, 0, 30)
	page.BackgroundTransparency = 1
	page.Visible = (i == 1)
	page.Parent = mainFrame
	pages[name] = page

	btn.MouseButton1Click:Connect(function()
		for n, p in pairs(pages) do
			p.Visible = false
		end
		page.Visible = true
	end)
end

-- Main Tab Content
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0, 200, 0, 40)
speedBtn.Position = UDim2.new(0.5, -100, 0, 20)
speedBtn.Text = "Speed Booster"
speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.Parent = pages["Main"]

speedBtn.MouseButton1Click:Connect(function()
	local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h then h.WalkSpeed = 50 end
end)

-- Bonus Tab Content
local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0, 200, 0, 40)
jumpBtn.Position = UDim2.new(0.5, -100, 0, 20)
jumpBtn.Text = "Jump Booster"
jumpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.Parent = pages["Bonus"]

jumpBtn.MouseButton1Click:Connect(function()
	local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h then h.JumpPower = 100 end
end)
