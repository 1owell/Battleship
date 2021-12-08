import Vapor

func routes(_ app: Application) throws {
	// Initialize the game system
	let gameSystem = GameSystem(eventLoop: app.eventLoopGroup.next())
	
	// Start listening for web socket connections
	// Once a player (client) connects, they will be added to the system.
	app.webSocket("connect") { req, ws in
		print("Received connection attempt...")
		
		struct Username: Content {
			let username: String
		}
		
		if let usernameReq = try? req.query.decode(Username.self) {
			let username = usernameReq.username
			
			if gameSystem.usernameIsValid(username) {
				gameSystem.connectPlayer(ws, username: username)
			} else {
				ws.close(code: .init(codeNumber: 4000), promise: nil)
			}
		} else {
			ws.close(promise: nil)
		}
	}
	
	
	// Updates the username for a given player (by ID)
	app.put("username", ":uuid") { req -> HTTPStatus in
		if let id = UUID(uuidString: req.parameters.get("uuid")!),
		   let player = gameSystem.players.find(id),
		   let username = req.body.string {
			
			if username.isEmpty { return HTTPStatus.badRequest }
			guard gameSystem.usernameIsValid(username) else { return HTTPStatus.conflict }
			
			player.username = username
			
			return HTTPStatus.ok
		} else {
			return HTTPStatus.notFound
		}
	}
	
	
	app.webSocket("globalchat") { req, ws in
		gameSystem.subscribeToGlobalChat(ws)
	}
	
	
	// Broadcasts the chat message to the chat room if they have a username and message is valid
	app.post("chat", ":uuid") { req -> HTTPStatus in
		if let id = UUID(uuidString: req.parameters.get("uuid")!),
		   let player = gameSystem.players.find(id),
		   let message = req.body.string {
			
			if gameSystem.postGlobalChatMessage(message, from: player) {
				return HTTPStatus.ok
			}
			
			return HTTPStatus.badRequest
		}
		
		return HTTPStatus.notFound
	}
	
	
	app.get("players") { req in
		gameSystem.activePlayers
	}
	
	
	app.post("requestGame") { req -> HTTPStatus in
		if let gameReq = try? req.query.decode(GameRequest.self) {
			if gameSystem.proposeGame(with: gameReq) {
				return HTTPStatus.ok
			}
		}
		
		return HTTPStatus.badRequest
	}
	
	
	app.post("inviteResponse") { req -> HTTPStatus in
		if let inviteRes = try? req.query.decode(InviteResponse.self) {
			if gameSystem.respondToInvite(inviteRes) {
				return HTTPStatus.ok
			}
			
			return HTTPStatus.notFound
		}
		
		return HTTPStatus.badRequest
	}
	
	
	// Submit the ships for a player's board
	app.post("game", "ships") { req -> HTTPStatus in
		let shipPositions = try req.content.decode(ShipPositions.self)
		
		guard let player = gameSystem.players.find(shipPositions.id) else { return HTTPStatus.notFound }
		
		guard player.inGame else { return HTTPStatus.badRequest }
		
		if ShipPositions.validateShipPositions(shipPositions.positions) {
			if gameSystem.submitShips(ships: shipPositions, for: player) {
				return HTTPStatus.ok
			} else {
				return HTTPStatus.notFound
			}
		} else {
			return HTTPStatus.badRequest
		}
	}
	
	
	app.post("game", "attack", ":uuid", ":cell") { req -> HTTPStatus in
		guard let cell = req.parameters.get("cell", as: Int.self),
			  let id   = UUID(uuidString: req.parameters.get("uuid")!),
				(cell > 0 && cell <= 100) else {
					return HTTPStatus.badRequest
				}
		
		guard let player = gameSystem.players.find(id) else { return HTTPStatus.notFound }
		
		gameSystem.processAttack(from: player, at: cell)
		
		return HTTPStatus.ok
	}
	
	
	app.post("game", "chat", ":uuid") { req -> HTTPStatus in
		guard let id = UUID(uuidString: req.parameters.get("uuid")!),
			  let player = gameSystem.players.find(id),
			  let message = req.body.string else {
				  return HTTPStatus.notFound
			  }
		
		if gameSystem.postGameChat(from: player, message: message) {
			return HTTPStatus.ok
		}
		
		return HTTPStatus.badRequest
	}


	app.post("game", "surrender", ":uuid") { req -> HTTPStatus in
		guard let id = UUID(uuidString: req.parameters.get("uuid")!),
			  let player = gameSystem.players.find(id) else {
				  return HTTPStatus.notFound
			  }
		
		gameSystem.surrenderGame(for: player)
		
		return HTTPStatus.ok
	}
}
