local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DeactivateRobbing = ReplicatedStorage.Signals.DeactivateRobbing

local PhysicsService = game:GetService("PhysicsService")

local DataStore2 = require(script.Parent.DataStore2)

local MoneyPart = game.Workspace.MoneyPart

local EmitterModule = require(script.Parent.Emitter)


local function removeDuffleBag(partParent)
	local duffleBag = partParent:FindFirstChild("DuffleBag")
	if duffleBag then
		duffleBag:Destroy()
	end
end

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

local function EmitPart(char)
	local colorKeypoints = {
		-- API: ColorSequenceKeypoint.new(time, color)
		ColorSequenceKeypoint.new( 0, Color3.new(0.666667, 1, 0.498039)),  -- At t=0, White
		ColorSequenceKeypoint.new(.1, Color3.new(0.333333, 0.666667, 0)), -- At t=.25, Orange
		ColorSequenceKeypoint.new(.2, Color3.new(0.333333, 0.666667, 0)), -- At t=.5, Red
		ColorSequenceKeypoint.new(1, Color3.new(0.333333, 0.666667, 0))   -- At t=1, Red
	}
	local colorSeq = ColorSequence.new(colorKeypoints)
	EmitterModule.new(char, colorSeq)
end

local function giveMoney(partTouched)
	
	local partParent = partTouched.Parent

	local humanoid = partParent:FindFirstChildWhichIsA("Humanoid")
	
	if humanoid then
		removeDuffleBag(partParent)
		local player = game.Players:GetPlayerFromCharacter(partTouched.Parent)
		if player.Robbing.Value == true then
			-- play money get sound
			MoneyPart.Sound:Play()
			EmitPart(partParent)
			-- give money
			local moneyStore = DataStore2("money", player)
			moneyStore:Increment(1000) -- Give them 1000 money
			--player.leaderstats.Money.Value += 1000
			SetCollisionGroup(partParent)
			DeactivateRobbing:FireClient(player)
			player.Robbing.Value = false
		end
	end
	
end

MoneyPart.Touched:Connect(giveMoney)
