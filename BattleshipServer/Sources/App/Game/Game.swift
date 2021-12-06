//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/21/21.
//

import Vapor

struct Game {
	struct Player {
		let client: PlayerClient
		let board: Board? = nil
	}
	
	
	let chatRoom: ChatRoom
	let players: [UUID: Player] = [:]
	var isPlayer1Turn = false
	private var waitingOnPlayers = 2
	

	init(player1: PlayerClient, player2: PlayerClient, chat: ChatRoom) {
		players[player1.id] = Game.Player(client: player1)
		players[player2.id] = Game.Player(client: player2)
		self.chatRoom = chat
		
		player1.startGame()
		player2.startGame()
	}
	
	func endGame() {
		player1.inGame = false
		player2.inGame = false
	}
	
	func createBoard(with ships: ShipPositions, for player: PlayerClient) {
		players[player.id]?.board = Board(shipPositions: ships)
		waitingOnPlayers -= 1
		if waitingOnPlayers == 0 {
			startGame()
		}
	}
	
	func startGame() {
		// tell the first player that it is their turn
		
	}
}


struct Board {
	var cells: [Cell]

	init(shipPositions: ShipPositions) {
		var cells = [Cell]()
		for i in 1...100 {
			cells.append(Cell(isOccupied: shipPositions.contains(i)))
		}
		
		self.cells = cells
	}
	

	func getState() -> [Int] {
		cells.map { $0.state.rawValue }
	}
	
	static func getCol(for index: Int) -> Int {
		index % 10
	}

	static func getRow(for index: Int) -> Int {
		index / 10 + 1
	}
}


struct Cell {
	enum State: Int {
		case neutral = 0
		case missed  = 1
		case hit     = 2
	}

	var state = State.neutral
	var isOccupied = false

	mutating func attack() -> Bool {
		state = isOccupied ? .hit : .missed
		return isOccupied
	}
}


struct ShipPositions: Content {
	let id: String
	let positions: [[Int]]
	
	func contains(_ position: Int) -> Bool {
		positions.joined().contains(position)
	}
	
	static func validateShipPositions(_ positions: [[Int]]) -> Bool {
		let allPositions: [Int] = Array(Set(Array(positions.joined())))
		let validCells  = allPositions.allSatisfy { $0 > 0 && $0 <= 100 }
		let validSize   = allPositions.count == Ship.totalSize()
		let validAmount = positions.count == Ship.allCases.count
		let validShips  = positions.map({ $0.count }).sorted() == Ship.shipSizes()

		guard validCells, validAmount, validSize, validShips else { return false }

		// Check that for each shipPosition, the locations are connected either vertically or horizontally
		for shipPosition in positions {
			// check that the shipPosition array has integers that are either sequential, or all the same when modulo 10
			let shipPosition = shipPosition.sorted()
			if shipPosition.map { $0 - 1 }.dropFirst() == shipPosition.dropLast() {
				// Horizontal - check that ship doesn't span multiple rows
				if Board.getRow(for: shipPosition.first!) != Board.getRow(for: shipPosition.last!) {
					return false
				}
			} else {
				if Board.getCol(for: shipPosition.first!) != Board.getCol(for: shipPosition.last!) {
					return false
				}
			}
		}
		
		return true
	}
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

	// Returns a sorted array of ints that represent each ship's size
	static func shipSizes() -> [Int] {
		Ship.allCases.reduce([], { $0 + [$1.length()] }).sorted()
	}

	static func totalSize() -> Int {
		return 17
	}
}
