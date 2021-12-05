//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/17/21.
//

import Vapor

class WebSocketClient: Identifiable {
	let id: UUID = UUID()
	var socket: WebSocket
	
	var isActive: Bool {
		!socket.isClosed
	}
	
	public init(socket: WebSocket) {
		self.socket = socket
	}
	
	func send<Message: Encodable>(message: Message) {
		if let str = try? JSONEncoder().encode(message),
		   let payload = String(data: str, encoding: .utf8) {
			socket.send(payload)
		}
	}
}
