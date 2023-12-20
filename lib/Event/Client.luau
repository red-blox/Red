local Spawn = require(script.Parent.Parent.Parent.Spawn)

local Net = require(script.Parent.Parent.Net)

export type Client<T...> = {
	Id: string,

	Unreliable: boolean,

	Fire: (self: Client<T...>, T...) -> (),
	On: (self: Client<T...>, Callback: (T...) -> ()) -> (),
}

local function Fire<T...>(self: Client<T...>, ...: T...)
	if self.Unreliable then
		Net.Client.SendUnreliableEvent(self.Id, table.pack(...))
	else
		Net.Client.SendReliableEvent(self.Id, table.pack(...))
	end
end

local function On<T...>(self: Client<T...>, Callback: (T...) -> ())
	Net.Client.SetListener(self.Id, function(Args)
		Spawn(Callback, table.unpack(Args))
	end)
end

local function Client<T...>(Id: string, Unreliable: boolean): Client<T...>
	return {
		Id = Id,

		Unreliable = Unreliable,

		Fire = Fire,
		On = On,
	} :: any
end

return Client
