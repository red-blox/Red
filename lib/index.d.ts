/* eslint-disable roblox-ts/no-private-identifier */
import Serdes from "./Serdes";
import Identifier from "./Identifier";
import promise from "shared/_Index/red-blox_promise@1.0.0/promise/Promise";

declare class Server {
	public Name: string;
	public FolderInstance?: Folder;

	public Fire(Player: Player, EventName: string, ...Args: unknown[]): void;
	public FireAll(EventName: string, ...Args: unknown[]): void;
	public FireAllExcept(Except: Player, EventName: string, ...Args: unknown[]): void;
	public FireList(PlayerList: Player[], EventName: string, ...Args: unknown[]): void;
	// eslint-disable-next-line prettier/prettier
	public FireWithFilter(
		Filter: (Player: Player) => boolean,
		EventName: string,
		...Args: unknown[]
	): void;
	public Folder(Player?: Player): Folder;
	// eslint-disable-next-line prettier/prettier
	public On(
		EventName: string,
		Callback: (Player: Player, ...Args: unknown[]) => void,
	): unknown[];
}

declare class Client {
	public Name: string;
	public FolderInstance?: Folder;
	public LocalFolderInstance?: Folder;

	public constructor(Name: string);

	public Fire<E>(EventName: string, ...Args: unknown[]): promise<void, E>;
	public Call<V, E>(EventName: string, ...Args: unknown[]): promise<V, E>;
	public On<V, E>(EventName: string, Callback: (...Args: unknown[]) => void): promise<V, E>;
	public Folder(): Folder;
	public LocalFolder(): Folder;
}

declare function Server(Name: string): Server;
declare function Client(Name: string): Client;

export { Serdes, Identifier, Server, Client };
