local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Identifier = require(script.Parent.Identifier)
local Spawn = require(script.Parent.Parent.Spawn)
local Signal = require(script.Parent.Parent.Signal)

local Net = require(script.Parent.Net)

type SharedBaseEvent<T...> = {
	Id: string,
	Reliable: boolean,

	FireClient: (self: SharedBaseEvent<T...>, Player: Player, T...) -> (),
	FireAllClients: (self: SharedBaseEvent<T...>, T...) -> (),
	FireAllClientsExcept: (self: SharedBaseEvent<T...>, Player: Player, T...) -> (),
	FireClients: (self: SharedBaseEvent<T...>, Players: { Player }, T...) -> (),

	FireServer: (self: SharedBaseEvent<T...>, T...) -> (),
}

export type SharedCallEvent<T...> = SharedBaseEvent<T...> & {
	CallMode: "Call",

	Listener: ((...any) -> ())?,

	SetServerListener: (self: SharedCallEvent<T...>, Listener: (Player: Player, T...) -> ()) -> (),
	SetClientListener: (self: SharedCallEvent<T...>, Listener: (T...) -> ()) -> (),
}

export type SharedSignalEvent<T...> = SharedBaseEvent<T...> & {
	CallMode: "Signal",

	Signal: Signal.Signal<...any>,

	OnServer: (self: SharedSignalEvent<T...>, Listener: (Player: Player, T...) -> ()) -> () -> (),
	OnClient: (self: SharedSignalEvent<T...>, Listener: (T...) -> ()) -> () -> (),
}

export type SharedEvent<T...> = SharedCallEvent<T...> | SharedSignalEvent<T...>

local function FireClient<T...>(self: SharedBaseEvent<T...>, Player: Player, ...)
	assert(RunService:IsServer(), "FireClient can only be called from the server")

	if self.Reliable then
		Net.Server.SendReliableEvent(Player, self.Id, table.pack(...))
	else
		Net.Server.SendUnreliableEvent(Player, self.Id, table.pack(...))
	end
end

local function FireAllClients<T...>(self: SharedBaseEvent<T...>, ...)
	assert(RunService:IsServer(), "FireAllClients can only be called from the server")

	local Args = table.pack(...)

	if self.Reliable then
		for _, Player in Players:GetPlayers() do
			Net.Server.SendReliableEvent(Player, self.Id, Args)
		end
	else
		for _, Player in Players:GetPlayers() do
			Net.Server.SendUnreliableEvent(Player, self.Id, Args)
		end
	end
end

local function FireAllClientsExcept<T...>(self: SharedBaseEvent<T...>, Player: Player, ...)
	assert(RunService:IsServer(), "FireAllClientsExcept can only be called from the server")

	local Args = table.pack(...)

	if self.Reliable then
		for _, OtherPlayer in Players:GetPlayers() do
			if OtherPlayer ~= Player then
				Net.Server.SendReliableEvent(OtherPlayer, self.Id, Args)
			end
		end
	else
		for _, OtherPlayer in Players:GetPlayers() do
			if OtherPlayer ~= Player then
				Net.Server.SendUnreliableEvent(OtherPlayer, self.Id, Args)
			end
		end
	end
end

local function FireClients<T...>(self: SharedBaseEvent<T...>, Players: { Player }, ...)
	assert(RunService:IsServer(), "FireClients can only be called from the server")

	local Args = table.pack(...)

	if self.Reliable then
		for _, Player in Players do
			Net.Server.SendReliableEvent(Player, self.Id, Args)
		end
	else
		for _, Player in Players do
			Net.Server.SendUnreliableEvent(Player, self.Id, Args)
		end
	end
end

local function FireServer<T...>(self: SharedBaseEvent<T...>, ...)
	assert(RunService:IsClient(), "FireServer can only be called from the client")

	if self.Reliable then
		Net.Client.SendReliableEvent(self.Id, table.pack(...))
	else
		Net.Client.SendUnreliableEvent(self.Id, table.pack(...))
	end
end

local function SetServerListener<T...>(self: SharedCallEvent<T...>, Listener: (Player: Player, T...) -> ())
	assert(RunService:IsServer(), "SetServerListener can only be called from the server")

	self.Listener = Listener :: any
end

local function SetClientListener<T...>(self: SharedCallEvent<T...>, Listener: (T...) -> ())
	assert(RunService:IsClient(), "SetClientListener can only be called from the client")

	self.Listener = Listener :: any
end

local function OnServer<T...>(self: SharedSignalEvent<T...>, Listener: (Player: Player, T...) -> ()): () -> ()
	assert(RunService:IsServer(), "OnServer can only be called from the server")

	return self.Signal:Connect(Listener :: any)
end

local function OnClient<T...>(self: SharedSignalEvent<T...>, Listener: (T...) -> ()): () -> ()
	assert(RunService:IsClient(), "OnClient can only be called from the client")

	return self.Signal:Connect(Listener :: any)
end

type SharedEventOptions<T...> = {
	Name: string,
	Unreliable: boolean?,

	Validate: (...unknown) -> T...,
}

type ConstructorType =
	(<T...>(Options: SharedEventOptions<T...> & { CallMode: "Call"? }) -> SharedCallEvent<T...>)
	& (<T...>(Options: SharedEventOptions<T...> & { CallMode: "Signal" }) -> SharedSignalEvent<T...>)

local SharedEvent: ConstructorType = function(Options: any)
	local self = {
		Id = Identifier.Shared(Options.Name):Await(),
		Reliable = not Options.Unreliable,

		FireClient = FireClient,
		FireAllClients = FireAllClients,
		FireAllClientsExcept = FireAllClientsExcept,
		FireClients = FireClients,

		FireServer = FireServer,
	}

	if Options.CallMode == "Call" then
		self.CallMode = "Call"

		self.SetServerListener = SetServerListener
		self.SetClientListener = SetClientListener

		self.Listener = nil :: (...any) -> ()?

		if RunService:IsServer() then
			Net.Server.SetListener(self.Id, function(Player, Args)
				Spawn(function(Player: Player, ...: any)
					if self.Listener and pcall(Options.Validate, ...) then
						self.Listener(Player, ...)
					end
				end, Player, table.unpack(Args))
			end)
		else
			Net.Client.SetListener(self.Id, function(Args)
				Spawn(function(...: any)
					if self.Listener and pcall(Options.Validate, ...) then
						self.Listener(...)
					end
				end, table.unpack(Args))
			end)
		end
	elseif Options.CallMode == "Signal" then
		self.CallMode = "Signal"

		self.Signal = Signal()

		self.OnServer = OnServer
		self.OnClient = OnClient

		if RunService:IsServer() then
			Net.Server.SetListener(self.Id, function(Player, Args)
				Spawn(function(Player: Player, ...: any)
					if pcall(Options.Validate, ...) then
						self.Signal:Fire(Player, ...)
					end
				end, Player, table.unpack(Args))
			end)
		else
			Net.Client.SetListener(self.Id, function(Args)
				Spawn(function(...: any)
					if pcall(Options.Validate, ...) then
						self.Signal:Fire(...)
					end
				end, table.unpack(Args))
			end)
		end
	end

	return self
end :: any

return SharedEvent
