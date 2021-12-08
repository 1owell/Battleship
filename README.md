# Battleship

A web based version of the game Battleship. Front end using Svelte, and back end with Vapor Swift.

## Details

There is no database, the server side Swift stores all game data in memory.

Players are prompted for a username when visiting, and their session is uniquely identified by a UUID.

WebSockets are used to notify the client about game updates.