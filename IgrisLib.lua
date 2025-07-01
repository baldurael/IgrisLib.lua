-- [IgrisHub Loader] by Mang Nathan
local Igris = loadstring(game:HttpGet("https://raw.githubusercontent.com/NAMA-KAMU/IgrisLib.lua/main/IgrisLib.lua"))()

local Window = Igris:CreateWindow({
    Name = "🌱 IGRIS HUB | Grow a Garden",
    Logo = "rbxassetid://123456789", -- Ganti logo kamu
    SaveConfig = true,
    Folder = "IgrisHubConfig"
})

local AutoTab = Window:CreateTab("🌾 Auto", "rbxassetid://6023426915")
local TpTab = Window:CreateTab("🗺️ Teleport", "rbxassetid://6026568198")

local autoWater = false
local autoHarvest = false
local autoGacha = false
local autoUnlock = false

-- Auto toggles
AutoTab:CreateToggle("Auto Siram", false, function(v) autoWater = v end)
AutoTab:CreateToggle("Auto Panen", false, function(v) autoHarvest = v end)
AutoTab:CreateToggle("Auto Gacha", false, function(v) autoGacha = v end)
AutoTab:CreateToggle("Auto Unlock", false, function(v) autoUnlock = v end)

-- Teleport example
TpTab:CreateButton("Ke Farm", function()
    local char = game.Players.LocalPlayer.Character
    if char then
        char:PivotTo(CFrame.new(100, 10, -50)) -- Ganti posisi real
    end
end)

-- Main auto loop
task.spawn(function()
    local player = game.Players.LocalPlayer
    local garden = workspace:WaitForChild("Gardens"):FindFirstChild(player.Name)
    local rs = game:GetService("ReplicatedStorage")

    local Water = rs:WaitForChild("WaterPlant")
    local Harvest = rs:WaitForChild("HarvestPlant")
    local Hatch = rs:WaitForChild("HatchPet")
    local Unlock = rs:WaitForChild("UnlockPlot")

    while task.wait(2) do
        if garden then
            for _, plant in pairs(garden:GetDescendants()) do
                if plant:IsA("Model") and plant:FindFirstChild("PlantStage") then
                    local stage = plant.PlantStage.Value
                    if autoWater and stage == "Thirsty" then pcall(function() Water:FireServer(plant) end) end
                    if autoHarvest and stage == "Ripe" then pcall(function() Harvest:FireServer(plant) end) end
                end
            end
        end
        if autoGacha then pcall(function() Hatch:FireServer("Basic") end) end
        if autoUnlock then
            for _, plot in pairs(workspace.Plots:GetChildren()) do
                if plot:FindFirstChild("UnlockRequirement") then
                    pcall(function() Unlock:FireServer(plot) end)
                end
            end
        end
    end
end)
