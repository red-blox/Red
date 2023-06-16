/**
 * The type that all Serdes functions work with.
 */
export type Serdes<I, O> = {
	Ser(Value: I): O;
	Des(Value: O): I;
};

declare namespace SerdesModule {
	/**
	 * A serdes type that doesn't modify data.
	 * ```
	 * Serdes<any, any>
	 * ```
	 * This is intended for use within other structures.
	 */
	const Any: Serdes<unknown, unknown>;

	/**
	 * A serdes type that reduces the size of integers by transforming them into strings.
	 * ```
	 * Serdes<number, string>
	 * ```
	 * This reduces the integers into their smallest possible size.
	 */
	const Integer: Serdes<number, string>;
	
	/**
	 * A serdes type that reduces the size of numbers by transforming them into strings.
	 * ```
	 * Serdes<number, number | string>
	 * ```
	 * This reduces numbers (including floats and integers) into their smallest possible size.
	 */
	const Number: Serdes<number, string | number>;

	/**
	 * Creates a serdes type that runs the given serdes type over each item in a list.
	 * ```ts
	 * const List = Red.Serdes.List(Red.Serdes.Integer);
	 * 
	 * const Serialized = List.Ser([ 1, 2, 3 ]);
	 * const Deserialized = List.Des(Serialized);
	 * ```
	 * @param Serdes
	 */
	function List<I, O>(Serdes: Serdes<I, O>): Serdes<I[], O[]>;

	/**
	 * Creates a serdes type that runs the given serdes type over each item in an interface.
	 * To be accurate, this function must be passed the same field names.
	 * ```ts
	 * const Interface = Red.Serdes.Interface({
	 *     FieldA: 1,
	 * 	   FieldB: 2,
	 * });
	 * 
	 * const Deserialized = Interface.Des(Serialized);
	 * ```
	 * @param Interface
	 */
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	function Interface<T extends { [key: string]: Serdes<unknown, unknown> }>(Interface: T): Serdes<T, LuaTuple<any>>;

	/**
	 * Returns the serialize function of a serdes type.
	 * @param Serdes
	 */
	function Ser<I, O>(Serdes: Serdes<I, O>): (Value: I) => O;

	/**
	 * Returns the deserialize function of a serdes type.
	 * @param Serdes
	 */
	function Des<I, O>(Serdes: Serdes<I, O>): (Value: O) => I;
}

export default SerdesModule;
