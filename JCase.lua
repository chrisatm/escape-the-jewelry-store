local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ActivateRobbing = ReplicatedStorage.Signals.ActivateRobbing

local PhysicsService = game:GetService("PhysicsService")

local FragmenterModule = require(script.Parent.Fragmenter)

local JCase = {}
JCase.__index = JCase

function JCase.new(jcase)
	local self = setmetatable({}, JCase)
	self.Case = jcase
	self.TouchDetector = self.Case:FindFirstChild("TouchDetector")
	self.Glass = self.Case:FindFirstChild("jCaseGlass")
	self.Diamonds = {}
	
	self.debounce = false
	
	self:Init()
	
	return self
end


function JCase:GiveDuffleBag(char)
	local playerModel = char
	local newDuffle = ReplicatedStorage.Assets.DuffleBag:Clone()
	newDuffle.Parent = playerModel
	-- model made by Creeperzombie2024
end


function JCase:Reload()
	self.debounce = false
	self.Glass.Transparency = 0.5
	self:UpdateDiamonds(false)
end


function JCase:UpdateDiamonds(isTransparent)
	local Tranparency = 1
	if isTransparent == false then
		Tranparency = 0
	end
	for i,diamond in pairs(self.Diamonds) do
		diamond.Transparency = Tranparency
	end
end


function JCase:UpdateGlass()
	-- destroy glass
	self.Case.Sound:Play()
	self.Glass.Transparency = 1
	local newGlass = self.Glass:Clone()
	newGlass.Transparency = 0
	newGlass.Parent = self.Case
	newGlass.Anchored = false
	newGlass.CanCollide = false
	FragmenterModule.fragmentPart:Fire(newGlass)
end

function JCase:SetActiveRob(plr)
	-- set robbing value to true
	plr.Robbing.Value = true
	-- send signal to client to activate the robbing gui
	ActivateRobbing:FireClient(plr)
end


function JCase:SetCollisionGroup(char)
	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("BasePart") then
			PhysicsService:RemoveCollisionGroup(child, "Outside")
			PhysicsService:SetPartCollisionGroup(child, "Inside")
		end
	end
	char.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			PhysicsService:RemoveCollisionGroup(descendant, "Outside")
			PhysicsService:SetPartCollisionGroup(descendant, "Inside")
		end
	end)
end


function JCase:HandleTouch(partTouched)
	if self.debounce == false then
		if partTouched.Name == "RightHand" or partTouched.Name == "LeftHand" then
			-- get player from hand
			local player = game.Players:GetPlayerFromCharacter(partTouched.Parent)
			-- if player is punching then destroy glass
			if player.Punching.Value == true then
				-- destroy glass
				self:UpdateGlass()
				self:UpdateDiamonds(true)
				-- give duffle bag
				self:GiveDuffleBag(partTouched.Parent)
				self:SetActiveRob(player)
				
				self:SetCollisionGroup(partTouched.Parent)
				
				self.debounce = true
				task.delay(3,function()
					self:Reload()
				end)
			end
		end
	end
end


function JCase:GetDiamonds()
	for i,v in pairs(self.Case:GetChildren()) do
		if v.Name == "Diamond" then
			table.insert(self.Diamonds, v)
		end
	end
end


function JCase:Init()
	self.TouchDetector.CanCollide = false
	self.TouchDetector.CanTouch = true
	self:GetDiamonds()
	self.TouchDetector.Touched:Connect(function(partTouched)
		self:HandleTouch(partTouched)
	end)
end


function JCase:Destroy()

end


return JCase
