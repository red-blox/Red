local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ComplexFunction = require(ReplicatedStorage.ComplexFunction)
local EmptyFunction = require(ReplicatedStorage.EmptyFunction)
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

task.wait(0.5)

print("Firing Ready")

ReadyEvent:Fire()
