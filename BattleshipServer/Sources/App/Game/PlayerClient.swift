//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/20/21.
//

import Vapor

final class PlayerClient: WebSocketClient {
	
	private(set) var username: String?
	
	init(socket: WebSocket, username: String? = nil) {
		self.username = username
		super.init(socket: socket)
	}
	
	func setUsername(_ name: String) {
		username = name
	}	
}
