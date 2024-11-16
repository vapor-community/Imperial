import Vapor

public class GoogleJWT: FederatedService {
    public var tokens: any FederatedServiceTokens
    public var router: any FederatedServiceRouter
    
    @discardableResult
    public required init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: ((Request) async throws -> Void)?,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.router = try GoogleJWTRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens
        
        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
        
        OAuthService.services[OAuthService.googleJWT.name] = .googleJWT
    }
}
