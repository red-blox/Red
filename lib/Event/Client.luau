local Spawn = require(script.Parent.Parent.Parent.Spawn)

local Net = require(script.Parent.Parent.Net)

export type Client<T...> = {
	Id: string,

	Fire: (self: Client<T...>, T...) -> (),
	On: (self: Client<T...>, Callback: (T...) -> ()) -> (),
}

local function Fire<T...>(self: Client<T...>, ...: T...)
	Net.Client.SendReliableEvent(self.Id, table.pack(...))
end

local function On<T...>(self: Client<T...>, Callback: (T...) -> ())
	Net.Client.SetListener(self.Id, function(Args)
		Spawn(Callback, table.unpack(Args))
	end)
end

local function Client<T...>(Id: string): Client<T...>
	return {
		Id = Id,

		Fire = Fire,
		On = On,
	} :: any
end

return Client
