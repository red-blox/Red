# Server Usage

Before we do anything else we must retrieve the event, specifically the server event object.

```lua
local MyEvent = require(ReplicatedStorage.Events.MyEvent):Server()
```

Note that we required the event module and called `:Server()` on the event object. At this point we have the server event object and can use it to fire and listen to the event.

## Event Module

For simplicity we'll be using the same event module throughout this guide.

```lua
local Guard = require(Path.To.Guard)
local Red = require(Path.To.Red)

return Red.Event(function(Number, String, Boolean)
	return Guard.Number(Number), Guard.String(String), Guard.Boolean(Boolean)
end)
```

This event has three payloads, a number, string, and boolean. The callback will error if the types are invalid, and return the values if they are valid.

## Firing Events

In constrast to the client, the server exposes many methods to fire events.

### Fire

```lua
MyEvent:Fire(Player, 1, "Hello", true)
```

This method fires an event to player passed as the first argument, and any payload passed after.

### FireAll

```lua
MyEvent:FireAll(1, "Hello", true)
```

This will fire the event and payload to all players, and as such does not have a player argument - only payload.

### FireAllExcept

```lua
MyEvent:FireAllExcept(Player, 1, "Hello", true)
```

This is the exact same as `FireAll`, *except* that it does not fire to the player passed as the first argument.

### FireList

```lua
MyEvent:FireList({ Player }, 1, "Hello", true)
```

This method accepts a list of players as the first argument, and fires the event to all of them. The payload is passed after the player list.

### FireWithFilter

```lua
MyEvent:FireWithFilter(function(Player)
	return Player.Team.Name == "Red"
end, 1, "Hello", true)
```

This method accepts a filter function as the first argument, and fires the event to all players where the filter function returns true. The payload is passed after the filter function.

## Listening to Events

Listening to events in Red is different than what is common. In most libraries you can connect **many** listeners to an event, however in Red you can only set a **single** listener to each event. Attempting to set multiple listeners will result in an error.

```lua
MyEvent:On(function(Player, Number, String, Boolean)
	print(Player, Number, String, Boolean)
end)
```

Listeners are set using the `On` method. They are passed the player who fired the event, and any payload passed after. Before the listener is called the validation callback is called to check the validity of the payload.
