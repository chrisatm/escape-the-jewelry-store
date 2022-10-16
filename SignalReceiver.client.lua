local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ActivateRobbing = ReplicatedStorage.Signals.ActivateRobbing
local DeactivateRobbing = ReplicatedStorage.Signals.DeactivateRobbing
local LaunchPlayer = ReplicatedStorage.Signals.LaunchPlayer


local playerGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')


local function activateRobbing()
	
	playerGui.ScreenGui.Enabled = true
end

local function deactivateRobbing()

	playerGui.ScreenGui.Enabled = false
end

local function launchPlayer()

	local humanoidRootPart = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart

	local rand1 = math.random(-1,1)
	local rand2 = math.random(-1,1)
	if rand1 == 0 then
		rand1 = 1
	end
	if rand2 == 0 then
		rand2 = 1
	end
	local dir1 = humanoidRootPart.AssemblyMass * 500 * rand1
	local dir2 = humanoidRootPart.AssemblyMass * 500 * rand2
	
	script.WhooshSound:Play()
	humanoidRootPart:ApplyImpulse(Vector3.new(dir1, humanoidRootPart.AssemblyMass * 100, dir2))
end

ActivateRobbing.OnClientEvent:Connect(activateRobbing)
DeactivateRobbing.OnClientEvent:Connect(deactivateRobbing)
LaunchPlayer.OnClientEvent:Connect(launchPlayer)
