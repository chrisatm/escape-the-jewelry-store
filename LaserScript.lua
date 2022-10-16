local lasers = game.Workspace.Lasers

local LaserModule = require(script.Parent.Laser)

local activatedLasers = {}


local function initLasers()
	for i,v in pairs(lasers:GetChildren()) do
		local isMoving = false
		if string.find(v.Name, "MovingLaser") then
			isMoving = true
		end
		-- (laser, isMoving)
		local laser = LaserModule.new(v, isMoving)
		table.insert(activatedLasers, laser)
		
	end
end


initLasers()


