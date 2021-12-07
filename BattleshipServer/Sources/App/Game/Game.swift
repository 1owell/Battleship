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
		guard currentTurn?.client == player else { return }
		
		// call board.attack
		// get other player's board
		if var board = players.getOpponent(for: player).board {
			if board.registerAttack(at: cell) {
				emitGameState()
			}
		}
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
		// TODO: Make a random player start
		players.player1.client.send(message: GameMessage(.turnStart))
	}
	
	
	func emitGameState() {
		guard let p1Board = players.player1.board, let p2Board = players.player2.board else { return }
		
		let p1State = GameState(playerState: p1Board.getState(), opponentState: p2Board.getState())
		let p2State = GameState(playerState: p2Board.getState(), opponentState: p1Board.getState())
		
		players.player1.client.send(message: p1State)
		players.player2.client.send(message: p2State)
	}
}
