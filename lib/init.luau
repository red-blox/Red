local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Remote
local ClientFolder
if RunService:IsServer() then
	if ReplicatedStorage:FindFirstChild("RedEvent") then
		Remote = ReplicatedStorage:FindFirstChild("RedEvent") :: RemoteEvent
	else
		Remote = Instance.new("RemoteEvent")
		Remote.Name = "RedEvent"
		Remote.Parent = ReplicatedStorage
	end

	require(script.ServerEvent).Start()

	local function PlayerAdded(Player: Player)
		local ClientFolder = Instance.new("ScreenGui")

		ClientFolder.Enabled = false
		ClientFolder.ResetOnSpawn = false
		ClientFolder.Name = "Red"
		ClientFolder.Parent = Player:FindFirstChild("PlayerGui")
	end

	Players.PlayerAdded:Connect(PlayerAdded)

	for _, Player in Players:GetPlayers() do
		PlayerAdded(Player)
	end
else
	Remote = ReplicatedStorage:WaitForChild("RedEvent") :: RemoteEvent

	require(script.ClientEvent).Start()

	ClientFolder = (Players.LocalPlayer:FindFirstChild("PlayerGui") :: PlayerGui):WaitForChild("Red") :: ScreenGui
	ClientFolder.Parent = nil
end

return {
	Event = require(script.Event),
	Function = require(script.Function),
}
