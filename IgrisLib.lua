-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variables
local SavedLocations = {}
local currentLocationName = ""
local flying = false
local flyVelocity, flyGyro

-- Window
local Window = Rayfield:CreateWindow({
    Name = "Igris hub - Steal A Script🥷 https://discord.gg/dBp5KpsC",
    LoadingTitle = "Igris Hub",
    LoadingSubtitle = "by rip_Igrissz",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "IgrisHub",
        FileName = "Config"
    },
    Discord = {Enabled = false},
    KeySystem = false
})

---------------------
-- Main Tab
---------------------
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateInput({
    Name = "Location Name",
    PlaceholderText = "Enter location name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        currentLocationName = Text
    end,
})

MainTab:CreateButton({
    Name = "Set Location (with ESP)",
    Callback = function()
        if currentLocationName ~= "" then
            SavedLocations[currentLocationName] = hrp.Position
            local part = Instance.new("Part", workspace)
            part.Anchored = true
            part.CanCollide = false
            part.Size = Vector3.new(2,2,2)
            part.Position = hrp.Position
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(255, 0, 0)
            part.Transparency = 0.3
            part.Name = "ESP_" .. currentLocationName

            local gui = Instance.new("BillboardGui", part)
            gui.Size = UDim2.new(0,200,0,50)
            gui.AlwaysOnTop = true
            local label = Instance.new("TextLabel", gui)
            label.Size = UDim2.new(1,0,1,0)
            label.BackgroundTransparency = 1
            label.Text = currentLocationName
            label.TextColor3 = Color3.new(1,1,1)
            label.TextScaled = true
        end
    end,
})

local locDropdown = MainTab:CreateDropdown({
    Name = "Saved Locations",
    Options = {},
    CurrentOption = "",
    Callback = function(Value)
        currentLocationName = Value
    end,
})

MainTab:CreateButton({
    Name = "🔄 Refresh Locations",
    Callback = function()
        local keys = {}
        for name in pairs(SavedLocations) do
            table.insert(keys, name)
        end
        locDropdown:Refresh(keys)
    end,
})

MainTab:CreateButton({
    Name = "Goto Location",
    Callback = function()
        if currentLocationName ~= "" and SavedLocations[currentLocationName] then
            hrp.CFrame = CFrame.new(SavedLocations[currentLocationName])
        end
    end,
})

MainTab:CreateButton({
    Name = "Goto Random Player",
    Callback = function()
        local players = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(players, p)
            end
        end
        if #players > 0 then
            local chosen = players[math.random(1, #players)]
            hrp.CFrame = chosen.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end,
})

MainTab:CreateToggle({
    Name = "Anti Ragdoll",
    Default = false,
    Callback = function(state)
        if state then
            for _, v in ipairs(character:GetDescendants()) do
                if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint") then
                    v:Destroy()
                end
            end
        end
    end,
})

MainTab:CreateToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(state)
        if state then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        else
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end,
})

---------------------
-- Visual Tab
---------------------
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateToggle({
    Name = "Speed Boost",
    Default = false,
    Callback = function(state)
        humanoid.WalkSpeed = state and 60 or 16
    end,
})

VisualTab:CreateToggle({
    Name = "Jump Boost",
    Default = false,
    Callback = function(state)
        humanoid.JumpPower = state and 120 or 50
    end,
})

---------------------
-- Bonus Tab
---------------------
local BonusTab = Window:CreateTab("Bonus", 4483362458)

BonusTab:CreateToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        local conn
        if state then
            conn = RunService.Stepped:Connect(function()
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        else
            if conn then conn:Disconnect() end
        end
    end,
})

BonusTab:CreateToggle({
    Name = "Fly (press E to toggle)",
    Default = false,
    Callback = function(state)
        flying = state
        if flying then
            flyVelocity = Instance.new("BodyVelocity", hrp)
            flyGyro = Instance.new("BodyGyro", hrp)
            flyVelocity.Velocity = Vector3.zero
            flyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            flyGyro.CFrame = hrp.CFrame
            UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.E then
                    flying = not flying
                    if not flying then
                        if flyVelocity then flyVelocity:Destroy() end
                        if flyGyro then flyGyro:Destroy() end
                    end
                end
            end)
            RunService.Heartbeat:Connect(function()
                if flying and flyVelocity and flyGyro then
                    local cam = workspace.CurrentCamera.CFrame
                    flyVelocity.Velocity = cam.LookVector * 70
                    flyGyro.CFrame = cam
                end
            end)
        else
            if flyVelocity then flyVelocity:Destroy() end
            if flyGyro then flyGyro:Destroy() end
        end
    end,
})
