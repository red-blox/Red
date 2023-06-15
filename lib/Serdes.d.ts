export type Serdes<I, O> = {
	Ser(Value: I): O;
	Des(Value: O): I;
};

export namespace SerdesModule {
	const Any: Serdes<unknown, unknown>;
	const Integer: Serdes<number, string>;
	const Number: Serdes<number, string | number>;

	function List<I, O>(Serdes: Serdes<I, O>): Serdes<I[], O[]>;
	function Interface(Interface: {
		[key: string]: Serdes<unknown, unknown>;
	}): Serdes<{ [key: string]: unknown }, unknown[]>;
	function Ser<I, O>(Serdes: Serdes<I, O>): (Value: I) => O;
	function Des<I, O>(Serdes: Serdes<I, O>): (Value: O) => I;
}
