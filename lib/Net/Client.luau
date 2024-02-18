local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ReliableRemote = ReplicatedStorage:WaitForChild("ReliableRedEvent") :: RemoteEvent
local UnreliableRemote = ReplicatedStorage:WaitForChild("UnreliableRedEvent") :: RemoteEvent

local ListenerMap: { [string]: ({ any }) -> () } = {}
local CallMap: { [string]: thread } = {}
local Outgoing: {
	Reliable: { [string]: { { any } } },
	Call: { [string]: { { any } } },
} = {
	Reliable = {},
	Call = {},
}

local function SendReliableEvent(EventId: string, CallList: { any })
	if not Outgoing.Reliable[EventId] then
		Outgoing.Reliable[EventId] = {}
	end

	table.insert(Outgoing.Reliable[EventId], CallList)
end

local function SendUnreliableEvent(EventId: string, CallList: { any })
	UnreliableRemote:FireServer(EventId, CallList)
end

local function SetListener(EventId: string, Callback: ({ any }) -> ())
	ListenerMap[EventId] = Callback
end

local function CallAsync(EventId: string, CallList: { any }): { any }
	if not Outgoing.Call[EventId] then
		Outgoing.Call[EventId] = {}
	end

	table.insert(Outgoing.Call[EventId], CallList)
	CallMap[CallList[1]] = coroutine.running()

	return coroutine.yield()
end

local function Start()
	ReliableRemote.OnClientEvent:Connect(function(IncomingFireSection, IncomingCallSection)
		if IncomingFireSection then
			for EventId, CallList in IncomingFireSection do
				local Listener = ListenerMap[EventId]

				if Listener then
					for _, Call in CallList do
						Listener(Call)
					end
				end
			end
		end

		if IncomingCallSection then
			for CallId, CallList in IncomingCallSection do
				local CallThread = CallMap[CallId]

				if CallThread then
					CallMap[CallId] = nil
					coroutine.resume(CallThread, CallList)
				end
			end
		end
	end)

	UnreliableRemote.OnClientEvent:Connect(function(IncomingEventId, IncomingArgs)
		local Listener = ListenerMap[IncomingEventId]

		if Listener then
			Listener(IncomingArgs)
		end
	end)

	RunService.Heartbeat:Connect(function()
		if next(Outgoing.Reliable) or next(Outgoing.Call) then
			ReliableRemote:FireServer(Outgoing.Reliable, Outgoing.Call)

			Outgoing.Reliable = {}
			Outgoing.Call = {}
		end
	end)
end

return {
	SendReliableEvent = SendReliableEvent,
	SendUnreliableEvent = SendUnreliableEvent,
	SetListener = SetListener,
	CallAsync = CallAsync,
	Start = Start,
}
