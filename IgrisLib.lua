-- IgrisLib.lua - Dibuat oleh baldurael

getgenv().IgrisLib = {}

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IgrisLibUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 360)
MainFrame.Position = UDim2.new(0, 80, 0, 120)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 50, 0, 50)
Logo.Position = UDim2.new(0, 10, 0, 10)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://89064255145708" -- Gambar logo kamu
Logo.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "IgrisHub"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 70, 0, 10)
Title.Size = UDim2.new(1, -80, 0, 50)
Title.Parent = MainFrame

-- Tab Holder
local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(0, 110, 1, -70)
TabHolder.Position = UDim2.new(0, 10, 0, 60)
TabHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabHolder.Parent = MainFrame
Instance.new("UICorner", TabHolder).CornerRadius = UDim.new(0, 8)

local Tabs = {}
local CurrentTab

function IgrisLib:CreateTab(name)
	local TabButton = Instance.new("TextButton")
	TabButton.Size = UDim2.new(1, -10, 0, 40)
	TabButton.Position = UDim2.new(0, 5, 0, #TabHolder:GetChildren() * 45)
	TabButton.Text = name
	TabButton.Font = Enum.Font.Gotham
	TabButton.TextScaled = true
	TabButton.TextColor3 = Color3.new(1,1,1)
	TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	TabButton.Parent = TabHolder
	Instance.new("UICorner", TabButton)

	local Page = Instance.new("ScrollingFrame")
	Page.Size = UDim2.new(1, -140, 1, -70)
	Page.Position = UDim2.new(0, 130, 0, 60)
	Page.CanvasSize = UDim2.new(0, 0, 5, 0)
	Page.ScrollBarThickness = 4
	Page.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Page.Visible = false
	Page.Parent = MainFrame
	Instance.new("UICorner", Page)

	Tabs[name] = Page

	TabButton.MouseButton1Click:Connect(function()
		if CurrentTab then CurrentTab.Visible = false end
		Page.Visible = true
		CurrentTab = Page
	end)

	return {
		AddButton = function(self, text, callback)
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, -20, 0, 40)
			Btn.Position = UDim2.new(0, 10, 0, #Page:GetChildren() * 45)
			Btn.Text = text
			Btn.Font = Enum.Font.Gotham
			Btn.TextColor3 = Color3.new(1,1,1)
			Btn.TextScaled = true
			Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Btn.Parent = Page
			Instance.new("UICorner", Btn)

			Btn.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end,
		AddToggle = function(self, text, callback)
			local ToggleBtn = Instance.new("TextButton")
			ToggleBtn.Size = UDim2.new(1, -20, 0, 40)
			ToggleBtn.Position = UDim2.new(0, 10, 0, #Page:GetChildren() * 45)
			ToggleBtn.Text = text .. ": OFF"
			ToggleBtn.Font = Enum.Font.Gotham
			ToggleBtn.TextScaled = true
			ToggleBtn.TextColor3 = Color3.new(1,1,1)
			ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			ToggleBtn.Parent = Page
			Instance.new("UICorner", ToggleBtn)

			local state = false
			ToggleBtn.MouseButton1Click:Connect(function()
				state = not state
				ToggleBtn.Text = text .. ": " .. (state and "ON" or "OFF")
				pcall(callback, state)
			end)
		end
	}
end

-- Notification Function
function IgrisLib:Notify(text)
	game.StarterGui:SetCore("SendNotification", {
		Title = "IgrisLib",
		Text = tostring(text),
		Duration = 5
	})
end

-- Drag System
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Auto message
IgrisLib:Notify("IgrisLib berhasil dimuat!")
