@_exported import ImperialCore
import Vapor

public final class Shopify: FederatedService {

    public var tokens: any FederatedServiceTokens { self.router.tokens }
    public var router: any FederatedServiceRouter { self.shopifyRouter }

    public var shopifyRouter: ShopifyRouter

    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: ((Request) async throws -> Void)?,
        callback: String,
        scope: [String],
        completion: @escaping (Request, String) async throws -> any AsyncResponseEncodable
    ) throws {
        self.shopifyRouter = try ShopifyRouter(callback: callback, completion: completion)
        self.shopifyRouter.scope = scope

        try self.router.configureRoutes(
            withAuthURL: authenticate,
            authenticateCallback: authenticateCallback,
            on: routes
        )

        OAuthService.register(.shopify)
    }
}

