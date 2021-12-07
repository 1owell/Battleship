//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/20/21.
//

import Vapor

struct Player: Content {
	let username: String
	let inGame: Bool
}

/**
1.  Player1 sends a POST to /requestGame?to=Slayer&from=UUID
2. Server parses a GameRequest struct
3. Server finds the player that sent the request
4. Check that the player who sent the request is not in a game
5. Find the opponent by their username, then if they are active and not in game, send a proposal message through websocket, and save the sender's username in pendingRequests
 */

final class PlayerClient: WebSocketClient {
	
	var username: String
	var inGame: Bool { currentGame != nil }
	var pendingRequests: Set<PlayerClient> = []
	var currentGame: UUID? = nil
	
	init(socket: WebSocket, username: String) {
		self.username = username
		super.init(socket: socket)
	}
	
	
	func processMessage(_ message: String) {
		// deconstruct message for game commands
	}
	
	
	func sendGameProposal(from player: PlayerClient) -> Bool {
		if !inGame {
			send(message: GameProposal(fromPlayer: player.username))
			pendingRequests.insert(player)
			
			return true
		}
		return false
	}
	
	
	func removeRequestsFrom(sender: PlayerClient) {
		pendingRequests.remove(sender)
	}
	
	
	// Set in game status to true and send start game message
	func startGame(gameID: UUID) {
		currentGame = gameID
		send(message: GameMessage(GameCode.start))
	}
	
	func endGame() {
		currentGame = nil
	}
}
