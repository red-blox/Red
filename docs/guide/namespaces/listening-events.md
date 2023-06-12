# Listening to Events

In the previous section, you learned what namespaces and events are, and how to create namespaces. In this section you'll learn how to listen to events and how to return data from an event.

## Listening to Signal-Like Events

As a refresher, signal-like events are events that are fired and listened to. They do not return values back to the caller. You can listen to these by using the `On` method.

::: code-group

```lua [Server]
local Net = Red.Server("NamespaceName")

Net:On("EventName", function(Player, ...)
	print(...)
end)
```

```lua [Client]
local Net = Red.Client("NamespaceName")

Net:On("EventName", function(...)
	print(...)
end)
```

The only difference between the server and client is that the server receives a [`Player`](https://create.roblox.com/docs/reference/engine/classes/Player) object as the first argument to the callback. This is typed so you shouldn't have too much trouble remembering this.

::: warning
An event can only have a single listener. Multiple calls to `On` will overwrite the listener, not add more.
:::

## Listening to Function-Like Events

Function-like events are events that are called, and the listener returns values back to the caller. They are also listened to by using the `On` method. The difference in what makes a function-like event is how it's called (Covered [here](./sending-invoking-events)).

::: code-group

```lua [Server]
local Net = Red.Server("NamespaceName")

Net:On("EventName", function(Player, ...)
	return ...
end)
```

:::

The server cannot invoke the client's function-like events, so there is no client-side example. If the server listener errors, the error will propagate to the caller, and reject the promise returned from the call.