import ImperialCore
import Testing
import Vapor

let authURL = "service"
let callbackURL = "service-auth-complete"
let apiGroup = "api"
let apiAuthURL = "/\(apiGroup)/\(authURL)"
let apiCallbackURL = "/\(apiGroup)/\(callbackURL)"

func withApp<OAuthProvider>(
    service: OAuthProvider.Type,
    _ test: (Application) async throws -> Void
) async throws where OAuthProvider: FederatedService {
    let app = try await Application.make(.testing)
    try #require(isLoggingConfigured)
    do {
        app.middleware.use(app.sessions.middleware)
        // Test for https://github.com/vapor-community/Imperial/issues/43
        let grouped = app.grouped(PathComponent(stringLiteral: apiGroup))
        try grouped.oAuth(from: service.self, authenticate: authURL, callback: callbackURL, redirect: "/")
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
