export type Serdes<I, O> = {
	Ser(Value: I): O;
	Des(Value: O): I;
};

declare namespace SerdesModule {
	const Any: Serdes<unknown, unknown>;
	const Integer: Serdes<number, string>;
	const Number: Serdes<number, string | number>;

	function List<I, O>(Serdes: Serdes<I, O>): Serdes<I[], O[]>;
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	function Interface<T extends { [key: string]: Serdes<unknown, unknown> }>(Interface: T): Serdes<T, LuaTuple<any>>;
	function Ser<I, O>(Serdes: Serdes<I, O>): (Value: I) => O;
	function Des<I, O>(Serdes: Serdes<I, O>): (Value: O) => I;
}

export default SerdesModule;
