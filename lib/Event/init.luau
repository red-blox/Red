local RunService = game:GetService("RunService")

local Identifier = require(script.Parent.Identifier)

local ServerEvent = require(script.Server)
local ClientEvent = require(script.Client)

export type Event<T...> = {
	Id: string,
	Validate: (...unknown) -> T...,

	Unreliable: boolean,

	ServerEvent: ServerEvent.Server<T...>?,
	ClientEvent: ClientEvent.Client<T...>?,

	Server: (self: Event<T...>) -> ServerEvent.Server<T...>,
	Client: (self: Event<T...>) -> ClientEvent.Client<T...>,
}

local function Server<T...>(self: Event<T...>): ServerEvent.Server<T...>
	assert(RunService:IsServer(), "Server events can only be accessed from the server")

	if not self.ServerEvent then
		self.ServerEvent = ServerEvent(self.Id, self.Validate, self.Unreliable)
	end

	return self.ServerEvent :: any
end

local function Client<T...>(self: Event<T...>): ClientEvent.Client<T...>
	assert(RunService:IsClient(), "Client events can only be accessed from the client")

	if not self.ClientEvent then
		self.ClientEvent = ClientEvent(self.Id, self.Unreliable) :: any
	end

	return self.ClientEvent :: any
end

type EventOptions = {
	Name: string,
	Unreliable: boolean?,
}

local function Event<T...>(Config: string | EventOptions, Validate: (...unknown) -> T...): Event<T...>
	local Name, Unreliable

	if type(Config) == "string" then
		Name = Config
		Unreliable = false
	else
		Name = Config.Name
		Unreliable = Config.Unreliable or false
	end

	assert(not Identifier.Exists(Name), "Cannot use same name twice")

	return {
		Id = Identifier.Shared(Name):Await(),
		Validate = Validate,

		Unreliable = Unreliable,

		ServerEvent = nil,
		ClientEvent = nil,

		Server = Server,
		Client = Client,
	} :: any
end

return Event
