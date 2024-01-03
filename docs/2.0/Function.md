# Function

Functions allow RemoteFunction-like behavior in Red for calling client -> server.

## SetCallback <Badge type="tip" text="Server"></Badge>

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

## Call <Badge type="warning" text="Client"></Badge>

Calls the function on the server.

```lua
<A..., R...>(
	...A: any -- The arguments to pass to the function.
) -> Future<boolean, R...> -- A success boolean followed by the returned values
```

Functions can only be called from the client. The client must pass valid arguments to the function, and will be given back a [Future](https://util.redblox.dev/future) that completes with the returned values.

It also returns a success boolean, similar to pcall, which is false if the server's callback function errored, and true if it was successful.

```lua
local Function = require(Path.To.Function)

local Success, Ret1, Ret2, Ret3 = Function:Call(Arg1, Arg2, Arg3):Await()
```
