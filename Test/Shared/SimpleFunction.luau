local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Red = require(ReplicatedStorage.Packages.Red)
local Guard = require(ReplicatedStorage.Packages.Guard)

return Red.Function("SimpleFunction", function(Value)
	return Guard.Number(Value)
end, function(Value)
	return Guard.String(Value)
end)
