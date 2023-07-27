# Identifiers

An identifier is a short string that represents something else, and in Red's case, a number. Identifiers can be used to greatly decrease the amount of static data sent over the network and drastically increase performance.

## Static Data?

You read that correctly, identifiers are designed to be used for static data. Any dynamic data should be sent over the network as-is, or using [Serdes](./serdes).

## Enum Identifiers

Enum identifiers are a more complex identifier that allow you to create enums optimized for networking.

::: code-group
```lua [Server]
local Enum = Red.Identifier.Enum({
	Add = true,
	Sub = true,
})

Net:On("Event", function(Identifier, A, B)
	if Identifier == Enum.Add then
		return A + B
	elseif Identifier == Enum.Sub then
		return A - B
	end
end)
```

```lua [Client]
local Enum = Red.Identifier.Enum({
	Add = true,
	Sub = true,
})

Net:Call("Event", Enum.Add, 1, 2):Then(print) -- 3
Net:Call("Event", Enum.Sub, 1, 2):Then(print) -- -1
```
:::

::: tip
Why do you have to pass enums as a set? This is because of luau. To enable autocomplete for enums we currently have to pass them as a set.
:::

Every enum item must be the same on both the server and client. If you want to add an item to the enum, you must add it to both the server and client.
