# Functions

Functions are Red's version of RemoteFunctions. If you don't know what they are, it's a way to call code on the server from the client and get return values. Red only allows clients to call the server, not the server to call clients.

## Declaring

Functions are declared similarly to events, they take two validation callbacks: one for the arguments and one for the return value.

```lua
local Red = require(Path.To.Red)

return Red.Function("FunctionName", function(Arg1, Arg2, Arg3)
	assert(type(Arg1) == "string")
	assert(type(Arg2) == "number")
	assert(type(Arg3) == "boolean")

	return Arg1, Arg2, Arg3
end, function(Ret1, Ret2, Ret3)
	assert(type(Ret1) == "string")
	assert(type(Ret2) == "number")
	assert(type(Ret3) == "boolean")

	return Ret1, Ret2, Ret3
end)
```

These callbacks must follow the same three rules that event validation callbacks do:

1. The callback returns the arguments in the same order they were passed in.
2. The callback must error if the arguments are invalid.
3. The callback must narrow the types of the arguments.

These callbacks are only called in specific circumstances. Do not use these callbacks as middleware, logging, or other side effects.

::: tip
I once again suggest using [Guard](https://util.redblox.dev/guard) to both narrow and check types at the same time.

```lua
local Red = require(Path.To.Red)
local Guard = require(Path.To.Guard)

local CheckArg1 = Guard.Map(Guard.String, Guard.Number)
local CheckArg2 = Guard.List(Guard.Vector3)
local CheckArg3 = Guard.Boolean

local CheckRet1 = Guard.String
local CheckRet2 = Guard.Number
local CheckRet3 = Guard.Set(Guard.String)

return Red.Function("FunctionName", function(Arg1, Arg2, Arg3)
	return CheckArg1(Arg1), CheckArg2(Arg2), CheckArg3(Arg3)
end, function(Ret1, Ret2, Ret3)
	return CheckRet1(Ret1), CheckRet2(Ret2), CheckRet3(Ret3)
end)
```

:::

## Set Callback

A singular callback must be set on the server to allow clients to call the event. This callback is given the arguments and must return the expected return values.

```lua
local Function = require(Path.To.Function)

Function:SetCallback(function(Player, Arg1, Arg2, Arg3)
	return Arg1, Arg2, Arg3
end)
```

::: danger
If the callback errors then the client will never recieve any value and will yield forever. **Doing this is a memory leak!** Do not rely on erroring not sending back values.
:::

## Calling

Functions can only be called from the client. The client must pass valid arguments to the function, and will be given back a [Future](https://util.redblox.dev/future) that completes with the returned values.

```lua
local Function = require(Path.To.Function)

local Ret1, Ret2, Ret3 = Function:Call("Hello", 1, true):Await()
```
