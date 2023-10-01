local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ComplexEvent = require(ReplicatedStorage.ComplexEvent):Client()
local SimpleEvent = require(ReplicatedStorage.SimpleEvent):Client()
local EmptyEvent = require(ReplicatedStorage.EmptyEvent):Client()
local ReadyEvent = require(ReplicatedStorage.ReadyEvent):Client()

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

print("Firing Events")
ComplexEvent:Fire({ one = { "String Literal", 123 }, two = { 123, "String Literal" } }, "hello world again", 123)
SimpleEvent:Fire(123)
EmptyEvent:Fire()

task.wait(1)

print("Firing Ready")
ReadyEvent:Fire()
