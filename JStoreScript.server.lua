local jstore = game.Workspace.jStore

local detectorBlock1 = game.Workspace.jStore.DetectorBlock1
local detectorBlock2 = game.Workspace.jStore.DetectorBlock2

local entryGlass1 = game.Workspace.jStore.EntryGlass1
local entryGlass2 = game.Workspace.jStore.EntryGlass2

local JCaseModule = require(script.Parent.JCase)

local jCases = {}

local debounce = false

local FragmenterModule = require(script.Parent.Fragmenter)


local function resetGlass(part)
	entryGlass1.Transparency = 0.5
	entryGlass2.Transparency = 0.5
	debounce = false
end



local function psuedoGlass(part)
	local newGlass = part:Clone()
	newGlass.CanCollide = false
	newGlass.Anchored = false
	newGlass.Parent = game.Workspace.jStore
	FragmenterModule.fragmentPart:Fire(newGlass)
	--local impulseVal = newGlass.AssemblyMass * 10
	--newGlass:ApplyImpulse(Vector3.new(impulseVal, 0, impulseVal))
	task.delay(3, function() 
		newGlass:Destroy()
		resetGlass()
	end)
end


local function getJCases()
	for i,v in pairs(jstore:GetChildren()) do
		if v.Name == "jCase" then
			local newJCase = JCaseModule.new(v)
			table.insert(jCases, newJCase)
		end
	end
end


local function handleTouch1(partTouched)
	if debounce == false then
		-- if detectBlock1 then entryGlass 1 and vice verse
		entryGlass1.Sound:Play()
		psuedoGlass(entryGlass1)
		entryGlass1.Transparency = 1
		debounce = true
	end
end


local function handleTouch2(partTouched)
	if debounce == false then
		-- if detectBlock1 then entryGlass 1 and vice verse
		entryGlass2.Sound:Play()
		psuedoGlass(entryGlass2)
		entryGlass2.Transparency = 1
		debounce = true
	end
end


getJCases()
detectorBlock1.Touched:Connect(handleTouch1)
detectorBlock2.Touched:Connect(handleTouch2)

