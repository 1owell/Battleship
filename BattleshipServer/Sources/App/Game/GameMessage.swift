//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/20/21.
//

import Vapor

enum GameCode: Int {
	case start = 0
	case turnStart = 1
}

struct GameMessage: Codable {
	let status: Int
	
	init(_ code: GameCode) {
		self.status = code.rawValue
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
