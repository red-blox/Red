# Client

The client event object.

## Fire

Fires the event to the server.

```lua
<T...>(
	...: T..., -- The event payload
) -> ()
```

This method fires the event to the server with the payload.

```lua
MyEvent:Fire("Hello, World!")
```

## On

Sets the event's listener.

```lua
<T...>(
	Listener: (...T...) -> (), -- The listener
) -> ()
```

This method sets the event's listener.

```lua
MyEvent:On(function(...)
	print(...)
end)
```
