@_exported import ImperialCore
import Vapor

public struct Mixcloud: FederatedService {
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        scope: [String] = [],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        // Mixcloud does not seem to use refresh tokens
        let router = try MixcloudRouter(callback: callback, scope: scope, completion: completion)
        try router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }
}
