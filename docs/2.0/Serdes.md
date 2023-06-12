# Serdes

This interface allows developers to reduce the amount of data used by dynamic data.

## Serdes Type

The type that all serdes functions work with.

```lua
type Serdes<I, O> = {
	Ser: (I) -> O,
	Des: (O) -> I,
}
```

## Any

A serdes type that doesn't modify data.

```lua
Serdes<any, any>
```

This is intended for use within other structures.

## Integer

A serdes type that reduces the size of integers by transforming them into strings.

```lua
Serdes<number, string>
```

This reduces integers into their smallest possible size.

## Number

A serdes type that reduces the size of numbers by transforming them into strings.

```lua
Serdes<number, number | string>
```

This reduces numbers (including floats and integers) into their smallest possible size.

## List

Creates a serdes type that runs the given serdes type over each item in a list.

```lua
<I, O>(
	Serdes: Serdes<I, O>
) -> Serdes<{ I }, { O }>
```

```lua
local List = Red.Serdes.List(Red.Serdes.Integer)

local Serialized = List.Ser({ 1, 2, 3 })
local Deserialized = List.Des(Serialized)
```

## Interface

Creates a serdes type that runs the given serdes type for each item in a interface.

```lua
(
	Interface: { [string]: Serdes<any, any> }
) -> Serdes{ [string]: any }, { any }>
```

To be accurate this function must be passed the same field names.

```lua
local Interface = Red.Serdes.Interface({
	FieldA = Red.Serdes.Integer,
	FieldB = Red.Serdes.Integer,
})

local Serialized = Interface.Ser({
	FieldA = 1,
	FieldB = 2,
})

local Deserialized = Interface.Des(Serialized)
```

## Ser

Returns the serialized function of a serdes type.

```lua
<I, O>(
	Serdes: Serdes<I, O>
) -> (I) -> O
```

## Des

Returns the deserialized function of a serdes type.

```lua
<I, O>(
	Serdes: Serdes<I, O>
) -> (O) -> I
```
