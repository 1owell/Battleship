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
		
		func startTurn() {
			client.send(message: GameMessage(.turnStart))
		}
		
		func endTurn() {
			client.send(message: GameMessage(.turnEnd))
		}
	}
	
	let id: UUID
	let chatRoom: ChatRoom
	var players: Players
	var currentTurnPlayer: Player? = nil
	private var waitingOnPlayers = 2
	

	init(player1: PlayerClient, player2: PlayerClient, chat: ChatRoom) {
		let players = Players(player1: Game.Player(client: player1), player2: Game.Player(client: player2))
		let id = UUID()
		
		self.id = id
		self.players = players
		self.chatRoom = chat
		
		players.start(id: id)
	}
	
	
	func endGame(winner: PlayerClient) {
		players.endGame(winner: winner)
	}
	
	
	func processAttack(for player: PlayerClient, cell: Int) {
		// check turn
		guard currentTurnPlayer?.client == player else { return }
		
		if var board = players.getOpponent(for: player).board {
			if let attack = board.registerAttack(at: cell) {
				
				emitGameState()
				
				switch attack {
					case .missed, .hit:
						switchTurns()
					case .allSunk:
						endGame(winner: player)
				}
			}
		}
	}
	
	
	private func switchTurns() {
		guard let currentTurnPlayer = currentTurnPlayer else { return }

		let opponent = players.getOpponent(for: currentTurnPlayer.client)
		
		currentTurnPlayer.endTurn()
		opponent.startTurn()
		
		self.currentTurnPlayer = opponent
	}
	
	
	func createBoard(with ships: ShipPositions, for player: PlayerClient) {
		guard players.setBoard(for: player, with: ships) else { return }
		
		waitingOnPlayers -= 1
		if waitingOnPlayers == 0 {
			startGame()
		}
	}
	
	
	// tell the first player that it is their turn
	func startGame() {
		// TODO: Make a random player start
		players.player1.client.send(message: GameMessage(.turnStart))
		currentTurnPlayer = players.player1
	}
	
	
	func emitGameState() {
		guard let p1Board = players.player1.board, let p2Board = players.player2.board else { return }
		
		let p1BoardState = p1Board.getState()
		let p2BoardState = p2Board.getState()
		
		let p1State = GameState(playerState: p1BoardState, opponentState: p2BoardState)
		let p2State = GameState(playerState: p2BoardState, opponentState: p1BoardState)
		
		players.player1.client.send(message: p1State)
		players.player2.client.send(message: p2State)
	}
	
	
	func surrender(for player: PlayerClient) {
		endGame(winner: players.getOpponent(for: player).client)
	}
}
