//
//  File.swift
//  
//
//  Created by Lowell Pence on 11/21/21.
//

import Vapor

class Game: Identifiable {
	struct Player {
		let client: PlayerClient
		var board: Board? = nil
	}
	
	let id: UUID
	let chatRoom: ChatRoom
	var players: Players
	var currentTurn: Player? = nil
	private var waitingOnPlayers = 2
	

	init(player1: PlayerClient, player2: PlayerClient, chat: ChatRoom) {
		let players = Players(player1: Game.Player(client: player1), player2: Game.Player(client: player2))
		let id = UUID()
		
		self.id = id
		self.players = players
		self.chatRoom = chat
		
		players.start(id: id)
	}
	
	
	func endGame() {
		players.endGame()
	}
	
	
	func processAttack(for player: PlayerClient, cell: Int) {
		// check turn
		
		// call board.attack
		
		emitGameState()
	}
	
	
	func createBoard(with ships: ShipPositions, for player: PlayerClient) {
		players.setBoard(for: player, with: ships)
		
		waitingOnPlayers -= 1
		if waitingOnPlayers == 0 {
			startGame()
		}
	}
	
	
	func startGame() {
		// tell the first player that it is their turn
		
	}
	
	
	func emitGameState() {
		guard let p1Board = players.player1.board, let p2Board = players.player2.board else { return }
		
		let p1State = GameState(playerState: p1Board.getState(),
								opponentState: p2Board.getState())
		
		let p2State = GameState(playerState: p2Board.getState(),
								opponentState: p1Board.getState())
		
		players.player1.client.send(message: p1State)
		players.player2.client.send(message: p2State)
	}
}


struct Players {
	var player1: Game.Player
	var player2: Game.Player
	
	func start(id: UUID) {
		player1.client.startGame(gameID: id)
		player2.client.startGame(gameID: id)
	}
	
	func endGame() {
		player1.client.endGame()
		player2.client.endGame()
	}
	
	mutating func setBoard(for player: PlayerClient, with ships: ShipPositions) {
		if player1.client.id == player.id {
			player1.board = Board(shipPositions: ships)
		} else if player2.client.id == player.id {
			player2.board = Board(shipPositions: ships)
		}
	}
}


struct Board {
	private var cells: [Cell]

	init(shipPositions: ShipPositions) {
		var cells = [Cell]()
		for i in 1...100 {
			cells.append(Cell(isOccupied: shipPositions.contains(i)))
		}
		
		self.cells = cells
	}
	
	
	// boardIndex is 1-100
	mutating func registerAttack(at boardIndex: Int) -> Bool {
		guard boardIndex > 0 && boardIndex <= 100 else { return false }
		
		
		return cells[boardIndex - 1].attack()
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


enum Ship: ShipSet {
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


protocol ShipSet: CaseIterable {
	static func totalSize() -> Int
	static func shipSizes() -> [Int]
	func length() -> Int
}
