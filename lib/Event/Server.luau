local Players = game:GetService("Players")

local ServerEvent = require(script.Parent.Parent.ServerEvent)

local function PackArgs(...: any)
	return { ... }
end

export type Server<T...> = {
	Id: string,
	Listening: boolean,
	Validate: (...unknown) -> T...,

	Fire: (self: Server<T...>, Player: Player, T...) -> (),
	FireAll: (self: Server<T...>, T...) -> (),
	FireAllExcept: (self: Server<T...>, Except: Player, T...) -> (),
	FireList: (self: Server<T...>, List: { Player }, T...) -> (),
	FireWithFilter: (self: Server<T...>, Filter: (Player) -> boolean, T...) -> (),

	On: (self: Server<T...>, Callback: (Player, T...) -> ()) -> (),
}

local function Fire<T...>(self: Server<T...>, Player: Player, ...: T...)
	ServerEvent.Fire(Player, self.Id, PackArgs(...))
end

local function FireAll<T...>(self: Server<T...>, ...: T...)
	local Args = PackArgs(...)

	for _, Player in Players:GetPlayers() do
		ServerEvent.Fire(Player, self.Id, Args)
	end
end

local function FireAllExcept<T...>(self: Server<T...>, Except: Player, ...: T...)
	local Args = PackArgs(...)

	for _, Player in Players:GetPlayers() do
		if Player ~= Except then
			ServerEvent.Fire(Player, self.Id, Args)
		end
	end
end

local function FireList<T...>(self: Server<T...>, List: { Player }, ...: T...)
	local Args = PackArgs(...)

	for _, Player in List do
		ServerEvent.Fire(Player, self.Id, Args)
	end
end

local function FireWithFilter<T...>(self: Server<T...>, Filter: (Player) -> boolean, ...: T...)
	local Args = PackArgs(...)

	for _, Player in Players:GetPlayers() do
		if Filter(Player) then
			ServerEvent.Fire(Player, self.Id, Args)
		end
	end
end

local function On<T...>(self: Server<T...>, Callback: (Player, T...) -> ())
	assert(not self.Listening, "Event is already listening")
	self.Listening = true

	ServerEvent.Listen(self.Id, function(Player, ...)
		if pcall(self.Validate, ...) then
			Callback(Player, ...)
		end
	end)
end

local function Server<T...>(Id: string, Validate: (...unknown) -> T...): Server<T...>
	return {
		Id = Id,
		Listening = false,
		Validate = Validate,

		Fire = Fire,
		FireAll = FireAll,
		FireAllExcept = FireAllExcept,
		FireList = FireList,
		FireWithFilter = FireWithFilter,

		On = On,
	} :: any
end

return Server
