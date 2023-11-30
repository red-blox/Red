local Players = game:GetService("Players")

local Spawn = require(script.Parent.Parent.Parent.Spawn)

local Net = require(script.Parent.Parent.Net)

export type Server<T...> = {
	Id: string,
	Validate: (...unknown) -> T...,

	Fire: (self: Server<T...>, Player: Player, T...) -> (),
	FireAll: (self: Server<T...>, T...) -> (),
	FireAllExcept: (self: Server<T...>, Except: Player, T...) -> (),
	FireList: (self: Server<T...>, List: { Player }, T...) -> (),
	FireWithFilter: (self: Server<T...>, Filter: (Player) -> boolean, T...) -> (),

	On: (self: Server<T...>, Callback: (Player, T...) -> ()) -> (),
}

local function Fire<T...>(self: Server<T...>, Player: Player, ...: T...)
	Net.Server.SendReliableEvent(Player, self.Id, table.pack(...))
end

local function FireAll<T...>(self: Server<T...>, ...: T...)
	local Args = table.pack(...)

	for _, Player in Players:GetPlayers() do
		Net.Server.SendReliableEvent(Player, self.Id, Args)
	end
end

local function FireAllExcept<T...>(self: Server<T...>, Except: Player, ...: T...)
	local Args = table.pack(...)

	for _, Player in Players:GetPlayers() do
		if Player ~= Except then
			Net.Server.SendReliableEvent(Player, self.Id, Args)
		end
	end
end

local function FireList<T...>(self: Server<T...>, List: { Player }, ...: T...)
	local Args = table.pack(...)

	for _, Player in List do
		Net.Server.SendReliableEvent(Player, self.Id, Args)
	end
end

local function FireWithFilter<T...>(self: Server<T...>, Filter: (Player) -> boolean, ...: T...)
	local Args = table.pack(...)

	for _, Player in Players:GetPlayers() do
		if Filter(Player) then
			Net.Server.SendReliableEvent(Player, self.Id, Args)
		end
	end
end

local function On<T...>(self: Server<T...>, Callback: (Player, T...) -> ())
	Net.Server.SetListener(self.Id, function(Player, Args)
		Spawn(function(self: typeof(self), Player: Player, ...: any)
			if self.Validate(...) then
				Callback(Player, ...)
			end
		end, self, Player, table.unpack(Args))
	end)
end

local function Server<T...>(Id: string, Validate: (...unknown) -> T...): Server<T...>
	return {
		Id = Id,
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
