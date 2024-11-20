@_exported import ImperialCore
import Vapor

public final class Shopify: FederatedService {

    public var tokens: any FederatedServiceTokens { self.router.tokens }
    public var router: any FederatedServiceRouter { self.shopifyRouter }

    public var shopifyRouter: ShopifyRouter

    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        scope: [String],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.shopifyRouter = try ShopifyRouter(callback: callback, scope: scope, completion: completion)

        try self.router.configureRoutes(
            withAuthURL: authenticate,
            authenticateCallback: authenticateCallback,
            on: routes
        )

        OAuthService.services[OAuthService.shopify.name] = .shopify
    }
}
