# Red

The root of the Red library.

## Event

Creates a new [event](./Event/index) object.

```lua
<T...>(
	Name: string, -- The name of the event
	Validate: (...unknown) -> T..., -- Validates event payloads
) -> Event<T...>
```

This will create an event with the passed name.

::: danger
The name of the event must be unique, using the same name twice will result in an error.
:::

The validation function is used to validate the type of the payloads. The function has three rules:

1. The callback returns the arguments in the same order they were passed in.
2. The callback must error if the arguments are invalid.
3. The callback must narrow the types of the arguments.

```lua
return Red.Event("EventName", function(Number, String)
	return Guard.Number(Number), Guard.String(String)
end)
```

::: tip
It is recommended to use [Guard](https://util.redblox.dev/guard) to typecheck payloads as it also narrows types.
:::
