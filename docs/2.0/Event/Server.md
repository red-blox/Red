# Server

The server event object.

## Fire

Fires the event to a single client.

```lua
<T...>(
	Player: Player, -- The client to fire to
	...: T..., -- The event payload
) -> ()
```

This method fires the event to a single client.

```lua
MyEvent:Fire(player, "Hello, World!")
```

## FireAll

Fires the event to all clients.

```lua
<T...>(
	...: T..., -- The event payload
) -> ()
```

This method fires the event to all clients.

```lua
MyEvent:FireAll("Hello, World!")
```

## FireAllExcept

Fires the event to all clients except one.

```lua
<T...>(
	Player: Player, -- The client to exclude
	...: T..., -- The event payload
) -> ()
```

This method fires the event to all clients except one.

```lua
MyEvent:FireAllExcept(player, "Hello, World!")
```

## FireList

Fires the event to a list of clients.

```lua
<T...>(
	Players: { Player }, -- The clients to fire to
	...: T..., -- The event payload
) -> ()
```

This method fires the event to a list of clients.

```lua
MyEvent:FireList({ player }, "Hello, World!")
```

## FireWithFilter

Fires the event to all clients that pass the filter.

```lua
<T...>(
	Filter: (Player) -> boolean, -- The filter function
	...: T..., -- The event payload
) -> ()
```

This method fires the event to all clients that pass the filter.

```lua
MyEvent:FireWithFilter(function(player)
	return player.Name == "Player1"
end, "Hello, World!")
```

## On

Sets the event's listener.

```lua
<T...>(
	Listener: (T...) -> (), -- The function to connect
) -> ()
```

This method sets the event's listener.

```lua
MyEvent:On(function(...)
	print(...)
end)
```

::: danger
You cannot set more than one listener for an event. Attempting to do so will result in an error.
:::
