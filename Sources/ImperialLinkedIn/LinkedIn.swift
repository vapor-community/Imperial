@_exported import ImperialCore
import Vapor

public struct LinkedIn: FederatedService {
    public let router: (any FederatedServiceRouter)?

    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        scope: [String] = ["openid", "profile", "email"],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        router = try LinkedInRouter(callback: callback, scope: scope, completion: completion)
        try router?.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }
}
