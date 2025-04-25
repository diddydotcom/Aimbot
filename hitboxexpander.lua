-- Place this in StarterPlayerScripts (for testing in Studio only)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "HitboxExpanderGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Hitbox Expander (Educational)"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

-- Slider Label
local sliderLabel = Instance.new("TextLabel", frame)
sliderLabel.Position = UDim2.new(0, 10, 0, 40)
sliderLabel.Size = UDim2.new(0, 280, 0, 20)
sliderLabel.Text = "Hitbox Size: 2"
sliderLabel.TextColor3 = Color3.new(1, 1, 1)
sliderLabel.BackgroundTransparency = 1

-- Hitbox Size Variable
local hitboxSize = 2

-- Toggle Button
local toggle = Instance.new("TextButton", frame)
toggle.Position = UDim2.new(0, 10, 0, 70)
toggle.Size = UDim2.new(0, 280, 0, 30)
toggle.Text = "Toggle Hitbox (Off)"
toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)

local enabled = false

toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggle.Text = "Toggle Hitbox (" .. (enabled and "On" or "Off") .. ")"
	toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
end)

-- Keybind: Press K to Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.K and not gameProcessed then
		enabled = not enabled
		toggle.Text = "Toggle Hitbox (" .. (enabled and "On" or "Off") .. ")"
		toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
	end
end)

-- Mock Hitbox Function (Educational Only)
game:GetService("RunService").RenderStepped:Connect(function()
	if enabled and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") and part.Name == "Head" then
				part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
			end
		end
	end
end)
