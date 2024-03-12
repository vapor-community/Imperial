@_exported import ImperialCore
import Vapor

public final class Shopify: FederatedService {

    public var tokens: FederatedServiceTokens { self.router.tokens }
    public var router: FederatedServiceRouter { self.shopifyRouter }

    public var shopifyRouter: ShopifyRouter

    public init(
        routes: RoutesBuilder,
        authenticate: String,
        authenticateCallback: ((Request) throws -> (EventLoopFuture<Void>))?,
        redirectURL: String,
        scope: [String],
        completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    ) throws {
        self.shopifyRouter = try ShopifyRouter(redirectURL: redirectURL, completion: completion)
        self.shopifyRouter.scope = scope

        try self.router.configureRoutes(
            withAuthURL: authenticate,
            authenticateCallback: authenticateCallback,
            on: routes
        )

        OAuthService.register(.shopify)
    }
}

