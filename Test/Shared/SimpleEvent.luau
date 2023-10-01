local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Red = require(ReplicatedStorage.Packages.Red)
local Guard = require(ReplicatedStorage.Packages.Guard)

return Red.Event("SimpleEvent", function(Value)
	return Guard.Number(Value)
end)
