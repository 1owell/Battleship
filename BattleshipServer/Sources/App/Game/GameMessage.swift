//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/20/21.
//

import Vapor

enum GameCode: Int {
	case gameStart = 0
	case turnStart = 1
	case turnEnd = 2
	case lost = 3
	case won = 4
	case chat = 5
	case gameRequest = 6
}

struct GameMessage: Encodable {
	let status: Int
	let chat: ChatMessage?
	let proposal: GameProposal?
	let board: GameState?
	
	init(_ code: GameCode, chat: ChatMessage? = nil, proposal: GameProposal? = nil, board: GameState? = nil) {
		self.status   = code.rawValue
		self.chat     = chat
		self.proposal = proposal
		self.board    = board
	}
}

struct GameState: Content {
	let playerState: [Int]
	let opponentState: [Int]
}

