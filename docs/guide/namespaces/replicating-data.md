# Replicating Data

Replicating data to players is an essential part of any game, from player stats to inventory to game state. Red provides multiple ways to replicate data, each tailored for different cases.

## Global Replication

Each namespace has a folder that replicates any descendants to all players. This folder can be accessed by calling `Net:Folder()` on any namespace.

```lua
local Net = Red.Server("NamespaceName")

Net:Folder() -- Replicates to all players
```

You can retrieve the folder on the client by calling `Net:Folder()`.

```lua
local Net = Red.Client("NamespaceName")

Net:Folder() -- Replicates to all players
```

::: warning
This folder isn't created until the first call to `Net:Folder()` on the server. As such, any client calls to this will yield until the first server call.
:::

Attributes can be very useful in combination with this. For example, you could use a `CurrentMap` attribute on a round based game share the current map with all players.

```lua
local Net = Red.Server("NamespaceName")

Net:Folder():SetAttribute("CurrentMap", "Map1")
```

::: tip
Storing the folder in a variable is against Red conventions. Instead, you should use the `Net:Folder()` method to get the folder each time you need it.
:::

Global replication is nice, but sometimes you want to replicate only to a single player. This brings us to the next section.

## Single Player Replication

Just as each namespace has a global replication folder, each player has a folder that replicates to that player, and only that player. This folder can be accessed by calling `Net:Folder(Player)` on any namespace.

```lua
local Net = Red.Server("NamespaceName")

Net:Folder(Player) -- Replicates to the player
```

You can retrieve the folder on the client by calling `Net:LocalFolder()`.

```lua
local Net = Red.Client("NamespaceName")

Net:LocalFolder() -- Replicates to the local player
```

::: warning
This folder isn't created until the first call to `Net:Folder(Player)` on the server. As such, any client calls to this will yield until the first server call.
:::

This folder is secure, the contents of this folder are only replicated to that player. This means that you can store sensitive data, or data that other players just don't need to know. For example, let's create an attribute that will tell the player what their role is in a game.

```lua
local Net = Red.Server("NamespaceName")

if IsMurderer(Player) then
	Net:Folder(Player):SetAttribute("Role", "Murderer")
elseif IsInnocent(Player) then
	Net:Folder(Player):SetAttribute("Role", "Innocent")
else
	Net:Folder(Player):SetAttribute("Role", "None")
end
```

## Event Replication

Roblox replication through instances is slow when it is needed in mass amounts, or when the data updates frequently. As an alternative, you can simply send your data through events, there is a method to this though. Red batches events for you, don't batch your data into one call to Red.

As an example, let's create a function that will replicate enemy positions to every player.

```lua
local Net = Red.Server("NamespaceName")

local function SendEnemies()
	for _, Enemy in EnemyList do
		Net:FireAll("EnemyPosition", Enemy.Id, Enemy.Position)
	end
end
```

Red has no interface for replicating data through events, you'll need to manage this yourself. This gives you the opportunity to optimize your own data to achieve maximum efficiency.

## What Should I Use?

Each option has it's pros and cons. If your data changes quickly (every frame or so), or you need to replicate huge amounts of data, use events. If your data changes slowly then using instance replication is good.