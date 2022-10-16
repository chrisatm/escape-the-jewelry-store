local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PunchingEvent = ReplicatedStorage.Signals.PunchingEvent


local function handlePunchingEvent(player)
	player.Punching.Value = true
	wait(0.75)
	player.Punching.Value = false
end


PunchingEvent.OnServerEvent:Connect(handlePunchingEvent)
