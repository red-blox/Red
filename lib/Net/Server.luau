local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Guard = require(script.Parent.Parent.Parent.Guard)

local ReliableRemote = ReplicatedStorage:WaitForChild("ReliableRedEvent") :: RemoteEvent
local UnreliableRemote = ReplicatedStorage:WaitForChild("UnreliableRedEvent") :: RemoteEvent

local FireSectionCheck = Guard.Check(Guard.Map(Guard.String, Guard.List(Guard.Any)))
local CallSectionCheck = Guard.Check(Guard.Map(Guard.String, Guard.List(Guard.Any)))

local ListenerMap: { [string]: (Player, { any }) -> () } = {}
local OutgoingMap: {
	[Player]: {
		Reliable: { [string]: { { any } } },
		CallReturn: { [string]: { any } },
	},
} = {}

local function SendReliableEvent(Player: Player, EventId: string, Args: { any })
	if not OutgoingMap[Player] then
		OutgoingMap[Player] = {
			Reliable = {},
			CallReturn = {},
		}
	end

	if not OutgoingMap[Player].Reliable[EventId] then
		OutgoingMap[Player].Reliable[EventId] = {}
	end

	table.insert(OutgoingMap[Player].Reliable[EventId], Args)
end

local function SendUnreliableEvent(Player: Player, EventId: string, Args: { any })
	UnreliableRemote:FireClient(Player, EventId, Args)
end

local function SetListener(EventId: string, Callback: (Player, { any }) -> ())
	ListenerMap[EventId] = Callback
end

local function SendCallReturn(Player: Player, CallId: string, Args: { any })
	if not OutgoingMap[Player] then
		OutgoingMap[Player] = {
			Reliable = {},
			CallReturn = {},
		}
	end

	OutgoingMap[Player].CallReturn[CallId] = Args
end

local function Start()
	ReliableRemote.OnServerEvent:Connect(function(Player, IncomingFireSection, IncomingCallSection)
		local FireSectionValid, FireSection = FireSectionCheck(IncomingFireSection)

		if FireSectionValid then
			for EventId, CallList in FireSection do
				local Callback = ListenerMap[EventId]

				if Callback then
					for _, Call in CallList do
						Callback(Player, Call)
					end
				end
			end
		end

		local CallSectionValid, CallSection = CallSectionCheck(IncomingCallSection)

		if CallSectionValid then
			for EventId, CallList in CallSection do
				local Callback = ListenerMap[EventId]

				if Callback then
					for _, Call in CallList do
						Callback(Player, Call)
					end
				else
					for _, Call in CallList do
						local CallId = Call[1]

						SendCallReturn(Player, CallId, { false, "Event has no listener." })
					end
				end
			end
		end
	end)

	UnreliableRemote.OnServerEvent:Connect(function(Player, IncomingEventId, IncomingArgs)
		if type(IncomingEventId) == "string" and type(IncomingArgs) == "table" then
			local Callback = ListenerMap[IncomingEventId]

			if Callback then
				Callback(Player, IncomingArgs)
			end
		end
	end)

	RunService.Heartbeat:Connect(function()
		for Player, Outgoing in OutgoingMap do
			if next(Outgoing.Reliable) or next(Outgoing.CallReturn) then
				ReliableRemote:FireClient(Player, Outgoing.Reliable, Outgoing.CallReturn)
			end

			OutgoingMap[Player] = nil
		end
	end)
end

return {
	SendReliableEvent = SendReliableEvent,
	SendUnreliableEvent = SendUnreliableEvent,
	SetListener = SetListener,
	SendCallReturn = SendCallReturn,
	Start = Start,
}
