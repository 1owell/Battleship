//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/17/21.
//

import Vapor
import Foundation

class WebSocketClients<Client: WebSocketClient> {
	
	var eventLoop: EventLoop
	var storage: [UUID: Client]
	
	var active: [Client] {
		storage.values.filter { !$0.socket.isClosed }
	}
	
	init(eventLoop: EventLoop, clients: [UUID: Client] = [:]) {
		self.eventLoop = eventLoop
		self.storage   = clients
	}
	
	func add(_ client: Client) {
		storage[client.id] = client
	}
	
	func remove(_ client: Client) {
		storage[client.id] = nil
	}
	
	func find(_ uuid: UUID) -> Client? {
		storage[uuid]
	}
	
	func broadcast<Message: Encodable>(message: Message) {
		if let str = try? JSONEncoder().encode(message), let payload = String(data: str, encoding: .utf8) {
			active.forEach { client in
				client.socket.send(payload)
			}
		}
	}
	
	deinit {
		let futures = storage.values.map { $0.socket.close() }
		try! eventLoop.flatten(futures).wait()
	}
}
