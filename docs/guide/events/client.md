# Client Usage

Just like on the server, we must retrieve the event object before we can do anything else.

```lua
local MyEvent = require(ReplicatedStorage.Events.MyEvent):Client()
```

We'll also use the same event module as on the server.

```lua
local Guard = require(Path.To.Guard)
local Red = require(Path.To.Red)

return Red.Event(function(Number, String, Boolean)
	return Guard.Number(Number), Guard.String(String), Guard.Boolean(Boolean)
end)
```

## Firing Events

The client exposes only one method to fire events to the server.

```lua
MyEvent:Fire(1, "Hello", true)
```

This method accepts payload(s) and fires them to the server. The server will receive the payload(s) in the same order they were passed to `:Fire`.

## Listening to Events

As with the server, the client can only have one listener for each event.

```lua
MyEvent:On(function(Number, String, Boolean)
	print(Number, String, Boolean)
end)
```

Listeners are passed the payload(s) sent by the server.
