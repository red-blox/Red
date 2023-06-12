# Sending and Invoking Events

You've now learned what namespaces and events are, how to create namespaces, and how to listen to events. In this section you'll learn how to send and invoke events.

## The Difference Between Signal-Like and Function-Like Events

As you might remember from the last section, the difference is not decided in how they are listened to, but instead in how they are called. 

Signal-like events are sent, and will not take back a return value. Function-like events are sent, and then wait for a returns to be sent back. A signal-like event could be called as a function, and function-like events can be called as signals. The only difference in behavior is how they are called, and the return value.

## Sending Signal-Like Events

Signal-like events are events that are fired and listened to. They do not return values back to the caller. You can send these by using the `Fire` method (or a variant on the server).

::: code-group

```lua [Server]
local Net = Red.Server("NamespaceName")

-- Fires a single player
Net:Fire(Player, "EventName", ...)

-- Fires all players
Net:FireAll("EventName", ...)

-- Fires all players except the specified player
Net:FireAllExcept(Player, "EventName", ...)

-- Fires a list of players
Net:FireList({ Player }, "EventName", ...)

-- Fires all players that match the filter
Net:FireWithFilter(function(Player)
	return Player.Name == "Uncontained0"
end, "EventName", true)
```

```lua [Client]
local Net = Red.Client("NamespaceName")

-- Fires the server
Net:Fire("EventName", ...)
```

:::

## Sending Function-Like Events

Function-like events are events that are called, and the listener returns values back to the caller. You can send these by using the `Call` method on the client. The server cannot call function-like events on the client.

::: code-group

```lua [Client]
local Net = Red.Client("NamespaceName")

-- Calls the server
Net:Call("EventName", 1, 2):Then(function(Result)
	print(Result)
end)
```

```lua [Server]
local Net = Red.Server("NamespaceName")

Net:On("EventName", function(Player, A, B)
	return A + B
end)
```

:::

As you can see, the `Call` method returns a promise. You can learn more about Red promises in the API Reference.