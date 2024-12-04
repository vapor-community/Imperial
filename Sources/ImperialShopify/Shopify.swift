@_exported import ImperialCore
import Vapor

public final class Shopify: FederatedService {
    public let tokens: any FederatedServiceTokens
    public let router: any FederatedServiceRouter

    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        scope: [String],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.router = try ShopifyRouter(callback: callback, scope: scope, completion: completion)
        self.tokens = self.router.tokens

        try self.router.configureRoutes(
            withAuthURL: authenticate,
            authenticateCallback: authenticateCallback,
            on: routes
        )
    }
}
