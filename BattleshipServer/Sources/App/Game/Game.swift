//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/21/21.
//

import Foundation

struct Game {
	var board: Board
}

struct Board {
	associatedtype Target = (x: Int, y: Int)
	var player: PlayerClient
	var cells: [[Cell]] = []
	
	func registerAttack(at target: Target) {
		if cells[target.x[target.y]].attacked {
			return "already attacked"
		} else {
			cells[target.x[target.y]].attacked = true
		}
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
