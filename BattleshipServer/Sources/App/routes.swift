import Vapor

func routes(_ app: Application) throws {
	// Initialize the game system
	let gameSystem = GameSystem(eventLoop: app.eventLoopGroup.next())
	
	// Start listening for web socket connections
	// Once a player (client) connects, they will be added to the system.
	app.webSocket("connect") { req, ws in
		print("Received connection attempt...")
		gameSystem.connect(ws)
	}


	app.put("username", ":uuid") { req -> HTTPStatus in
		if let id = UUID(uuidString: req.parameters.get("uuid")!),
		   let player = gameSystem.clients.find(id),
		   let username = req.body.string {
			guard gameSystem.usernameIsUnique(username) else { return HTTPStatus.conflict }
			
			player.setUsername(username)
			return HTTPStatus.ok
		} else {
			return HTTPStatus.notFound
		}
	}
}
