# Function

Functions allow RemoteFunction-like behavior in Red for calling client -> server.

## SetCallback

Sets the function's callback.

```lua
<A..., R...>(
	Callback: (Player, A...) -> R... -- The callback to set.
) -> ()
```

A singular callback must be set on the server to allow clients to call the function. This callback is given the arguments and must return the expected return values. This callback may only be set on the server, attempting to set it on the client will result in an error.

```lua
local Function = require(Path.To.Function)

Function:SetCallback(function(Player, Arg1, Arg2, Arg3)
	return Arg1, Arg2, Arg3
end)
```

::: danger
If the callback errors the client will never recieve any value and will yield forever. **Doing this is a memory leak!** Do not rely on erroring not sending back values.
:::

## Call

Calls the function on the server.

```lua
<A..., R...>(
	...A: any -- The arguments to pass to the function.
) -> Future<R...>
```

A function is called on the client to call the function on the server. This method returns a [Future](https://util.redblox.dev/future) which can be used to await the return values or connect a function to be called when the return values are received.

```lua
local Function = require(Path.To.Function)

local Ret1, Ret2, Ret3 = Function:Call(Arg1, Arg2, Arg3):Await()
```
