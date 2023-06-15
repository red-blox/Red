/* eslint-disable roblox-ts/no-private-identifier */
import { SerdesModule } from "./Serdes";
import * as IdentifierModule from "./Identifier";

export namespace Red {
	export import Serdes = SerdesModule;
	export import Identifier = IdentifierModule;

	export class Server {
		public Name: string;
		public FolderInstance?: Folder;

		public constructor(Name: string);

		public Fire(self: Server, Player: Player, EventName: string, ...Args: unknown[]): void;
		public FireAll(self: Server, EventName: string, ...Args: unknown[]): void;
		public FireAllExcept(self: Server, Except: Player, EventName: string, ...Args: unknown[]): void;
		public FireList(self: Server, PlayerList: Player[], EventName: string, ...Args: unknown[]): void;
		public FireWithFilter(
			self: Server,
			Filter: (Player: Player) => boolean,
			EventName: string,
			...Args: unknown[]
		): void;
		public Folder(self: Server, Player?: Player): Folder;
		public On(self: Server, EventName: string, Callback: (Player: Player, ...Args: unknown[]) => void): void;
	}

	export class Client {
		public Name: string;
		public FolderInstance?: Folder;
		public LocalFolderInstance?: Folder;

		public constructor(Name: string);

		public Fire(self: Client, EventName: string, ...Args: unknown[]): void;
		public Call(self: Client, EventName: string, ...Args: unknown[]): Promise<unknown>;
		public On(self: Client, EventName: string, ...Args: unknown[]): Promise<unknown>;
		public Folder(self: Client): Folder;
		public LocalFolder(self: Client): Folder;
	}
}
