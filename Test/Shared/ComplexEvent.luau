local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Red = require(ReplicatedStorage.Packages.Red)
local Guard = require(ReplicatedStorage.Packages.Guard)

local ValueCheck =
	Guard.Optional(Guard.Map(Guard.String, Guard.List(Guard.Or(Guard.Literal("String Literal"), Guard.Number))))

return Red.Event("ComplexEvent", function(Value1, Value2, Value3)
	return ValueCheck(Value1), Guard.String(Value2), Guard.Number(Value3)
end)
