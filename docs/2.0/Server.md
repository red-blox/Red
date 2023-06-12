# Server

A Server Namespace object. All networking on the server is done through this object.

## Fire

Fires an event to a single player with included data.

```lua
(
	self: Server,
	Player: Player,
	EventName: string,
	...: any
) -> ()
```

::: warning
This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded.
:::

```lua
Net:Fire(Player, "EventName", "Hello World", 1, 2, 3)
```

## FireAll

Fires an event to all players with included data.

```lua
(
	self: Server,
	EventName: string,
	...: any
) -> ()
```

::: warning
This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded.
:::

```lua
Net:FireAll("EventName", "Hello World", 1, 2, 3)
```

## FireAllExcept

Fires an event to all players except one with included data.

```lua
(
	self: Server,
	Except: Player,
	EventName: string,
	...: any
) -> ()
```

::: warning
This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded.
:::

```lua
Net:FireAllExcept(Player, "EventName", "Hello World", 1, 2, 3)
```

## FireList

Fires an event to a list of players with included data.

```lua
(
	self: Server,
	Players: {Player},
	EventName: string,
	...: any
) -> ()
```

::: warning
This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded.
:::

```lua
Net:FireList({Player}, "EventName", "Hello World", 1, 2, 3)
```

## FireWithFilter

Fires an event to all players with included data, but only if the filter function returns true.

```lua
(
	self: Server,
	Filter: (Player) -> boolean,
	EventName: string,
	...: any
) -> ()
```

::: warning
This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded.
:::

```lua
Net:FireWithFilter(function(Player)
	return Player.Team.Name == "Red"
end, "EventName", "Hello World", 1, 2, 3)
```

## On

Sets the listener for an event.

```lua
(
	self: Server,
	EventName: string,
	Listener: (Player, ...: any) -> (...any)
) -> ()
```

Each event can only have one callback. An attempt to register a second callback will overwrite the first. The passed function will also be used for function-like events. If the client requests a call, any returned values from the callback will be sent back to the client.

```lua
Net:On("EventName", function(Player, ...)
	print("EventName fired by", Player, "with", ...)
end)
```

## Folder

Retrieves a shared namespace folder.

```lua
(
	self: Server,
	Player: Player?
) -> Folder
```

This method returns a Folder that is shared between the server and client. This folder can be used to store data that is shared between the two.

```lua
local Folder = Net:Folder()

-- Using attributes is generally considered a good idea
Folder:SetAttribute("Hello", "World")

-- Attribute names are expensive, consider using Identifiers for them
Folder:SetAttribute(Red.Identifier.UInt(1), "World")
```

If you specify the optional `Player` argument, the folder will only be shared with that player. Otherwise the folder will be shared with all players. This is done by placing the folder inside the player's `PlayerGui`.

```lua
local Folder = Net:Folder(Player)

-- These are still folder instances, they just only replicate to a specific player
Folder:SetAttribute("Hello", "World")
Folder:SetAttribute(Red.Identifier.UInt(1), "World")
```
