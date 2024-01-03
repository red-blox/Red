# Getting Started

Red is available for Rojo-based workflows and Studio workflows through wally.

## Rojo

1. Make sure you have [Rojo](https://rojo.space/) and [Wally](https://wally.run/) installed.
2. Add Red to your `wally.toml` file:

```toml
[dependencies]
Red = "red-blox/red@2.3.0"
```

3. Run `wally install` to install packages.

## Studio

1. Make sure you have the [Studio Wally](https://github.com/fewkz/studio-wally) plugin installed.
2. Add Red to your packages table:

```lua
return {
    studioWallyServer = "https://studio-wally.fewkz.com",
    packages = {
        Red = "red-blox/red@2.3.0"
    }
}
```

3. Install packages.
