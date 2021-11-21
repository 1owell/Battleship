//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/17/21.
//

import Vapor

class GameSystem {
	private(set) var clients: WebSocketClients<PlayerClient>
	
	init(eventLoop: EventLoop) {
		clients = WebSocketClients(eventLoop: eventLoop)
	}
	
	func connect(_ ws: WebSocket) {
		
		// Initialize a new PlayerClient with a UUID
		let player = PlayerClient(socket: ws)
		
		// Add the player to the collection
		clients.add(player)
		
		// Return player's id to client
		ws.send(player.id.uuidString)
		
		// Handle incoming string from websocket
		ws.onText { [unowned self] ws, text in
			handleIncomingText(text, with: ws, player: player)
		}
		
		// Remove player when connection is closed
		ws.onClose.whenComplete { [unowned self] _ in
			clients.remove(player)
		}
	}
	
	
	func usernameIsUnique(_ username: String) -> Bool {
		clients.active.first { $0.username == username } == nil
	}
	
	
	private func handleIncomingText(_ text: String, with webSocket: WebSocket, player: PlayerClient) {
		guard let username = player.username else {
			webSocket.send("Cannot chat until you have a username!")
			return
		}
		
		if let chatMessage = text.decodeWebSocketMessage(NewChatMessage.self) {
			if let broadcastMessage = ChatHelper.verifyMessage(chatMessage, username: username) {
				clients.broadcast(message: broadcastMessage)
			}
		}
		
		if let gameMessage = text.decodeWebSocketMessage(GameMessage.self) {
			// handle game message
		}
	}
	
	private func verifyUsername(_ username: String) -> Bool {
		// check that username is unique
		return true
	}
}
