local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Remote
if RunService:IsServer() then
	if ReplicatedStorage:FindFirstChild("RedEvent") then
		Remote = ReplicatedStorage:FindFirstChild("RedEvent") :: RemoteEvent
	else
		Remote = Instance.new("RemoteEvent")
		Remote.Name = "RedEvent"
		Remote.Parent = ReplicatedStorage
	end

	require(script.ServerEvent).Start()
else
	Remote = ReplicatedStorage:WaitForChild("RedEvent") :: RemoteEvent

	require(script.ClientEvent).Start()
end

return {
	Event = require(script.Event),
	Function = require(script.Function),
}
