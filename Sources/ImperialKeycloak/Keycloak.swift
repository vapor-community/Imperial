@_exported import ImperialCore
import Vapor

public class Keycloak: FederatedService {
    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter

    @discardableResult
    public required init(
        routes: RoutesBuilder,
        authenticate: String,
        authenticateCallback: ((Request) throws -> (EventLoopFuture<Void>))?,
        redirectURL: String,
        scope: [String] = [],
        completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    ) throws {
        self.router = try KeycloakRouter(redirectURL: redirectURL, completion: completion)
        self.tokens = self.router.tokens

        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)

        OAuthService.register(.keycloak)
    }
}
