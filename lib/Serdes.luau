export type Serdes<I, O> = {
	Ser: (I) -> O,
	Des: (O) -> I,
}

local Any: Serdes<any, any> = {
	Ser = function(Value: any): any
		return Value
	end,

	Des = function(Value: any): any
		return Value
	end,
}

local Integer: Serdes<number, string> = {
	Ser = function(Integer: number): string
		return string.pack(
			`i{if Integer == 0 then 1 else math.ceil((math.log(math.abs(Integer) + 1, 2) + 1) / 8)}`,
			Integer
		)
	end,

	Des = function(String: string): number
		return string.unpack(`i{if #String == 0 then 1 else #String}`, String)
	end,
}

local Number: Serdes<number, string | number> = {
	Ser = function(Number: number): string | number
		local String = tostring(Number)

		if #String < 7 then
			return String
		else
			return Number
		end
	end,

	Des = function(Value: string | number): number
		if type(Value) == "string" then
			return tonumber(Value) :: number
		else
			return Value
		end
	end,
}

local function List<I, O>(Serdes: Serdes<I, O>): Serdes<{ I }, { O }>
	return {
		Ser = function(List: { I }): { O }
			local Result = {}

			for Index, Value in List do
				Result[Index] = Serdes.Ser(Value)
			end

			return Result
		end,

		Des = function(List: { O }): { I }
			local Result = {}

			for Index, Value in List do
				Result[Index] = Serdes.Des(Value)
			end

			return Result
		end,
	}
end

local function Interface(Interface: { [string]: Serdes<any, any> }): Serdes<{ [string]: any }, { any }>
	local FieldList = {}

	for FieldName in Interface do
		table.insert(FieldList, FieldName)
	end

	table.sort(FieldList)

	return {
		Ser = function(Interface: { [string]: any }): { any }
			local Result = {}

			for i, FieldName in FieldList do
				Result[i] = Interface[FieldName]
			end

			return Result
		end,

		Des = function(List: { any }): { [string]: any }
			local Result = {}

			for i, FieldName in FieldList do
				Result[FieldName] = List[i]
			end

			return Result
		end,
	}
end

local function Ser<I, O>(Serdes: Serdes<I, O>)
	return Serdes.Ser
end

local function Des<I, O>(Serdes: Serdes<I, O>)
	return Serdes.Des
end

return {
	Any = Any,
	Integer = Integer,
	Number = Number,
	List = List,
	Interface = Interface,
	Ser = Ser,
	Des = Des,
}
