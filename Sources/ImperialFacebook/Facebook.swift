@_exported import ImperialCore
import Vapor

public struct Facebook: FederatedService {
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        scope: [String] = [],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        // Facebook tokens are not refreshable
        let router = try FacebookRouter(callback: callback, scope: scope, completion: completion)
        try router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }
}
