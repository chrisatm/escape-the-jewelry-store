local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")

local DataStore2 = require(script.Parent.DataStore2)
-- Always "combine" any key you use! To understand why, read the "Gotchas" page.
DataStore2.Combine("DATA", "money")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DeactivateRobbing = ReplicatedStorage.Signals.DeactivateRobbing


local function SetCollisionGroup(char)
	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("BasePart") then
			PhysicsService:RemoveCollisionGroup(child, "Inside")
			PhysicsService:SetPartCollisionGroup(child, "Outside")
		end
	end
	char.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			PhysicsService:RemoveCollisionGroup(descendant, "Inside")
			PhysicsService:SetPartCollisionGroup(descendant, "Outside")
		end
	end)
end

local function addPunchingBoolValue(player)
	local punchingBool = Instance.new("BoolValue")
	punchingBool.Name = "Punching"
	punchingBool.Parent = player
	punchingBool.Value = false
end

local function addRobbingBoolValue(player)
	local robbingBool = Instance.new("BoolValue")
	robbingBool.Name = "Robbing"
	robbingBool.Parent = player
	robbingBool.Value = false
end

local function addLeaderStats(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local money = Instance.new("IntValue")
	money.Name = "Money"
	money.Value = 0
	money.Parent = leaderstats
end

local function onPlayerDead(player, char)
	player.Robbing.Value = false
	player.Punching.Value = false
	-- set collision group
	SetCollisionGroup(char)
	DeactivateRobbing:FireClient(player)
end

local function listenPlayerDied(plr, char)
	char:WaitForChild("Humanoid").Died:Connect(function()
		onPlayerDead(plr, char)
	end)
end


local function handlePlayerData(plr)
	local moneyStore = DataStore2("money", plr)


	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr

	local money = Instance.new("NumberValue")
	money.Name = "Money"
	money.Value = moneyStore:Get(0) -- The "0" means that by default, they'll have 0 points
	money.Parent = leaderstats

	moneyStore:OnUpdate(function(newMoney)
		-- This function runs every time the value inside the data store changes.
		money.Value = newMoney
	end)

end

Players.PlayerAdded:Connect(function(player)
	-- on character added stuff
	player.CharacterAdded:Connect(function(character)
		SetCollisionGroup(character)
		listenPlayerDied(player, character)
	end)

	-- bools
	addPunchingBoolValue(player)
	addRobbingBoolValue(player)
	-- handle player data
	handlePlayerData(player)

end)

Players.PlayerRemoving:Connect(function(player)
	print(player.Name .. " left the game!")
end)


