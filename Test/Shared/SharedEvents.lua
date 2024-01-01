local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Guard = require(ReplicatedStorage.Packages.Guard)
local Red = require(ReplicatedStorage.Packages.Red)

local ValueCheck =
	Guard.Optional(Guard.Map(Guard.String, Guard.List(Guard.Or(Guard.Literal("String Literal"), Guard.Number))))

return {
	Empty = Red.SharedEvent("Empty", function() end),

	Ready = Red.SharedEvent("Ready", function() end),

	Simple = Red.SharedEvent("Simple", function(Number)
		return Guard.Number(Number)
	end),

	Signal = Red.SharedSignalEvent("Signal", function(Number)
		return Guard.Number(Number)
	end),

	Complex = Red.SharedEvent("Complex", function(Value1, Value2, Value3)
		return ValueCheck(Value1), Guard.String(Value2), Guard.Number(Value3)
	end),
}
