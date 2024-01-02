# SharedSignalEvent
SharedEvents are built on the same backend networking as regular events. However, they do not require an explicit `:Server` or `:Client` call to use.

Unlike [SharedEvents](SharedEvent), SharedSignalEvents may have any number of listeners set.

## OnServer <Badge type="tip" text="Server"></Badge>
Sets the server callback.
```lua
<T...>(
    Listener: (Player: Player, T...) -> () -- The listener to register
) -> ()
```
This method sets the server callback. Errors if called from the client.
```lua
MyEvent:OnServer(function(Player, Argument)
    print(Player, Argument)
end)
```

## OnClient <Badge type="warning" text="Client"></Badge>
Sets the client callback.
```lua
<T...>(
    Listener: (T...) -> () -- The listener to register
) -> ()
```
This method sets the client callback. Errors if called from the server.
```lua
MyEvent:OnClient(function(Argument)
    print(Argument)
end)
```

## FireServer <Badge type="warning" text="Client"></Badge>
Fires the event to the server.
```lua
<T...>(
    ...: T... -- The event payload
) -> ()
```
This method fires the event to the server. Errors if called from the server.
```lua
MyEvent:FireServer("Hello, World!")
```

## FireClient <Badge type="tip" text="Server"></Badge>
Fires the event to a specific player.
```lua
<T...>(
    Player: Player, -- The target player
    ...: T... -- The event payload
) -> ()
```
This method fires the event to a specific client. Errors if called from the client.
```lua
MyEvent:FireClient(player, "Hello, World!")
```

## FireAllClients <Badge type="tip" text="Server"></Badge>
Fires the event to all players.
```lua
<T...>(
    ...: T... -- The event payload
) -> ()
```
This method fires the event to all players. Errors if called from the client.
```lua
MyEvent:FireAllClients("Hello, World!")
```

## FireAllClientsExcept <Badge type="tip" text="Server"></Badge>
Fires the event to every player **except** one.
```lua
<T...>(
    Player: Player, -- Player to be ignored
    ...: T...  -- The event payload
)
```
This method fires the event to every player except one. Errors if called from the client.
```lua
MyEvent:FireAllClientsExcept(player, "Hello, World!")
```

## FireClients <Badge type="tip" text="Server"></Badge>
Fires the event to every player in the given list.
```lua
<T...>(
    Players: { Player }, -- List of players to fire the event to
    ...: T... -- The event payload
) -> ()
```
This method fires the event to every player in the list. Errors if called from the client.
```lua
MyServer:FireClients({ player }, "Hello, World!")
```

## FireFilteredClients <Badge type="tip" text="Server"></Badge>
Fires the event to every player that passes the given filter function.
```lua
<T...>(
    Filter: (Player) -> boolean -- Must return true for a player to receive the event.
    ...: T... -- The event payload
) -> ()
```
This method fires the event to every player that passes the filter. Errors if called from the client.
```lua
MyServer:FireFilteredClients(function(player)
	return player.Name == "Player1"
end, "Hello, World!")
```