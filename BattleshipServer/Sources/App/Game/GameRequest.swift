//
//  File.swift
//  
//
//  Created by Lowell Pence on 12/5/21.
//

import Vapor

struct GameRequest: Content {
	let id: String
	let to: String
	let from: String
}

struct GameProposal: Content {
	let fromPlayer: String
}

struct InviteResponse: Content {
	let id: String
	let sender: String
	let response: Bool
}
