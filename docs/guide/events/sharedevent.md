# Shared Events
Shared Events are simply a different way of using Events. They both use the same Red backend.

They have the major benefit of not needing to explicitly call `Event:Server` or `Event:Client` before being usable. Both your server and client code can simply require them and start using them.

There are two types of Shared Events: The default `SharedEvent`, and the Signal-based `SharedSignalEvent`. By default, Shared Events only allow you to set one callback function, but Shared Signal Events allow you to have any number of callbacks.

This is marginally worse for performance, as it has to use a Signal to fire the callbacks - hence why it is not the default.

::: warning
Setting the listener of a regular Shared Event twice will silently overwrite the first callback.
:::

## Declaring Shared Events
Shared Events are declared in a similar way to regular Events.

```lua
local Red = require(Path.To.Red)

return Red.SharedEvent("UniqueEventName", function()
	return
end)
```

However they also allow for another pattern, which is to declare multiple events in one file. This is possible with regular events, but it is finnicky as you still need to call `:Client` and `:Server`. It is much easier with Shared Events.

```lua
local Red = require(Path.To.Red)
local Guard = require(Path.To.Guard)

return {
    BasicEvent = Red.SharedEvent("BasicEvent", function()
	    return
    end),

    BasicSignalEvent = Red.SharedSignalEvent("BasicSignalEvent", function()
        return
    end),

    PayloadEvent = Red.SharedEvent("PayloadEvent", function(number)
        return Guard.Number(number)
    end),

    PayloadSignalEvent = Red.SharedSignalEvent("PayloadSignalEvent", function(number)
        return Guard.Number(number)
    end),

    UnreliableEvent = Red.SharedEvent({
        Name = "UnreliableEvent",
        Unreliable = true
    }, function(number)
        return Guard.Number(number)
    end)
}
```

## Listening to events
You use a different function to register listeners, depending on if it's a Signal Shared Event or not, as well as whether you're on the server or the client.

### Client
```lua
-- Assuming the code snippet above is our events file
local Events = require(Path.To.Events)

-- Shared Event
Events.PayloadEvent:SetClientListener(function(number)
    print("Client Received!", number)
end)

-- Shared Signal Event
--  You can have as many listeners as you want
Events.PayloadSignalEvent:OnClient(function(number)
    print("Callback 1", number)
end)
Events.PayloadSignalEvent:OnClient(function(number)
    print("Callback 2", number)
end)
```

### Server
```lua
-- Assuming the code snippet above is our events file
local Events = require(Path.To.Events)

-- Shared Event
Events.PayloadEvent:SetServerListener(function(Player, number)
    print("Server received from", Player, number)
end)

-- Shared Signal Event
--  You can have as many listeners as you want
Events.PayloadSignalEvent:OnServer(function(Player, number)
    print("Callback 1 from", Player, number)
end)
Events.PayloadSignalEvent:OnServer(function(Player, number)
    print("Callback 2 from", Player, number)
end)
```

## Firing Events
Like regular Events, Shared Events offer a lot of different firing functions.

These are identical for both types of Shared Event.

### FireServer <Badge type="warning" text="Client"></Badge>
This method fires the event to the server. Errors if called from the server.
```lua
MyEvent:FireServer("Hello, World!")
```

### FireClient <Badge type="tip" text="Server"></Badge>
This method fires the event to a specific client. Errors if called from the client.
```lua
MyEvent:FireClient(player, "Hello, World!")
```

### FireAllClients <Badge type="tip" text="Server"></Badge>
This method fires the event to all players. Errors if called from the client.
```lua
MyEvent:FireAllClients("Hello, World!")
```

### FireAllClientsExcept <Badge type="tip" text="Server"></Badge>
This method fires the event to every player except one. Errors if called from the client.
```lua
MyEvent:FireAllClientsExcept(player, "Hello, World!")
```

### FireClients <Badge type="tip" text="Server"></Badge>
This method fires the event to every player in the list. Errors if called from the client.
```lua
MyServer:FireClients({ player }, "Hello, World!")
```

### FireFilteredClients <Badge type="tip" text="Server"></Badge>
This method fires the event to every player that passes the filter. Errors if called from the client.
```lua
MyServer:FireFilteredClients(function(player)
	return player.Name == "Player1"
end, "Hello, World!")
```