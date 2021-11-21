//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/19/21.
//

import Foundation


// Data received from a client
struct NewChatMessage: Decodable {
	let message: String
}


// The data that the server will send to client(s)
struct ChatMessage: Encodable, Identifiable {
	let date = Date()
	let id = UUID()
	let username: String
	let message: String
}


enum ChatHelper {
	static func verifyMessage(_ message: NewChatMessage, username: String) -> ChatMessage? {
		if !message.message.isEmpty {
			return ChatMessage(username: username, message: message.message)
		}
		
		return nil
	}
}
