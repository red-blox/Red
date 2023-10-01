local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Red = require(ReplicatedStorage.Packages.Red)

return Red.Event("EmptyEvent", function()
	return
end)
