import Testing
import Vapor

func withApp(_ test: (Application) async throws -> Void) async throws {
    let app = try await Application.make(.testing)
    try #require(isLoggingConfigured)
    do {
        app.middleware.use(app.sessions.middleware)
        try await test(app)
    } catch {
        try await app.asyncShutdown()
        throw error
    }
    try await app.asyncShutdown()
}

let isLoggingConfigured: Bool = {
    LoggingSystem.bootstrap { label in
        var handler = StreamLogHandler.standardOutput(label: label)
        handler.logLevel = .debug
        return handler
    }
    return true
}()
