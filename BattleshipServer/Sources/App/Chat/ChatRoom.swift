//
//  ChatRoom.swift
//  
//
//  Created by Lowell Pence on 12/5/21.
//

import Vapor

final class ChatRoom {
	let chatters: WebSocketClients<WebSocketClient>
	
	init(chatters: WebSocketClients<WebSocketClient>) {
		self.chatters = chatters
	}
	
	
	func addConnection(_ client: WebSocketClient) {
		chatters.add(client)
	}
	
	
	func removeConnection(_ client: WebSocketClient) {
		chatters.remove(client)
	}
	
	
	// Sends the given message to each connection
	func postChat(message: String, from player: PlayerClient) -> Bool {
		if let message = ChatHelper.verifyMessage(message, username: player.username) {
			let gameMessage = GameMessage(.chat, payload: message)
			chatters.broadcast(message: gameMessage)
			return true
		}
		
		return false
	}
}
