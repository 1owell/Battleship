//
//  File.swift
//  
//
//  Created by Lowell Pence on 12/6/21.
//

import Foundation

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
