local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(script.Parent.Parent.Promise)
local Spawn = require(script.Parent.Parent.Spawn)

local Event = require(script.Parent.Event)

local Remote = ReplicatedStorage:WaitForChild("RedEvent") :: RemoteEvent
local ClientEvent = {}

type Data = { [number]: any }
type EventMap = { [string]: { Data } }

ClientEvent.ListenerMap = {} :: { [string]: (...any) -> () }
ClientEvent.OutgoingMap = {} :: { Fire: EventMap?, Call: EventMap? }
ClientEvent.ActiveCallMap = {} :: { [string]: { Resolve: (...any) -> (), Reject: (...any) -> () } }

function ClientEvent.Start()
	debug.setmemorycategory("Red.ClientEvent.Start")

	Remote.OnClientEvent:Connect(function(FireSection, CallSection)
		debug.profilebegin("Red.ClientEvent.Start")

		if FireSection then
			debug.profilebegin("Red.ClientEvent.Start.Fire")

			for EventId, CallList in FireSection do
				local Callback = ClientEvent.ListenerMap[EventId]

				if Callback then
					for _, Call in CallList do
						Spawn(Callback, unpack(Call))
					end
				end
			end

			debug.profileend()
		end

		if CallSection then
			debug.profilebegin("Red.ClientEvent.Start.Call")

			for _, Call in CallSection do
				local CallId = table.remove(Call, 1) :: any

				if ClientEvent.ActiveCallMap[CallId] then
					if table.remove(Call, 1) then
						ClientEvent.ActiveCallMap[CallId].Resolve(unpack(Call))
					else
						ClientEvent.ActiveCallMap[CallId].Reject(unpack(Call))
					end

					ClientEvent.ActiveCallMap[CallId] = nil
				end
			end

			debug.profileend()
		end

		debug.profileend()
	end)

	RunService.Heartbeat:Connect(function()
		debug.profilebegin("Red.ClientEvent.Outgoing")

		if ClientEvent.OutgoingMap.Call or ClientEvent.OutgoingMap.Fire then
			Remote:FireServer(ClientEvent.OutgoingMap.Fire, ClientEvent.OutgoingMap.Call)

			table.clear(ClientEvent.OutgoingMap)
		end

		debug.profileend()
	end)
end

function ClientEvent.Fire(EventId: string, Args: { any })
	if not ClientEvent.OutgoingMap.Fire then
		ClientEvent.OutgoingMap.Fire = {}
	end

	if not (ClientEvent.OutgoingMap.Fire :: any)[EventId] then
		(ClientEvent.OutgoingMap.Fire :: any)[EventId] = {}
	end

	table.insert((ClientEvent.OutgoingMap.Fire :: any)[EventId], Args)
end

function ClientEvent.Call(EventId: string, Args: { any })
	return Promise.new(function(Resolve, Reject)
		local CallId = Event.Unique()

		if not ClientEvent.OutgoingMap.Call then
			ClientEvent.OutgoingMap.Call = {}
		end

		if not (ClientEvent.OutgoingMap.Call :: any)[EventId] then
			(ClientEvent.OutgoingMap.Call :: any)[EventId] = {}
		end

		table.insert(Args, 1, CallId)
		table.insert((ClientEvent.OutgoingMap.Call :: any)[EventId], Args)

		ClientEvent.ActiveCallMap[CallId] = { Resolve = Resolve, Reject = Reject }
	end)
end

function ClientEvent.Listen(EventId: string, Callback: (Player, ...any) -> ())
	ClientEvent.ListenerMap[EventId] = Callback
end

return ClientEvent
