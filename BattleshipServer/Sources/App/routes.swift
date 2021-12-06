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
			
			if gameSystem.usernameIsUnique(username) {
				gameSystem.connectPlayer(ws, username: username)
			} else {
				ws.close(code: .unacceptableData, promise: nil)
			}
		} else {
			ws.close(promise: nil)
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
	
	
	app.get("requestGame") { req -> HTTPStatus in
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


	// Updates the username for a given player (by ID)
	app.put("username", ":uuid") { req -> HTTPStatus in
		if let id = UUID(uuidString: req.parameters.get("uuid")!),
		   let player = gameSystem.players.find(id),
		   let username = req.body.string {
			guard gameSystem.usernameIsUnique(username) else { return HTTPStatus.conflict }
			
			player.username = username
			
			return HTTPStatus.ok
		} else {
			return HTTPStatus.notFound
		}
	}
}
