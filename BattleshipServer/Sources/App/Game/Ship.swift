//
//  Ship.swift
//  
//
//  Created by Lowell Pence on 12/6/21.
//

import Vapor

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

		guard validCells, validAmount, validSize, validShips else {
			print(positions)
			print(allPositions)
			print("validCells? \(validCells)")
			print("validAmount? \(validAmount)")
			print("validSize? \(validSize)")
			print("validShips? \(validShips)")

			return false
		}

		// Check that for each shipPosition, the locations are connected either vertically or horizontally
		for shipPosition in positions {
			// check that the shipPosition array has integers that are either sequential, or all the same when modulo 10
			let shipPosition = shipPosition.sorted()
			if shipPosition.map { $0 - 1 }.dropFirst() == shipPosition.dropLast() {
				// Horizontal - check that ship doesn't span multiple rows
				if Board.getRow(for: shipPosition.first!) != Board.getRow(for: shipPosition.last!) {
					print("Ship is horizontal but on different columns \(shipPosition)")
					return false
				}
			} else {
				if Board.getCol(for: shipPosition.first!) != Board.getCol(for: shipPosition.last!) {
					print("Ship is vertical but on different rows \(shipPosition)")
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
