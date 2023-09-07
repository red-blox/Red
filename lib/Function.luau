local RunService = game:GetService("RunService")

local Future = require(script.Parent.Parent.Future)

local Identifier = require(script.Parent.Identifier)
local ServerEvent = require(script.Parent.ServerEvent)
local ClientEvent = require(script.Parent.ClientEvent)

local Function = {}
Function.__index = Function

function Function.new<A..., R...>(Name: string, ArgsValidate: (...unknown) -> A..., ReturnsValidate: (...unknown) -> R...)
	return setmetatable({
		EventId = Identifier.Shared(Name):Await() :: string,

		ArgsValidate = ArgsValidate,
		ReturnsValidate = ReturnsValidate,
	}, Function)
end

export type Function<A..., R...> = typeof(Function.new("", function(): A... end, function(): R... end))

function Function.Server<A..., R...>(self: Function<A..., R...>, Callback: (Player, A...) -> R...)
	assert(RunService:IsServer(), "Cannot use server function from client.")

	ServerEvent.Listen(self.EventId, function(Player, ...)
		if pcall(self.ArgsValidate, ...) then
			return Callback(Player, ...)
		end
	end)
end

function Function.Client<A..., R...>(self: Function<A..., R...>, ...: A...): typeof(Future.new(function(): R... end))
	assert(RunService:IsClient(), "Cannot use client function from server.")

	return ClientEvent.Call(self.EventId, table.pack(...))
end

return Function
