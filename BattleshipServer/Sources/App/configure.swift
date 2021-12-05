import Vapor

// configures application
public func configure(_ app: Application) throws {
	
	// Serve files from public dir
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

	
    // register routes
    try routes(app)
}
