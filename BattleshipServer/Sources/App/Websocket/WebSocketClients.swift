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
	var clients: [UUID: Client]
	
	var active: [Client] {
		clients.values.filter { $0.isActive }
	}
	
	
	init(eventLoop: EventLoop, clients: [UUID:Client] = [:]) {
		self.eventLoop = eventLoop
		self.clients   = clients
	}
	
	
	init(eventLoop: EventLoop, clients: [UUID:WebSocketClient] = [:]) {
		self.eventLoop = eventLoop
		self.clients   = clients as? [UUID:Client] ?? [:]
	}
	
	
	deinit {
		let futures = clients.values.map { $0.socket.close() }
		try! eventLoop.flatten(futures).wait()
	}
	
	
	func add(_ client: Client) {
		clients[client.id] = client
	}
	
	
	func remove(_ client: Client) {
		clients.removeValue(forKey: client.id)
	}
	
	
	func find(_ uuid: UUID, isActive: Bool = true) -> Client? {
		if let client = clients[uuid] {
			if isActive {
				if client.isActive {
					return client
				}
			} else {
				return client
			}
		}
		
		return nil
	}
	
	
	func find(_ uuid: String, isActive: Bool = true) -> Client? {
		guard let uuid = UUID(uuidString: uuid) else { return nil }
		
		return find(uuid, isActive: isActive)
	}
	
	
	func broadcast<Message: Encodable>(message: Message) {
		active.forEach { client in
			client.send(message: message)
		}
	}
}
