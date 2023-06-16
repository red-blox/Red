declare namespace Identifier {
	/**
	 * Transforms an unsigned integer into an identifier.
	 *
	 * Takes an unsigned integer (positive integer) & transforms it into a string identifier. Given the same number this will always return the same string. This remains true on both the client and the server.
	 * ```ts
	 * const IdOne: string = Red.Identifier.UInt(1);
	 * const IdTwo: string = Red.Identifier.UInt(1);
	 * 
	 * print(IdOne === IdTwo); // true
	 * 
	 * const IdThree: string = Red.Identifier.UInt(3);
	 * 
	 * print(IdOne === IdThree); // false
	 * @param Integer
	 */
	function UInt(Integer: number): string;

	/**
	 * Transforms a signed integer into an identifier.
	 *
	 * Takes a signed integer (positive or negative integer) & transforms it into a string identifier. Given the same number this will always return the same string. This remains true on both the client and the server.
	 * ```ts
	 * const IdOne: string = Red.Identifier.UInt(-1);
	 * const IdTwo: string = Red.Identifier.UInt(-1);
	 * 
	 * print(IdOne === IdTwo); // true
	 * 
	 * const IdThree: string = Red.Identifier.UInt(-2);
	 * 
	 * print(IdOne === IdThree); // false
	 * ```
	 * @param Integer
	 */
	function SInt(Integer: number): string;

	/**
	 * Transforms an enum into an identifier enum.
	 * 
	 * Takes an enum with any values and replaces the values with identifiers. Given the same indexes this will always return the same identifiers. This remains true on both the client and the server.
	 * ```ts
	 * const Enum = Red.Identifier.Enum({
	 *     One = true,
	 *     Two = true,
	 *     Four = true,
	 *     Five = true,
	 * });
	 * 
	 * print(Enum.One === Enum.One); // true
	 * print(Enum.Three === Enum.Four); // false
	 * @warning Do not store values returned by this function, adding new values will change the identifiers. ⚠️
	 * @param Map
	 */
	function Enum<T>(Map: T & { [key: string]: unknown }): T;
}

export default Identifier;
