//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/21/21.
//

import Vapor

struct Game {
	let chatRoom: ChatRoom
	var player1: PlayerClient
	var player2: PlayerClient
	
	var isPlayer1Turn = false
	
	init(player1: PlayerClient, player2: PlayerClient, chat: ChatRoom) {
		self.player1  = player1
		self.player2  = player2
		self.chatRoom = chatRoom
		
		player1.startGame()
		player2.startGame()
	}
	
	
	
	func endGame() {
		player1.inGame = false
		player2.inGame = false
	}
}

struct Board {
	typealias Target = (x: Int, y: Int)
	var player: PlayerClient
	var cells: [[Cell]] = []
	
	func registerAttack(at target: Target) {
//		if cells[target.x[target.y]].attacked {
//			return "already attacked"
//		} else {
//			cells[target.x[target.y]].attacked = true
//		}
	}
}

struct Cell {
	var ship: Ship?
	var attacked: Bool
}

enum Ship: CaseIterable {
	case patrolBoat
	case destroyer
	case submarine
	case battleship
	case carrier
	
	func length() -> Int {
		switch self {
			case .destroyer:
				return 3
			case .carrier:
				return 5
			case .patrolBoat:
				return 2
			case .submarine:
				return 3
			case .battleship:
				return 4
		}
	}
}

// Player will send an attack with an address like [2, 5], server will respond with hit or miss
