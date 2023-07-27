local function UInt(Integer: number)
	return string.pack(`I{if Integer == 0 then 1 else math.ceil(math.log(Integer + 1, 2) / 8)}`, Integer)
end

local function Enum<T>(Map: T & { [string]: any }): T
	local KeyList = {}

	for Key in Map :: { [string]: any } do
		table.insert(KeyList, Key)
	end

	table.sort(KeyList)

	for Index, Key in KeyList do
		(Map :: { [string]: any })[Key] = UInt(Index)
	end

	return Map
end

return {
	Enum = Enum,
}
