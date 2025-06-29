-- IgrisLib.lua - Custom GUI Library dengan Icon
-- Dibuat oleh baldurael - versi standalone

getgenv().IgrisLib = {}

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IgrisLibUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 360)
MainFrame.Position = UDim2.new(0, 50, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Draggable
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
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- UICorner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "IgrisHub UI"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Parent = MainFrame

-- Logo Icon
local Icon = Instance.new("ImageLabel")
Icon.Size = UDim2.new(0, 40, 0, 40)
Icon.Position = UDim2.new(0, -45, 0, 0)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://89064255145708" -- Ganti dengan ID decal kamu
Icon.Parent = MainFrame

-- Notify Function
function IgrisLib.Notify(text)
	game.StarterGui:SetCore("SendNotification", {
		Title = "IgrisLib",
		Text = tostring(text),
		Duration = 5
	})
end

-- Button Utility
function IgrisLib.CreateButton(name, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, #MainFrame:GetChildren() * 0.1 + 0.1)
	button.Text = name
	button.Font = Enum.Font.Gotham
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextScaled = true
	button.Parent = MainFrame

	local corner = Instance.new("UICorner")
	corner.Parent = button

	button.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
end

-- Contoh Pemakaian Internal
IgrisLib.CreateButton("Tampilkan Notifikasi", function()
	IgrisLib.Notify("Halo dari IgrisLib!")
end)

IgrisLib.CreateButton("Speed +", function()
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h then
		h.WalkSpeed = h.WalkSpeed + 10
		IgrisLib.Notify("Speed: " .. h.WalkSpeed)
	end
end)

IgrisLib.CreateButton("Speed -", function()
	local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if h then
		h.WalkSpeed = h.WalkSpeed - 10
		IgrisLib.Notify("Speed: " .. h.WalkSpeed)
	end
end)

-- Final Message
IgrisLib.Notify("IgrisLib berhasil dimuat!")
