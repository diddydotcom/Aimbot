local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "HitboxExpanderGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 120)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Hitbox Expander (Educational)"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local toggle = Instance.new("TextButton", frame)
toggle.Position = UDim2.new(0, 10, 0, 40)
toggle.Size = UDim2.new(0, 280, 0, 40)
toggle.Text = "Toggle Hitbox (Off)"
toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSans
toggle.TextSize = 18

local hitboxesEnabled = false

-- Function to apply hitbox to a character
local function applyHitbox(character)
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	-- Prevent duplicate boxes
	if character:FindFirstChild("ExpandedHitbox") then return end

	local hrp = character.HumanoidRootPart
	local box = Instance.new("BoxHandleAdornment")
	box.Name = "ExpandedHitbox"
	box.Size = Vector3.new(7, 7, 7) -- Enlarged hitbox
	box.Adornee = hrp
	box.AlwaysOnTop = true
	box.ZIndex = 1
	box.Color3 = Color3.new(1, 0, 0)
	box.Transparency = 0.5
	box.Parent = hrp
end

-- Apply hitboxes to all players (except local)
local function applyToAll()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			local function onCharacterAdded(char)
				char:WaitForChild("HumanoidRootPart")
				if hitboxesEnabled then
					wait(1) -- Give time for loading
					applyHitbox(char)
				end
			end

			-- Listen for new characters
			player.CharacterAdded:Connect(onCharacterAdded)

			-- If already spawned
			if player.Character then
				onCharacterAdded(player.Character)
			end
		end
	end
end

-- Toggle logic
local function setToggle(state)
	hitboxesEnabled = state
	toggle.Text = "Toggle Hitbox (" .. (state and "On" or "Off") .. ")"
	toggle.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)

	if state then
		applyToAll()
	end
end

toggle.MouseButton1Click:Connect(function()
	setToggle(not hitboxesEnabled)
end)

-- Keybind: K to toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.K and not gameProcessed then
		setToggle(not hitboxesEnabled)
	end
end)

-- Update existing or new players joining
Players.PlayerAdded:Connect(function(player)
	if player == localPlayer then return end

	player.CharacterAdded:Connect(function(char)
		if hitboxesEnabled then
			wait(1)
			applyHitbox(char)
		end
	end)
end)
