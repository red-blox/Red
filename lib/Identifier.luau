local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Future = require(script.Parent.Parent.Future)

local Remote = ReplicatedStorage:WaitForChild("RedEvent")
local Identifier = {}

local NextShared = 0
local NextUnique = 0

local function UInt(Integer: number)
	return string.pack(`I{math.ceil(math.log(Integer + 1, 2) / 8)}`, Integer)
end

function Identifier.Shared(Name: string)
	return Future.new(function(Name: string)
		if RunService:IsServer() then
			if Remote:GetAttribute(Name) then
				return Remote:GetAttribute(Name)
			else
				NextShared += 1
				local Id = UInt(NextShared)

				Remote:SetAttribute(Name, Id)

				return Id
			end
		else
			while not Remote:GetAttribute(Name) do
				Remote.AttributeChanged:Wait()
			end

			return Remote:GetAttribute(Name)
		end
	end, Name)
end

function Identifier.Exists(Name: string)
	return RunService:IsServer() and Remote:GetAttribute(Name) ~= nil
end

function Identifier.Unique()
	NextUnique += 1

	if NextUnique == 0xFFFF then
		NextUnique = 0
	end

	return UInt(NextUnique)
end

return Identifier
