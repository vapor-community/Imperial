@_exported import ImperialCore
import Vapor

public struct Google: FederatedService {
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        scope: [String] = [],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        try GoogleRouter(callback: callback, scope: scope, completion: completion)
            .configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }
}
