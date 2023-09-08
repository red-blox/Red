# Declaring Events

Events in Red are declared in shared modules. Each one of these modules contains one event. Declaring events in this way enables strict typing with luau for the event's payload.

Create a module in ReplicatedStorage. Inside the module import Red, and return a new event.

```lua
local Red = require(Path.To.Red)

return Red.Event(function()
	return
end)
```

This is the most basic event in Red. Here we've declared an event which has no payload. The event name is gathered from the module name.

::: danger
Make sure the module name is unique - modules with the same name will return the same event. If you need to create events without using module name, `Red.Event` has a second string argument that can be used to override the name of the event. These name overrides must still be unique.
:::

## Event Payloads

We now have an event - but we can't send any data with it. To send a payload with our event we must modify the callback we passed to `Red.Event`.

This callback is a validation check callback. This callback's purpose is to assert the types of the payload.

```lua
return Red.Event(function(Value)
	assert(type(Value) == "number")

	return Value
end)
```

This callback has a few rules:

1. The callback returns the arguments in the same order they were passed in.
2. The callback must error if the arguments are invalid.
3. The callback must narrow the types of the arguments.

::: info
This callback is only called when a client fires the event to the server. Do not use this callback as middleware, logging, or other side effects.
:::

Following the first two rules is fairly simple, however the third rule is a bit more complex - yet still necessary. Narrowing and checking simple types is very easy (like in the example above), but when it comes to complex types it can be more difficult.

You can use a library like [Guard](https://util.redblox.dev/guard) to both narrow and check types at the same time.

```lua
local Guard = require(Path.To.Guard)

local Check = Guard.Map(Guard.String, Guard.List(Guard.Number))

return Red.Event(function(Value)
	return Check(Value)
end)
```

Guard will both check your types by erroring if they don't match, and narrow the types by returning the value. This is the recommended way to check and narrow types.

## Multiple Payloads

Events can have multiple payloads expressed as a tuple. The following event is for a squad add and remove system.

```lua
local ActionCheck = Guard.Or(Guard.Literal("Add"), Guard.Literal("Remove"))
local PlayerCheck = function(Value: unknown)
	assert(typeof(Value) == "Instance")
	assert(Value:IsA("Player"))

	return Value
end

return Red.Event(function(Action, Player)
	return ActionCheck(Action), PlayerCheck(Player)
end)
```

::: warning
Ensure you follow rule 1 when using multiple payloads. The callback must return the arguments in the same order they were passed in.
:::
