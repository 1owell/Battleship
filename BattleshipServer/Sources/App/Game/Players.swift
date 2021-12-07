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
	
	func endGame(winner: PlayerClient) {
		player1.client.endGame(didWin: winner == player1.client)
		player2.client.endGame(didWin: winner == player2.client)
	}
	
	func getOpponent(for player: PlayerClient) -> Game.Player {
		player1.client == player ? player2 : player1
	}
	
	mutating func setBoard(for player: PlayerClient, with ships: ShipPositions) -> Bool {
		if player1.client.id == player.id && player1.board == nil {
			player1.board = Board(shipPositions: ships)
			return true
		} else if player2.client.id == player.id && player2.board == nil {
			player2.board = Board(shipPositions: ships)
			return true
		}
		
		return false
	}
}
