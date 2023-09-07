# FAQ

## How can I contribute to or support Red?

Red is open to contributions - please open an issue or comment before beginning work on a feature or bugfix so that work isn't duplicated and so that we can discuss the implementation.

If you'd like to support me and my development of Red, you can [buy me a coffee](https://www.buymeacoffee.com/jack.ink).

## Reliability and Ordering?

Events in Red are built on top of RemoteEvents, and as such are fully reliable.

However, events are not fully ordered.

- If you fire two different events in the same frame, they are unordered.
- If you fire the same event twice in the same frame, they are ordered.
- If you fire any events in different frames, they are ordered.

## Ratelimiting?

Red has no built-in networking, however there is a [ratelimiting utility](https://util.redblox.dev/ratelimit) available.

```lua
local Ratelimit = require(Path.To.Ratelimit)
local MyEvent = require(Path.To.MyEvent)

local MyEventRatelimit = Ratelimit(10, 1)
MyEvent:On(function(Player)
	if MyEventRatelimit(Player) then
		print("Fired!")
	else
		print("Ratelimited!")
	end
end)
```
