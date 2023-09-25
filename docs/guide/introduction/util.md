# Redblox Util

Red makes use of several small utility modules. Developers can find these, alongside many others, in [Redblox Util](https://util.redblox.dev/). 
Some of the more popular Utils are highlighted here.

A full list of available Utils and additional installation instructions can be found [here](https://util.redblox.dev/installing.html).

### [🔮 Future](https://util.redblox.dev/future.html)
A lightweight class to represent asynchronous functions.

In addition to its simplistic API, Future offers significant performance improvements and full intellisense with Luau.
Developers are encouraged to use Futures over Promises for these reasons.
```toml
Future = "red-blox/future@^1.0.0"
```

### [🛡️ Guard](https://util.redblox.dev/guard.html)
A runtime type checker with support for Luau types. Guard provides a convenient way of evaluating event types, so it is used in all Red examples.
```toml
Guard = "red-blox/guard@^1.0.0"
```

### [📡 Signal](https://util.redblox.dev/signal.html)
An implementation of the signal pattern, used for custom events, that does not utilize connection objects.
```toml
Signal = "red-blox/signal@^2.0.0"
```
