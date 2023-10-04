local RunService = game:GetService("RunService")

local Future = require(script.Parent.Parent.Future)

local ServerEvent = require(script.Parent.ServerEvent)
local ClientEvent = require(script.Parent.ClientEvent)
local Identifier = require(script.Parent.Identifier)

local function PackArgs(...: any)
	return { ... }
end

export type Function<A..., R...> = {
	Id: string,
	Validate: (...unknown) -> A...,
	Listening: boolean,

	SetCallback: (self: Function<A..., R...>, Callback: (Player, A...) -> R...) -> (),
	Call: (self: Function<A..., R...>, A...) -> typeof(Future.new(function(): R... end)),
}

local function SetCallback<A..., R...>(self: Function<A..., R...>, Callback: (Player, A...) -> R...)
	assert(RunService:IsServer(), "Cannot set callback to function on client")
	assert(not self.Listening, "Cannot set callback to function multiple times")

	self.Listening = true
	ServerEvent.Listen(self.Id, function(Player, ...)
		if pcall(self.Validate, ...) then
			return Callback(Player, ...)
		end
	end)
end

local function Call<A..., R...>(self: Function<A..., R...>, ...: A...)
	return ClientEvent.Call(self.Id, PackArgs(...))
end

local function Function<A..., R...>(
	Name: string,
	ValidateArg: (...unknown) -> A...,
	ValidateRet: (...unknown) -> R...
): Function<A..., R...>
	assert(not Identifier.Exists(Name), "Cannot use same name twice")

	return {
		Id = Identifier.Shared(Name):Await(),
		Validate = ValidateArg,
		Listening = false,

		SetCallback = SetCallback,
		Call = Call,
	} :: any
end

return Function
