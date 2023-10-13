local ClientEvent = require(script.Parent.Parent.ClientEvent)

local function PackArgs(...: any)
	return { ... }
end

export type Client<T...> = {
	Id: string,
	Listening: boolean,
	Validate: (...unknown) -> T...,

	Fire: (self: Client<T...>, T...) -> (),

	On: (self: Client<T...>, Callback: (T...) -> ()) -> (),
}

local function Fire<T...>(self: Client<T...>, ...)
	ClientEvent.Fire(self.Id, PackArgs(...))
end

local function On<T...>(self: Client<T...>, Callback: (T...) -> ())
	assert(not self.Listening, "Event is already listening")
	self.Listening = true

	ClientEvent.Listen(self.Id, Callback)
end

local function Client<T...>(Id: string, Validate: (...unknown) -> T...): Client<T...>
	return {
		Id = Id,
		Listening = false,
		Validate = Validate,

		Fire = Fire,
		On = On,
	} :: any
end

return Client
