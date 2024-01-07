local ReplicatedStorage = game:GetService("ReplicatedStorage")

function TestEvents()
	local ComplexFunction = require(ReplicatedStorage.ComplexFunction)
	local EmptyFunction = require(ReplicatedStorage.EmptyFunction)
	local ErrorFunction = require(ReplicatedStorage.ErrorFunction)
	local SimpleFunction = require(ReplicatedStorage.SimpleFunction)

	local ComplexEvent = require(ReplicatedStorage.ComplexEvent):Client()
	local SimpleEvent = require(ReplicatedStorage.SimpleEvent):Client()
	local EmptyEvent = require(ReplicatedStorage.EmptyEvent):Client()
	local ReadyEvent = require(ReplicatedStorage.ReadyEvent):Client()
	task.wait(0.5)

	print("Registering Listeners")

	ComplexEvent:On(function(Value1, Value2, Value3)
		print("ComplexEvent", Value1, Value2, Value3)
	end)

	SimpleEvent:On(function(Value)
		print("SimpleEvent", Value)
	end)

	EmptyEvent:On(function()
		print("EmptyEvent")
	end)

	task.wait(0.5)

	print("Firing Events")

	ComplexEvent:Fire({ one = { "String Literal", 123 }, two = { 123, "String Literal" } }, "hello world again", 123)
	SimpleEvent:Fire(123)
	EmptyEvent:Fire()

	task.wait(0.5)

	print("Calling Functions")

	print(ComplexFunction:Call({ one = { "String Literal", 123 }, two = { 123, "String Literal" } }, "hi", 12):Await())
	print(SimpleFunction:Call(123):Await())
	print(EmptyFunction:Call():Await())
	print(ErrorFunction:Call():Await())

	task.wait(0.5)

	print("Firing Ready")

	ReadyEvent:Fire()
end

function TestSharedEvents()
	print("Testing Shared Events!")
	local SharedEvents = require(ReplicatedStorage.SharedEvents)

	task.wait(0.5)
	print("Registering Listeners")

	SharedEvents.Empty:SetClientListener(function()
		print("Received empty!")
	end)

	SharedEvents.Simple:SetClientListener(function(Value)
		print("Received simple!", Value)
	end)

	SharedEvents.Signal:OnClient(function(Value)
		print("Signal 1 called!", Value)
	end)
	SharedEvents.Signal:OnClient(function(Value)
		print("Signal 2 called!", Value)
	end)

	SharedEvents.Complex:SetClientListener(function(Value1, Value2, Value3)
		print("Received complex!", Value1, Value2, Value3)
	end)

	task.wait(0.5)
	print("Firing events")

	SharedEvents.Empty:FireServer()
	SharedEvents.Simple:FireServer(5)
	SharedEvents.Signal:FireServer(6)
	SharedEvents.Complex:FireServer(
		{ one = { "String Literal", 17 }, two = { 123, "String Literal" } },
		"another string",
		5
	)

	task.wait(0.5)
	print("Firing ready")
	SharedEvents.Ready:FireServer()
end

TestEvents()
-- TestSharedEvents()
