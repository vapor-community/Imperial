@_exported import ImperialCore
import Vapor

public final class Shopify: FederatedService {

    public var tokens: FederatedServiceTokens { self.router.tokens }
    public var router: FederatedServiceRouter { self.shopifyRouter }

    public var shopifyRouter: ShopifyRouter

    public init(
        routes: RoutesBuilder,
        authenticate: String,
        authenticateCallback: ((Request) async throws -> Void)?,
        callback: String,
        scope: [String],
        completion: @escaping (Request, String) async throws -> Response
    ) async throws {
        self.shopifyRouter = try await ShopifyRouter(callback: callback, completion: completion)
        self.shopifyRouter.scope = scope

        try await self.router.configureRoutes(
            withAuthURL: authenticate,
            authenticateCallback: authenticateCallback,
            on: routes
        )

        OAuthService.register(.shopify)
    }
}

