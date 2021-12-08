import Vapor

// configures application
public func configure(_ app: Application) throws {
	
	// Serve files from public dir
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

	let corsConfiguration = CORSMiddleware.Configuration(
		allowedOrigin: .all,
		allowedMethods: [.GET, .POST, .PUT],
		allowedHeaders: [.accept, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
	)
	
	let cors = CORSMiddleware(configuration: corsConfiguration)
	
	app.middleware.use(cors, at: .beginning)
	
    // register routes
    try routes(app)
}
