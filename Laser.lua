local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local EmitterModule = require(script.Parent.Emitter)

local Laser = {}
Laser.__index = Laser

function Laser.new(laser, isMoving)
	local self = setmetatable({}, Laser)
	self.LaserPart = laser
	self.MovingLaser = isMoving
	self.PlayersTable = {}
	
	self.MoveSpeed = 2
	self.MoveDistance = 45
	
	self:Init()
	
	return self
end


function Laser:MoveLaser()
	if self.MovingLaser == true then
		local tweenInfo = TweenInfo.new(self.MoveSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true, 0.5)
		local newPos = self.LaserPart.Position + Vector3.new(0, 0, self.MoveDistance)
		if self.LaserPart.Name == "MovingLaserLR" then
			newPos = self.LaserPart.Position + Vector3.new(self.MoveDistance, 0, 0)
		end
		local tweenTab = {Position = newPos} --the position to move to
		local tween = TweenService:Create(self.LaserPart, tweenInfo, tweenTab)
		tween:Play()
	end
end


function Laser:CheckTouchingParts()
	local touchingParts = self.LaserPart:GetTouchingParts()
	if #touchingParts > 0 then
		for i,partTouched in pairs(touchingParts) do
			self:HandleTouch(partTouched)
		end
	end
end


function Laser:removePlayerFromTable(plr)
	local playerIndex = table.find(self.PlayersTable, plr)
	table.remove(self.PlayersTable, playerIndex)
	self:CheckTouchingParts()
end

function Laser:EmitPart(char)
	local colorKeypoints = {
		-- API: ColorSequenceKeypoint.new(time, color)
		ColorSequenceKeypoint.new( 0, Color3.new(1, 0.5, 0)),  -- At t=0, White
		ColorSequenceKeypoint.new(.1, Color3.new(1, .5, 0)), -- At t=.25, Orange
		ColorSequenceKeypoint.new(.2, Color3.new(1, 0, 0)), -- At t=.5, Red
		ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))   -- At t=1, Red
	}
	local colorSeq = ColorSequence.new(colorKeypoints)
	EmitterModule.new(char, colorSeq)
end

function Laser:damagePlayer(plr, char, hum)
	self:EmitPart(char)
	self.LaserPart.LaserSound:Play()
	table.insert(self.PlayersTable, plr)
	hum:TakeDamage(20)
	task.delay(1, function(plr)
		self:removePlayerFromTable(plr)
	end)
end


function Laser:checkHumanoid(plr)
	local value = false
	for i,v in pairs(self.PlayersTable) do
		if plr == v then
			value = true
			return value
		end
	end
	return value
end


function Laser:HandleTouch(partTouched)
	local partParent = partTouched.Parent

	local humanoid = partParent:FindFirstChildWhichIsA("Humanoid")
	-- get player from hand
	local player = game.Players:GetPlayerFromCharacter(partTouched.Parent)

	if humanoid then
		if #self.PlayersTable ~= 0 then
			-- check table to see if humanoid exists
			local isOnTableAlready = self:checkHumanoid(player)
			if isOnTableAlready == true then
				return
			else
				self:damagePlayer(player, partTouched.Parent, humanoid)
			end
		else
			self:damagePlayer(player, partTouched.Parent, humanoid)
		end
	end
end


function Laser:Init()
	self:MoveLaser()
	local newSound = ReplicatedStorage.Assets.LaserSound:Clone()
	newSound.Parent = self.LaserPart
	self.LaserPart.Touched:Connect(function(partTouched)
		self:HandleTouch(partTouched)
	end)
end


function Laser:Destroy()

end


return Laser
