declare namespace Identifier {
	function UInt(Integer: number): string;
	function SInt(Integer: number): string;
	function Enum<T>(Map: T & { [key: string]: unknown }): T;
}

export = Identifier;
