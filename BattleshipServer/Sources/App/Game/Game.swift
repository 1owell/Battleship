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
		
		func startTurn(state: GameState) {
			client.send(message: GameMessage(.turnStart, board: state))
		}
		
		func endTurn(state: GameState) {
			client.send(message: GameMessage(.turnEnd, board: state))
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
		
		if let board = players.getOpponent(for: player).board {
			if let attack = board.registerAttack(at: cell) {
			
				switch attack {
					case .missed, .hit:
						switchTurns()
					case .allSunk:
						switchTurns()
						endGame(winner: player)
				}
			}
		}
	}
	
	
	private func switchTurns() {
		guard let currentTurnPlayer = currentTurnPlayer, let gs1 = getGameState(for: currentTurnPlayer) else { return }

		let opponent = players.getOpponent(for: currentTurnPlayer.client)
		
		guard let gs2 = getGameState(for: opponent) else { return }
		
		currentTurnPlayer.endTurn(state: gs1)
		opponent.startTurn(state: gs2)
		
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
		currentTurnPlayer = players.player1
		switchTurns()
	}
	
	
	func getGameState(for player: Player) -> GameState? {
		guard let p1Board = players.player1.board, let p2Board = players.player2.board else { return nil }
		
		let p1BoardState = p1Board.getState()
		let p2BoardState = p2Board.getState()

		if player.client == players.player1.client {
			return GameState(playerState: p1BoardState, opponentState: p2BoardState)
		} else {
			return GameState(playerState: p2BoardState, opponentState: p1BoardState)
		}
	}
	
	
	func surrender(for player: PlayerClient) {
		endGame(winner: players.getOpponent(for: player).client)
	}
}
