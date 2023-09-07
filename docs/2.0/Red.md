# Red

The root of the Red library.

## Event

Creates a new [event](./Event) object.

```lua
<T...>(
	Validate: (...unknown) -> T..., -- Validates event payloads
	NameOverride: string?, -- Optional override for the name of the event
) -> Event<T...>
```

This will create an event with the same name as the script calling the function.

The validation function is used to validate the type of the payloads. The function has three rules:

1. The callback returns the arguments in the same order they were passed in.
2. The callback must error if the arguments are invalid.
3. The callback must narrow the types of the arguments.

```lua
return Red.Event(function(Number, String)
	return Guard.Number(Number), Guard.String(String)
end)
```

::: tip
It is recommended to use [Guard](https://util.redblox.dev/guard) to typecheck payloads as it also narrows types.
:::

If for whatever reason the name of the calling script cannot be used for the name of the event, you can pass in a string as the second argument to override the name.

```lua
return Red.Event(function(Number, String)
	return Guard.Number(Number), Guard.String(String)
end, "MyEvent")
```
