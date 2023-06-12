local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Promise = require(script.Parent.Parent.Promise)

local Identifier = require(script.Parent.Identifier)

local Remote = ReplicatedStorage:WaitForChild("RedEvent")
local Event = {}

local NextShared = 0
local NextUnique = 0

function Event.Shared(Name: string)
	if RunService:IsServer() then
		if Remote:GetAttribute(Name) then
			return Promise.Resolve(Remote:GetAttribute(Name))
		else
			local Id = Identifier.UInt(NextShared)
			NextShared += 1

			Remote:SetAttribute(Name, Id)

			return Promise.Resolve(Id)
		end
	else
		if Remote:GetAttribute(Name) then
			return Promise.Resolve(Remote:GetAttribute(Name))
		else
			return Promise.new(function(Resolve)
				Remote:GetAttributeChangedSignal(Name):Once(function()
					Resolve(Remote:GetAttribute(Name))
				end)
			end)
		end
	end
end

function Event.Unique()
	NextUnique += 1

	if NextUnique == 0xFFFF then
		NextUnique = 0
	end

	return Identifier.UInt(NextUnique)
end

return Event
