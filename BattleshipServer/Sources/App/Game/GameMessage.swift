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
}

struct GameMessage: Encodable {
	let status: Int
	let payload: ChatMessage?
	
	init(_ code: GameCode, payload: ChatMessage? = nil) {
		self.status = code.rawValue
		self.payload = payload
	}
}

struct GameState: Content {
	let playerState: [Int]
	let opponentState: [Int]
}



/**
 Possible game related messages
 
 - Game started - tell player clients to show game UI
	- Include both player names
 
 -> Need to wait for both players to submit their ship positions
	- 5 arrays of numbers
 -> Need to handle a game end request
 
 - Incoming attack message
	- Needs number 1-100
	
 - Handle incoming chat message
 
 - After each move, send full game state to each player
	- Each board state is an array of integers 0, 1, 2. 
 */
