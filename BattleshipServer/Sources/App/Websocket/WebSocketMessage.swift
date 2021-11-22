//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/17/21.
//

import Vapor


//struct WebSocketMessage<T: Decodable>: Decodable {
//	let payload: T
//}

struct Connect: Decodable {
	let username: String
}

extension String {
	func decodeWebSocketMessage<T: Decodable>(_ type: T.Type) -> T? {
		try? JSONDecoder().decode(type, from: self.data(using: .utf8) ?? Data())
	}
}

//extension ByteBuffer {
//	func decodeWebSocketMessage<T: Decodable>(_ type: T.Type) -> WebSocketMessage<T>? {
//		try? JSONDecoder().decode(WebSocketMessage<T>.self, from: self)
//	}
//}
