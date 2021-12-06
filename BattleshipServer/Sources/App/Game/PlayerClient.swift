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

final class PlayerClient: WebSocketClient {
	
	var username: String
	var inGame: Bool = false
	var gameProposals: [GameProposal] = []
	
	init(socket: WebSocket, username: String) {
		self.username = username
		super.init(socket: socket)
	}
	
	
	func processMessage(_ message: String) {
		// deconstruct message for game commands
	}
	
	
	func sendGameProposal(from sender: String) -> Bool {
		if !inGame {
			let proposal = GameProposal(fromPlayer: sender)
			send(message: proposal)
			gameProposals.append(proposal)
			
			return true
		}
		return false
	}
	
	
	func removeProposalsFrom(sender: String) {
		gameProposals.removeAll { $0.fromPlayer == sender }
	}
	
	
	// Set in game status to true and send start game message
	func startGame() {
		inGame = true
		send(message: GameMessage(status: GameCode.start))
	}
}
