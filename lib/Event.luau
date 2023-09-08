local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Identifier = require(script.Parent.Identifier)
local ClientEvent = require(script.Parent.ClientEvent)
local ServerEvent = require(script.Parent.ServerEvent)

local Server = {}
Server.__index = Server

function Server.new<T...>(EventId: string, Validate: (...unknown) -> T...)
	return setmetatable({
		EventId = EventId,
		Validate = Validate,

		Listening = false,
	}, Server)
end

export type Server<T...> = typeof(Server.new("", function(): T... end))

function Server.Fire<T...>(self: Server<T...>, Player: Player, ...: T...)
	ServerEvent.Fire(Player, self.EventId, table.pack(...))
end

function Server.FireAll<T...>(self: Server<T...>, ...: T...)
	for _, Player in Players:GetPlayers() do
		self:Fire(Player, ...)
	end
end

function Server.FireAllExcept<T...>(self: Server<T...>, Except: Player, ...: T...)
	for _, Player in Players:GetPlayers() do
		if Player ~= Except then
			self:Fire(Player, ...)
		end
	end
end

function Server.FireList<T...>(self: Server<T...>, PlayerList: { Player }, ...: T...)
	for _, Player in PlayerList do
		self:Fire(Player, ...)
	end
end

function Server.FireWithFilter<T...>(self: Server<T...>, Filter: (Player) -> boolean, ...: T...)
	for _, Player in Players:GetPlayers() do
		if Filter(Player) then
			self:Fire(Player, ...)
		end
	end
end

function Server.On<T...>(self: Server<T...>, Callback: (Player: Player, T...) -> ())
	assert(self.Listening == false, "Only one listener can be given for each event.")
	self.Listening = true

	ServerEvent.Listen(self.EventId, function(Player, ...)
		if pcall(self.Validate, ...) then
			Callback(Player, ...)
		end
	end)
end

local Client = {}
Client.__index = Client

function Client.new<T...>(EventId: string, Validate: (...unknown) -> T...)
	return setmetatable({
		EventId = EventId,
		Validate = Validate,

		Listening = false,
	}, Client)
end

export type Client<T...> = typeof(Client.new("", function(): T... end))

function Client.Fire<T...>(self: Client<T...>, ...: T...)
	ClientEvent.Fire(self.EventId, table.pack(...))
end

function Client.On<T...>(self: Client<T...>, Callback: (T...) -> ())
	assert(self.Listening == false, "Only one listener can be given for each event.")
	self.Listening = true

	ClientEvent.Listen(self.EventId, Callback)
end

local Event = {}
Event.__index = Event

function Event.new<T...>(Validate: (...unknown) -> T..., NameOverride: string?)
	local Name = NameOverride or debug.info(2, "s")

	if string.find(Name, "-") then
		error("Event name cannot contain '-'")
	end

	Name = string.gsub(Name, "%.", "-")

	return setmetatable({
		EventId = Identifier.Shared(Name):Await() :: string,
		Validate = Validate,

		ServerEvent = nil :: Server<T...>?,
		ClientEvent = nil :: Client<T...>?,
	}, Event)
end

export type Event<T...> = typeof(Event.new(function(): T... end))

function Event.Server<T...>(self: Event<T...>): Server<T...>
	assert(RunService:IsServer(), "Cannot get server event from client.")

	if not ServerEvent then
		self.ServerEvent = Server.new(self.EventId, self.Validate)
	end

	return self.ServerEvent :: Server<T...>
end

function Event.Client<T...>(self: Event<T...>): Client<T...>
	assert(RunService:IsClient(), "Cannot get client event from server.")

	if not ServerEvent then
		self.ClientEvent = Client.new(self.EventId, self.Validate)
	end

	return self.ClientEvent :: Client<T...>
end

return Event
