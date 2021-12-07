//
//  File.swift
//  
//
//  Created by Lowell Pence on 12/6/21.
//

import Foundation

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
