local RunService = game:GetService("RunService")

local Future = require(script.Parent.Parent.Future)
local Spawn = require(script.Parent.Parent.Spawn)

local Net = require(script.Parent.Net)
local Identifier = require(script.Parent.Identifier)

export type Function<A..., R...> = {
	Id: string,
	Validate: (...unknown) -> A...,

	SetCallback: (self: Function<A..., R...>, Callback: (Player, A...) -> R...) -> (),
	Call: (
		self: Function<A..., R...>,
		A...
	) -> typeof(Future.new(function(): (boolean, R...)
		return {} :: any
	end)),
}

local function SetCallback<A..., R...>(self: Function<A..., R...>, Callback: (Player, A...) -> R...)
	assert(RunService:IsServer(), "Cannot set callback to function on client")

	Net.Server.SetListener(self.Id, function(Player, Args)
		local CallId = table.remove(Args, 1)

		if type(CallId) ~= "string" then
			return
		end

		Spawn(function(Player: Player, CallId: string, ...: any)
			if pcall(self.Validate, ...) then
				Net.Server.SendCallReturn(Player, CallId, table.pack(pcall(Callback, Player, ...)))
			end
		end, Player, CallId, unpack(Args))
	end)
end

local function Call<A..., R...>(self: Function<A..., R...>, ...: A...)
	return Future.new(function(...: any)
		local CallId = Identifier.Unique()

		return unpack(Net.Client.CallAsync(self.Id, table.pack(CallId, ...)))
	end, ...)
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

		SetCallback = SetCallback,
		Call = Call,
	} :: any
end

return Function
