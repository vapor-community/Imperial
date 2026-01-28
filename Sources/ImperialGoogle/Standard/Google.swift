@_exported import ImperialCore
import Vapor

public struct Google: FederatedService {
    public let router: (any FederatedServiceRouter)?

    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        scope: [String] = [],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        router = try GoogleRouter(callback: callback, scope: scope, completion: completion)
        try router?.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }
}
