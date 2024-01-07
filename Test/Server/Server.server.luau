local ReplicatedStorage = game:GetService("ReplicatedStorage")

function TestEvents()
	local ComplexFunction = require(ReplicatedStorage.ComplexFunction)
	local SimpleFunction = require(ReplicatedStorage.SimpleFunction)
	local EmptyFunction = require(ReplicatedStorage.EmptyFunction)
	local ErrorFunction = require(ReplicatedStorage.ErrorFunction)

	local ComplexEvent = require(ReplicatedStorage.ComplexEvent):Server()
	local SimpleEvent = require(ReplicatedStorage.SimpleEvent):Server()
	local EmptyEvent = require(ReplicatedStorage.EmptyEvent):Server()
	local ReadyEvent = require(ReplicatedStorage.ReadyEvent):Server()

	print("Registering Function Callbacks")

	ComplexFunction:SetCallback(function(Player, Value1, Value2, Value3)
		print("ComplexFunction", Player, Value1, Value2, Value3)
		task.wait(0.2)

		return Value1, Value2, Value3
	end)

	SimpleFunction:SetCallback(function(Player, Value)
		print("SimpleFunction", Player, Value)

		return tostring(Value)
	end)

	EmptyFunction:SetCallback(function(Player)
		print("EmptyFunction", Player)

		return
	end)

	ErrorFunction:SetCallback(function(Player)
		assert(1 == 2, "Assert failed.")
		return ""
	end)

	print("Registering Event Listeners")

	ComplexEvent:On(function(Player, Value1, Value2, Value3)
		print("ComplexEvent", Player, Value1, Value2, Value3)
	end)

	SimpleEvent:On(function(Player, Value)
		print("SimpleEvent", Player, Value)
	end)

	EmptyEvent:On(function(Player)
		print("EmptyEvent", Player)
	end)

	ReadyEvent:On(function(Player)
		print(`[{Player.Name}] Ready, firing events!`)

		print(`[{Player.Name}] :Fire`)
		SimpleEvent:Fire(Player, 1)
		EmptyEvent:Fire(Player)
		ComplexEvent:Fire(Player, nil, "hello world again", 1)

		print(`[{Player.Name}] :FireAll`)
		SimpleEvent:FireAll(2)
		EmptyEvent:FireAll()
		ComplexEvent:FireAll(
			{ one = { "String Literal", 123 }, two = { 123, "String Literal" } },
			"hello world again",
			2
		)

		print(`[{Player.Name}] :FireAllExcept`)
		SimpleEvent:FireAllExcept(Player, 3)
		EmptyEvent:FireAllExcept(Player)
		ComplexEvent:FireAllExcept(Player, nil, "this should be skipped", 3)

		print(`[{Player.Name}] :FireList`)
		SimpleEvent:FireList({ Player }, 4)
		EmptyEvent:FireList({ Player })
		ComplexEvent:FireList({ Player }, { one = { "String Literal", 8 }, two = { 1, "String Literal" } }, "hi", 4)

		print(`[{Player.Name}] :FireWithFilter`)
		SimpleEvent:FireWithFilter(function(OtherPlayer)
			return OtherPlayer.Name == Player.Name
		end, 5)
		EmptyEvent:FireWithFilter(function(OtherPlayer)
			return OtherPlayer.Name == Player.Name
		end)
		ComplexEvent:FireWithFilter(function(OtherPlayer)
			return OtherPlayer.Name == Player.Name
		end, { one = { "String Literal", 17 }, two = { 123, "String Literal" } }, "another string", 5)

		print(`[{Player.Name}] Done!`)
	end)
end

function TestSharedEvents()
	print("Testing Shared Events")
	local SharedEvents = require(ReplicatedStorage.SharedEvents)

	print("Registering Event Listeners")

	SharedEvents.Complex:SetServerListener(function(Player, Value1, Value2, Value3)
		print("ComplexEvent", Player, Value1, Value2, Value3)
	end)

	SharedEvents.Simple:SetServerListener(function(Player, Value)
		print("SimpleEvent", Player, Value)
	end)

	SharedEvents.Empty:SetServerListener(function(Player)
		print("EmptyEvent", Player)
	end)

	SharedEvents.Signal:OnServer(function(Player, Value)
		print("SignalEvent1", Player, Value)
	end)
	SharedEvents.Signal:OnServer(function(Player, Value)
		print("SignalEvent2", Player, Value)
	end)

	SharedEvents.Ready:SetServerListener(function(Player)
		print(`[{Player.Name}] Ready, firing events!`)

		print(`[{Player.Name}] :FireClient`)
		SharedEvents.Empty:FireClient(Player)
		SharedEvents.Simple:FireClient(Player, 1)
		SharedEvents.Signal:FireClient(Player, 1)
		SharedEvents.Complex:FireClient(Player, nil, "hello world again", 1)

		print(`[{Player.Name}] :FireAllClients`)
		SharedEvents.Empty:FireAllClients()
		SharedEvents.Simple:FireAllClients(2)
		SharedEvents.Signal:FireAllClients(2)
		SharedEvents.Complex:FireAllClients(
			{ one = { "String Literal", 123 }, two = { 123, "String Literal" } },
			"hello world again",
			2
		)

		print(`[{Player.Name}] :FireAllClientsExcept`)
		SharedEvents.Empty:FireAllClientsExcept(Player)
		SharedEvents.Simple:FireAllClientsExcept(Player, 3)
		SharedEvents.Signal:FireAllClientsExcept(Player, 3)
		SharedEvents.Complex:FireAllClientsExcept(Player, nil, "this should be skipped", 3)

		print(`[{Player.Name}] :FireClients`)
		SharedEvents.Empty:FireClients({ Player })
		SharedEvents.Simple:FireClients({ Player }, 4)
		SharedEvents.Signal:FireClients({ Player }, 4)
		SharedEvents.Complex:FireClients(
			{ Player },
			{ one = { "String Literal", 8 }, two = { 1, "String Literal" } },
			"hi",
			4
		)

		print(`[{Player.Name}] :FireFilteredClients`)
		SharedEvents.Empty:FireFilteredClients(function(OtherPlayer)
			return OtherPlayer.Name == Player.Name
		end)
		SharedEvents.Simple:FireFilteredClients(function(OtherPlayer)
			return OtherPlayer.Name == Player.Name
		end, 5)
		SharedEvents.Signal:FireFilteredClients(function(OtherPlayer)
			return OtherPlayer.Name == Player.Name
		end, 5)
		SharedEvents.Complex:FireFilteredClients(function(OtherPlayer)
			return OtherPlayer.Name == Player.Name
		end, { one = { "String Literal", 17 }, two = { 123, "String Literal" } }, "another string", 5)

		print(`[{Player.Name}] Done!`)
	end)
end

TestEvents()
-- TestSharedEvents()
