# Identifer

This interface allows you to create identifiers used to represent static data.

## Enum

Transforms an enum into an identifier enum.

```lua
<T>(
	Map: T & { [string]: any }
) -> T
```

This function takes an enum with any values and replaces the values with identifiers. Given the same names this will always return the same identifiers. This remains true over the client and server.

```lua
local Enum = Red.Identifier.Enum({
	One = true,
	Two = true,
	Three = true,
	Four = true,
})

print(Enum.One == Enum.One) -- true
print(Enum.Three == Enum.Four) -- false
```

::: warning
Do not store values returned by this function, adding new values will change the identifiers.
:::
