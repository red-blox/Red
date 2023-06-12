# Red

The root of the Red library.

## Server <Badge type="tip" text="Server Only" />

Retrieves a [Server Namespace](./Server) object for the given name.

```lua
(
	Name: string
) -> Server
```

This function gets a [Server Namesoace](./Server), creating one for the given name if one doesn't already exist.

::: code-group
```lua [Server]
local Net = Red.Server("NamespaceName")
```
:::

## Client <Badge type="tip" text="Client Only" />

Retrieves a [Client Namespace](./Client) object for the given name.

```lua
(
	Name: string
) -> Client
```

This function gets a [Client Namespace](./Client), creating one for the given name if one doesn't already exist.

::: code-group
```lua [Client]
local Net = Red.Client("NamespaceName")
```

## Identifier

A Reference to the [Identifier](./Identifier) interface.

## Serdes

A Reference to the [Serdes](./Serdes) interface.
