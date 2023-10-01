local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Spawn = require(script.Parent.Parent.Spawn)
local Guard = require(script.Parent.Parent.Guard)

local Remote = ReplicatedStorage:WaitForChild("RedEvent") :: RemoteEvent
local ServerEvent = {}

type Data = { [number]: any }
type EventMap = { [string]: { Data } }

ServerEvent.ListenerMap = {} :: { [string]: (Player, ...any) -> () }
ServerEvent.OutgoingMap = {} :: { [Player]: { Fire: EventMap?, Call: { Data }? } }

local FireSectionCheck = Guard.Check(Guard.Map(Guard.String, Guard.List(Guard.Any)))
local CallSectionCheck = Guard.Check(Guard.Map(Guard.String, Guard.List(Guard.Any)))

function ServerEvent.Start()
	debug.setmemorycategory("Red.ServerEvent.Start")

	Remote.OnServerEvent:Connect(function(Player, UnknownFireSection, UnknownCallSection)
		debug.profilebegin("Red.ServerEvent.Start")

		local FireSectionValid, FireSection = FireSectionCheck(UnknownFireSection)

		if FireSectionValid then
			debug.profilebegin("Red.ServerEvent.Start.MultipleFire")

			for EventId, CallList in FireSection do
				local Callback = ServerEvent.ListenerMap[EventId]

				if Callback then
					for _, Call in CallList do
						Spawn(Callback, Player, unpack(Call))
					end
				end
			end

			debug.profileend()
		end

		local CallSectionValid, CallSection = CallSectionCheck(UnknownCallSection)

		if CallSectionValid then
			debug.profilebegin("Red.ServerEvent.Start.Call")

			for EventId, CallList in CallSection do
				local Callback = ServerEvent.ListenerMap[EventId]

				if Callback then
					for _, Call in CallList do
						Spawn(function()
							local CallId = table.remove(Call, 1) :: any
							local Result = { CallId, Callback(Player, unpack(Call)) }

							if not ServerEvent.OutgoingMap[Player] then
								ServerEvent.OutgoingMap[Player] = {}
							end

							if not ServerEvent.OutgoingMap[Player].Call then
								ServerEvent.OutgoingMap[Player].Call = {}
							end

							table.insert(ServerEvent.OutgoingMap[Player].Call :: any, Result)
						end)
					end
				else
					if not ServerEvent.OutgoingMap[Player] then
						ServerEvent.OutgoingMap[Player] = {}
					end

					if not ServerEvent.OutgoingMap[Player].Call then
						ServerEvent.OutgoingMap[Player].Call = {}
					end

					for _, Call in CallList do
						local CallId = table.remove(Call, 1) :: any
						table.insert(
							ServerEvent.OutgoingMap[Player].Call :: any,
							{ CallId, false, "Event has no listener." }
						)
					end
				end
			end

			debug.profileend()
		end

		debug.profileend()
	end)

	RunService.Heartbeat:Connect(function()
		debug.profilebegin("Red.ServerEvent.Outgoing")

		for Player, Data in ServerEvent.OutgoingMap do
			Remote:FireClient(Player, Data.Fire, Data.Call)
		end

		table.clear(ServerEvent.OutgoingMap)

		debug.profileend()
	end)
end

function ServerEvent.Fire(Player: Player, EventId: string, Args: { any })
	if not ServerEvent.OutgoingMap[Player] then
		ServerEvent.OutgoingMap[Player] = {}
	end

	if not ServerEvent.OutgoingMap[Player].Fire then
		ServerEvent.OutgoingMap[Player].Fire = {}
	end

	if not (ServerEvent.OutgoingMap[Player].Fire :: any)[EventId] then
		(ServerEvent.OutgoingMap[Player].Fire :: any)[EventId] = {}
	end

	table.insert((ServerEvent.OutgoingMap[Player].Fire :: any)[EventId], Args)
end

function ServerEvent.Listen(EventId: string, Callback: (Player, ...any) -> ...any)
	ServerEvent.ListenerMap[EventId] = Callback
end

return ServerEvent
