# Serdes

Serdes is a system that allows you to serialize and deserialize data. It can be used to reduce the amount of data sent over the network. Serdes should be used for dynamic data, for static data refer to [Identifiers](./identifiers).

## The Serdes Type

```lua
type Serdes<I, O> = {
	Ser: (I) -> O,
	Des: (O) -> I,
}
```

This type is the core of Serdes. Every serdes function will return this, enabling you to combine them together and even make your own.

## Primitives

### Any

Any is the most basic serdes function, it simply returns the value given to it. It's designed for use inside other structures.

```lua
Red.Serdes.Any.Ser(1) -- 1
Red.Serdes.Any.Des(1) -- 1

Red.Serdes.Any.Ser("Hello") -- "Hello"
Red.Serdes.Any.Des("Hello") -- "Hello"

Red.Serdes.Any.Ser({1, 2, 3}) -- {1, 2, 3}
Red.Serdes.Any.Des({1, 2, 3}) -- {1, 2, 3}
```

### Integer

The integer serdes type takes an integer and packs it into a string (in the same way `Identifier.SInt` does).

```lua
local Packed = Red.Serdes.Integer.Ser(1)
Red.Serdes.Integer.Des(Packed) -- 1
```

### Number

The number serdes type takes a number and packs it into a string if size can be gained, otherwise it will leave it in it's number state.

```lua
local Packed = Red.Serdes.Number.Ser(1.5)

Red.Serdes.Number.Des(Packed) -- 1.5
```

## Structures

### List

The list type takes a list of a type.

```lua
local List = Red.Serdes.List(Red.Serdes.Integer)

local Packed = List.Ser({1, 2, 3})
List.Des(Packed) -- {1, 2, 3}
```

### Interface

The interface type takes a table of types and returns a table of the same types.

```lua
local Interface = Red.Serdes.Interface({
	A = Red.Serdes.Integer,
	B = Red.Serdes.Integer,
})

local Packed = Interface.Ser({A = 1, B = 2})
Interface.Des(Packed) -- {A = 1, B = 2}
```
