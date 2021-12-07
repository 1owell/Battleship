//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/17/21.
//

import Vapor

// The main container for the entire server that handles setup and all player connections
class GameSystem {
	
	private(set) var players: WebSocketClients<PlayerClient>
	private let globalChat: ChatRoom
	private var activeGames: [UUID:Game] = [:]
	private let eventLoop: EventLoop
	
	var activePlayers: [Player] {
		players.active.compactMap { player in
			Player(username: player.username, inGame: player.inGame)
		}
	}
	
	init(eventLoop: EventLoop) {
		self.eventLoop = eventLoop
		players    = WebSocketClients(eventLoop: eventLoop)
		globalChat = ChatRoom(chatters: WebSocketClients(eventLoop: eventLoop))
	}
	
	
	// Adds the given websocket connection to the global chat room
	func subscribeToGlobalChat(_ ws: WebSocket) {
		let connection = WebSocketClient(socket: ws)
		
		globalChat.addConnection(connection)
		
		ws.onClose.whenComplete{ [unowned self] _ in
			globalChat.removeConnection(connection)
		}
	}
	
	
	// Attempts to broadcast the given message
	func postGlobalChatMessage(_ message: String, from player: PlayerClient) -> Bool {
		return globalChat.postChat(message: message, from: player)
	}
	
	
	func connectPlayer(_ ws: WebSocket, username: String) {
		
		// Initialize a new PlayerClient with a UUID
		let player = PlayerClient(socket: ws, username: username)
		
		// Add the player to the collection
		players.add(player)
		
		// Return player's id to client
		ws.send(player.id.uuidString)
		
		// Remove player when connection is closed
		ws.onClose.whenComplete { [unowned self] _ in
			players.remove(player)
		}
	}
	
	
	func postGameChat(from player: PlayerClient, message: String) -> Bool {
		if let gameID = player.currentGame, let game = activeGames[gameID] {
			return game.chatRoom.postChat(message: message, from: player)
		}
		
		return false
	}
	
	
	func proposeGame(with request: GameRequest) -> Bool {
		guard let player = players.find(request.from) else { return false }
		
		// Verify that the sender is not in a game
		guard player.inGame == false else { return false }
		
		// Find the requested opponent by their username
		if let opponent = players.active.first(where: { $0.username == request.to }) {
			guard opponent != player else { return false }
			
			if opponent.sendGameProposal(from: player) {
				return true
			}
			return true // even if they are in game should request was still OK
		}
	
		return false
	}
	
	
	func respondToInvite(_ inviteResponse: InviteResponse) -> Bool {
		// Retrieve the player client that is responding to the invite
		// Retrieve the game proposal that the player has
		guard let player = players.find(inviteResponse.id),
			  let player2 = player.pendingRequests.first(where: { $0.username == inviteResponse.sender }),
			  player != player2 else {
			return false
		}
		
		if inviteResponse.response == true {
			// create a game with the two players
			startGame(with: player, and: player2)
		}
		
		// TODO send message to sender that their invite was declined
		
		player.removeRequestsFrom(sender: player2)
		
		return true
	}
	
	
	func surrenderGame(for player: PlayerClient) {
		if let gameID = player.currentGame, let game = activeGames[gameID] {
			game.surrender(for: player)
		}
	}
	
	
	func submitShips(ships: ShipPositions, for player: PlayerClient) -> Bool {
		if let gameID = player.currentGame, let game = activeGames[gameID] {
			game.createBoard(with: ships, for: player)
			return true
		}
		
		return false
	}
	
	
	func processAttack(from player: PlayerClient, at cell: Int) {
		if let gameID = player.currentGame, let game = activeGames[gameID] {
			game.processAttack(for: player, cell: cell)
		}
	}
	
	
	func usernameIsUnique(_ username: String) -> Bool {
		players.active.first { $0.username == username } == nil
	}
	
	
	private func startGame(with player1: PlayerClient, and player2: PlayerClient) {
		// create a game state with the players, and initalize a chat session
		let chatRoom = createChatRoom(with: [player1, player2])
		let newGame  = Game(player1: player1, player2: player2, chat: chatRoom)
		
		activeGames[newGame.id] = newGame
	}
	
	
	private func createChatRoom(with clients: [WebSocketClient]) -> ChatRoom {
		let dict    = Dictionary(uniqueKeysWithValues: clients.map { ($0.id, $0) })
		let clients = WebSocketClients(eventLoop: eventLoop, clients: dict)
		
		return ChatRoom(chatters: clients)
	}
}


// TODO: If time permits
// Game is never cleared from the gameSystem, after it finishes
