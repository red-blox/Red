/* eslint-disable roblox-ts/no-private-identifier */
import Serdes from "./Serdes";
import Identifier from "./Identifier";
import { promise } from "@redblox/promise";

declare class Server {
	public Name: string;
	public FolderInstance?: Folder;

	/**
	 * Fires an event to a single player with included data.
	 * ```ts
	 * Net.Fire(Player, "EventName", "Hello, World!", 1, 2, 3);
	 * ```
	 * @warning This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded. ⚠️
	 * @param Player
	 * @param EventName
	 * @param Args
	 */
	public Fire(Player: Player, EventName: string, ...Args: unknown[]): void;

	/**
	 * Fires an event to all players with included data.
	 * ```ts
	 * Net.FireAll("EventName", "Hello, World!", 1, 2, 3);
	 * ```
	 * @warning This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded. ⚠️
	 * @param EventName
	 * @param Args
	 */
	public FireAll(EventName: string, ...Args: unknown[]): void;

	/**
	 * Fires an event to all players except one with included data.
	 * ```ts
	 * Net.FireAllExcept(Player, "EventName", "Hello, World!", 1, 2, 3);
	 * ```
	 * @warning This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded. ⚠️
	 * @param Except Player to exclude
	 * @param EventName
	 * @param Args
	 */
	public FireAllExcept(Except: Player, EventName: string, ...Args: unknown[]): void;

	/**
	 * Fires an event to a list of players with included data.
	 * ```ts
	 * Net.FireList([PlayerOne, PlayerTwo], "EventName", "Hello, World!", 1, 2, 3);
	 * ```
	 * @warning This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded. ⚠️
	 * @param PlayerList List of players to fire to
	 * @param EventName
	 * @param Args
	 */
	public FireList(PlayerList: Player[], EventName: string, ...Args: unknown[]): void;

	/**
	 * Fires an event to all players with included data, but only if the filter function returns true.
	 * ```ts
	 * Net.FireWithFilter((Player: Player) => Player.Team?.Name === "Red", "EventName", "Hello, World!", 1, 2, 3);
	 * ```
	 * @warning This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded. ⚠️
	 * @param Filter
	 * @param EventName
	 * @param Args
	 */
	// eslint-disable-next-line prettier/prettier
	public FireWithFilter(
		Filter: (Player: Player) => boolean,
		EventName: string,
		...Args: unknown[]
	): void;

	/**
	 * Retrieves a shared namespace folder.
	 * 
	 * The returned Folder is shared between the server and client. It can be used to store shared data - for example, save data!
	 * ```ts
	 * const Folder: Folder = Net.Folder();
	 *
	 * // Using attributes is generally considered a good idea
	 * Folder.SetAttribute("Hello", "World!");
	 *
	 * // Attribute names are expensive, though! Consider using Identifiers for them
	 * Folder.SetAttribute(Red.Identifier.UInt(1), "World!");
	 * ```
	 *
	 * Specifying the optional `Player` argument creates a Folder shared with **only** the passed player. It can be used to store private shared data - for example, the player's role.
	 * ```ts
	 * const Folder: Folder = Net.Folder(Player);
	 * 
	 * // Still a folder instance, just replicates to a specific player
	 * Folder.SetAttribute(Red.Identifier.UInt(1), "Sherif");
	 * ```
	 * @param Player?
	 */
	public Folder(Player?: Player): Folder;
	// eslint-disable-next-line prettier/prettier

	/**
	 * Sets the listener for an event.
	 *
	 * Each event can only have one callback. An attempt to register a second callback will overwrite the first. The passed function will also be used for function-like events. If the client requests a call, any returned values from the callback will be sent back to the client.
	 * ```ts
	 * Net.On("EventName", (Player: Player, ...Args: unknown[]) => {
	 *     print(`EventName fired by ${Player.Name} with arguments ${...Args}`);
	 * });
	 * @param EventName
	 * @param Callback
	 */
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

	/**
	 * Fires an event to the server with included data.
	 * ```ts
	 * Net.Fire("EventName", "Hello, World!", 1, 2, 3);
	 * @warning This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded. ⚠️
	 * @param EventName
	 * @param Args
	 */
	public Fire<E>(EventName: string, ...Args: unknown[]): promise<void, E>;

	/**
	 * Calls a function-like event on the server.
	 * ```ts
	 * const Response = Net.Call("EventName", "Hello, World!", 1, 2, 3).Await();
	 * ```
	 * @warning This method has the same data limits as RemoteEvents. Any data that cannot be serialzed will arrive malformed on the client. Any data after the first nil will be discarded. ⚠️
	 * @param EventName
	 * @param Args
	 */
	public Call<V, E>(EventName: string, ...Args: unknown[]): promise<V, E>;

	/**
	 * Listens for an event from the server.
	 * 
	 * Each event can only have one callback. An attempt to register a second callback will overwrite the first.
	 * ```ts
	 * Net.On("EventName", (...Args: unknown[]) => {
	 *     print(...Args);
	 * });
	 * @param EventName
	 * @param Callback
	 */
	public On<V, E>(EventName: string, Callback: (...Args: unknown[]) => void): promise<V, E>;

	/**
	 * Retrieves a shared namespace folder.
	 * 
	 * The returned folder is shared between the server and all clients. It can be used to store shared data.
	 * It's read only for the client, as it cannot replicate writes to the server.
	 * ```ts
	 * const Folder: Folder = Net.Folder();
	 * 
	 * // Using attributes is generally considered a good idea
	 * Folder.GetAttribute("Hello");
	 * 
	 * // Attribute names are expensive! Consider using Identifiers for them
	 * Folder.GetAttribute(Red.Identifier.UInt(1));
	 * ```
	 * @warning This method will yield until the folder is created by the server. ⚠️
	 */
	public Folder(): Folder;

	/**
	 * Retrieves a local namespace folder.
	 * 
	 * The returned folder is shared **only** between the server and the local client.
	 * It's secure and cannot be read by other clients.
	 * 
	 * ```ts
	 * const Folder: Folder = Net.LocalFolder();
	 * 
	 * // Using attributes is generally considered a good idea
	 * Folder.GetAttribute("Hello");
	 * 
	 * // Attribute names are expensive! Consider using Identifiers for them
	 * Folder.GetAttribute(Red.Identifier.UInt(1));
	 */
	public LocalFolder(): Folder;
}

/**
 * Retrieves a Server Namespace object for the given name.
 * If the namespace doesn't already exist, it will be created.
 * ```ts
 * const Net = Red.Server("Namespace");
 * ```
 * @server
 * @param Name Name of the namespace
 */
declare function Server(Name: string): Server;

/**
 * Retrieves a Client Namespace object for the given name.
 * If the namespace doesn't already exist, it will be created.
 * ```ts
 * const Net = Red.Client("Namespace");
 * ```
 * @client
 * @param Name Name of the namespace
 */
declare function Client(Name: string): Client;

export { Serdes, Identifier, Server, Client };
