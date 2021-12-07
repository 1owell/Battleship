//
//  File.swift
//  
//
//  Created by Lowell Pence on 12/6/21.
//

import Foundation

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
	
	func getOpponent(for player: PlayerClient) -> Game.Player {
		player1.client == player ? player1 : player2
	}
	
	mutating func setBoard(for player: PlayerClient, with ships: ShipPositions) {
		if player1.client.id == player.id {
			player1.board = Board(shipPositions: ships)
		} else if player2.client.id == player.id {
			player2.board = Board(shipPositions: ships)
		}
	}
}
