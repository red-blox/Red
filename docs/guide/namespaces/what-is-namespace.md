# What is a Namespace?

In Red, networking is done with namespaces. A namespace could be seen as a folder which controls it's event children. To create a namespace, call the Server or Client function from Red. Namespace names must be the same on the server and client for them to communicate.

::: code-group
```lua [Server]
-- The typical variable name for a script's namespace is Net
local Net = Red.Server("NamespaceName")
```

```lua [Client]
-- The typical variable name for a script's namespace is Net
local Net = Red.Client("NamespaceName")
```
:::

::: warning
Calling `Server` on the client, or `Client` on the server will throw an error.
:::

It's important to know that namespaces are global. You can get a namespace multiple times, and it will return the same object. This enables you to use the same namespace from multiple scripts.

::: danger
Do not dynamically create namespaces. Namespace objects are never GC'd, dynamically creating namespaces is a **memory leak**.
:::

## Namespaces & Events

Events are not their own object, they can only be interacted with through namespaces. As an example, let's fire an event to the server from the client. You'll learn more about firing events in the [Sending and Invoking Events](./sending-invoking-events) section.

```lua
local Net = Red.Client("NamespaceName")

-- We first pass the event name, then the data to fire with
Net:Fire("EventName", "Hello, world!")
```

As you can see the only representation of the event is it's name. Events can be signal-like or function-like (or both, although this is a bad practice). Signal-like events are events that are fired and listened to, and function-like events are events that are invoked and return a value. You'll learn more about this in the following sections.

::: danger
Do not dynamically create events. Event names are never GC'd, dynamically creating events is a **memory leak**.
:::
