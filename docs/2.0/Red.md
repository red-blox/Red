# Red

The root of the Red library.

## Event

Creates a new [event](./Event/index) object.

```lua
<T...>(
	Name: string | { Name: string, Unreliable: boolean? }, -- Event config
	Validate: (...unknown) -> T..., -- Validates event payloads
) -> Event<T...>
```

This will create an event with the passed config.

If you pass a string, it will be used as the event name and the event will be reliable. If you pass a table you have the option to make the event unreliable.

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

## Function

Creates a new [function](./Function) object.

```lua
<A..., R...>(
	Name: string, -- The name of the function
	ValidateArg: (...unknown) -> A..., -- Validates function arguments
	ValidateRet: (...unknown) -> R..., -- Validates function returns
) -> Function<A..., R...>
```

This will create a function with the passed name.

::: danger
The name of the function must be unique, using the same name twice will result in an error.
:::

The validation functions are used to validate the type of the arguments and returns. The functions have the same three rules as event validation functions:

1. The callback returns the arguments in the same order they were passed in.
2. The callback must error if the arguments are invalid.
3. The callback must narrow the types of the arguments.

```lua
return Red.Function("FunctionName", function(Number, String)
	return Guard.Number(Number), Guard.String(String)
end, function(Number, String)
	return Guard.Number(Number), Guard.String(String)
end)
```

::: tip
It is recommended to use [Guard](https://util.redblox.dev/guard) to typecheck as it also narrows types.
:::

## SharedEvent
Creates a new [SharedEvent](./SharedEvent) object.
```lua
<T...>(
	Name: string | { Name: string, Unreliable: boolean? }, -- Event config
	Validate: (...unknown) -> T... -- Validates event payloads
) -> SharedCallEvent<T...>
```
This will create a SharedEvent with the passed config.

If you pass a string, it will be used as the event name and the event will be reliable. If you pass a table you have the option to make the event unreliable.

::: danger
The name of the event must be unique, using the same name twice will result in an error.
:::

The validation function is used to validate the type of the payloads. The function has three rules:

1. The callback returns the arguments in the same order they were passed in.
2. The callback must error if the arguments are invalid.
3. The callback must narrow the types of the arguments.

```lua
return Red.SharedEvent("EventName", function(Number, String)
	return Guard.Number(Number), Guard.String(String)
end)
```
::: tip
It is recommended to use [Guard](https://util.redblox.dev/guard) to typecheck as it also narrows types.
:::

## SharedSignalEvent
Creates a new [SharedSignalEvent](./SharedSignalEvent) object.
```lua
<T...>(
	Name: string | { Name: string, Unreliable: boolean? }, -- Event config
	Validate: (...unknown) -> T... -- Validates event payloads
) -> SharedSignalEvent<T...>
```
This will create a SharedSignalEvent with the passed config.

If you pass a string, it will be used as the event name and the event will be reliable. If you pass a table you have the option to make the event unreliable.

::: danger
The name of the event must be unique, using the same name twice will result in an error.
:::

The validation function is used to validate the type of the payloads. The function has three rules:

1. The callback returns the arguments in the same order they were passed in.
2. The callback must error if the arguments are invalid.
3. The callback must narrow the types of the arguments.

```lua
return Red.SharedSignalEvent("EventName", function(Number, String)
	return Guard.Number(Number), Guard.String(String)
end)
```
::: tip
It is recommended to use [Guard](https://util.redblox.dev/guard) to typecheck as it also narrows types.
:::