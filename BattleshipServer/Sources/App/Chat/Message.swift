//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/19/21.
//

import Foundation


// The data that the server will send to client(s)
struct ChatMessage: Encodable, Identifiable {
	let date = Date()
	let id = UUID()
	let username: String
	let message: String
}

// Sanitize chat messages
enum ChatHelper {
	static func verifyMessage(_ message: String, username: String) -> ChatMessage? {
		
		if !message.isEmpty {
			let sanitized = message.replacingOccurrences(of: "<[^>]+>",
														 with: "",
														 options: .regularExpression, range: nil)
			return ChatMessage(username: username, message: sanitized)
		}
		
		return nil
	}
}
