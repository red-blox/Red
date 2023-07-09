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

	ClientFolder = (Players.LocalPlayer:FindFirstChild("PlayerGui") :: PlayerGui):WaitForChild("Red") :: ScreenGui
	ClientFolder.Parent = nil
end

local Event = require(script.Event)
local Serdes = require(script.Serdes)
local Identifier = require(script.Identifier)
local ClientEvent = require(script.ClientEvent)
local ServerEvent = require(script.ServerEvent)

local Server = {}
Server.__index = Server

function Server.new(Name: string)
	return setmetatable({
		Name = Name,
		FolderInstance = nil :: Folder?,
	}, Server)
end

export type Server = typeof(Server.new(...))

function Server.Fire(self: Server, Player: Player, EventName: string, ...)
	local Args = { ... }

	Event.Shared(self.Name .. "_" .. EventName):Then(function(EventId)
		ServerEvent.Fire(Player, EventId, Args)
	end)
end

function Server.FireAll(self: Server, EventName: string, ...)
	local Args = { ... }

	Event.Shared(self.Name .. "_" .. EventName):Then(function(EventId)
		for _, Player in Players:GetPlayers() do
			ServerEvent.Fire(Player, EventId, Args)
		end
	end)
end

function Server.FireAllExcept(self: Server, Except: Player, EventName: string, ...)
	local Args = { ... }

	Event.Shared(self.Name .. "_" .. EventName):Then(function(EventId)
		for _, Player in Players:GetPlayers() do
			if Player ~= Except then
				ServerEvent.Fire(Player, EventId, Args)
			end
		end
	end)
end

function Server.FireList(self: Server, PlayerList: { Player }, EventName: string, ...)
	local Args = { ... }

	Event.Shared(self.Name .. "_" .. EventName):Then(function(EventId)
		for _, Player in PlayerList do
			ServerEvent.Fire(Player, EventId, Args)
		end
	end)
end

function Server.FireWithFilter(self: Server, Filter: (Player) -> boolean, EventName: string, ...)
	local Args = { ... }

	Event.Shared(self.Name .. "_" .. EventName):Then(function(EventId)
		for _, Player in Players:GetPlayers() do
			if Filter(Player) then
				ServerEvent.Fire(Player, EventId, Args)
			end
		end
	end)
end

function Server.Folder(self: Server, Player: Player?)
	if Player then
		local ClientFolder = (Player:FindFirstChild("PlayerGui") :: any).Red :: ScreenGui

		if ClientFolder:FindFirstChild(self.Name) then
			return ClientFolder:FindFirstChild(self.Name) :: Folder
		else
			local Folder = Instance.new("Folder")
			Folder.Name = self.Name
			Folder.Parent = ClientFolder

			return Folder :: Folder
		end
	else
		if not self.FolderInstance then
			local Folder = Instance.new("Folder")
			Folder.Name = self.Name
			Folder.Parent = Remote

			self.FolderInstance = Folder
		end

		return self.FolderInstance :: Folder
	end
end

function Server.On(self: Server, EventName: string, Callback: (Player, ...any) -> nil)
	Event.Shared(self.Name .. "_" .. EventName):Then(function(EventId)
		ServerEvent.Listen(EventId, Callback)
	end)
end

local Client = {}
Client.__index = Client

function Client.new(Name: string)
	return setmetatable({
		Name = Name,
		FolderInstance = nil :: Folder?,
		LocalFolderInstance = nil :: Folder?,
	}, Client)
end

export type Client = typeof(Client.new(...))

function Client.Fire(self: Client, EventName: string, ...)
	local Args = { ... }

	return Event.Shared(self.Name .. "_" .. EventName):Then(function(EventId)
		ClientEvent.Fire(EventId, Args)
	end)
end

function Client.Call(self: Client, EventName: string, ...)
	local Args = { ... }

	return Event.Shared(self.Name .. "_" .. EventName):Then(function(EventId)
		return ClientEvent.Call(EventId, Args)
	end)
end

function Client.On(self: Client, EventName: string, Callback: (...any) -> ())
	Event.Shared(self.Name .. "_" .. EventName):Then(function(EventId)
		ClientEvent.Listen(EventId, Callback)
	end)
end

function Client.Folder(self: Client)
	if not self.FolderInstance then
		self.FolderInstance = Remote:WaitForChild(self.Name) :: Folder
	end

	return self.FolderInstance :: Folder
end

function Client.LocalFolder(self: Client)
	if not self.LocalFolderInstance then
		self.LocalFolderInstance = ClientFolder:WaitForChild(self.Name) :: Folder
	end

	return self.LocalFolderInstance :: Folder
end

local ServerMap = {}
local ClientMap = {}

if RunService:IsServer() then
	ServerEvent.Start()
else
	ClientEvent.Start()
end

export type Serdes<I, O> = Serdes.Serdes<I, O>

return {
	Serdes = Serdes,
	Identifier = Identifier,

	Server = function(Name: string)
		assert(RunService:IsServer(), "Red.Server can only be used on the server.")

		if not ServerMap[Name] then
			ServerMap[Name] = Server.new(Name)
		end

		return ServerMap[Name]
	end,

	Client = function(Name: string)
		assert(RunService:IsClient(), "Red.Client can only be used on the client.")

		if not ClientMap[Name] then
			ClientMap[Name] = Client.new(Name)
		end

		return ClientMap[Name]
	end,
}
