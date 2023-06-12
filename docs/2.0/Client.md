# Client

A Client Namespace object. All networking on the client is done through this object.

## Fire

Fires an event to the server with included data.

```lua
(
	self: Client,
	EventName: string,
	...: any
) -> Promise
```

::: warning
This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the server. Any data after the first nil will be discarded.
:::

```lua
Net:Fire("EventName", "Hello World", 1, 2, 3)
```

## Call

Calls a function-like event on the server.

```lua
(
	self: Client,
	EventName: string,
	...: any
) -> Promise<...any>
```

::: warning
This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the server. Any data after the first nil will be discarded.
:::

```lua
local Response = Net:Call("EventName", "Hello World", 1, 2, 3):Await()
```

## On

Listens for an event from the server.

```lua
(
	self: Client,
	EventName: string,
	Callback: (...any) -> ()
) -> ()
```

Each event can only have one callback. An attempt to register a second callback will overwrite the first.

```lua
Net:On("EventName", function(...)
	print(...)
end)
```

## Folder

Retrieves a shared namespace folder.

```lua
(
	self: Client,
	FolderName: string
) -> Folder
```

This method returns a Folder that is shared between the server and client. This folder can be used to store data that is shared between the two. The client can only read from the folder, as the client cannot replicate writes to the server.

```lua
local Folder = Net:Folder()

-- Using attributes is generally considered a good idea
Folder:GetAttribute("Hello")

-- Attribute names are expensive, consider using Identifiers for them
Folder:GetAttribute(Red.Identifier.UInt(1))
```

::: warning
This method will yield until the folder is created by the server.
:::

## LocalFolder

Retrieves a local namespace folder.

```lua
(
	self: Client,
	FolderName: string
) -> Folder
```

This method returns a Folder that is shared between only the server and the local client. This folder is secure and cannot be read by other clients.

```lua
local Folder = Net:LocalFolder()

-- Using attributes is generally considered a good idea
Folder:GetAttribute("Hello")

-- Attribute names are expensive, consider using Identifiers for them
Folder:GetAttribute(Red.Identifier.UInt(1))
```

::: warning
This method will yield until the folder is created by the server.
:::
