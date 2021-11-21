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
	
	public init(socket: WebSocket) {
		self.socket = socket
	}
}
