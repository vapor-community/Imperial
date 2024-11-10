@_exported import ImperialCore
import Vapor

public class Auth0: FederatedService {
    public var tokens: any FederatedServiceTokens
    public var router: any FederatedServiceRouter
    
    @discardableResult
    public required init(
        routes: any RoutesBuilder,
        authenticate: String,
        authenticateCallback: ((Request) throws -> (EventLoopFuture<Void>))?,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String) throws -> (EventLoopFuture<any ResponseEncodable>)
    ) throws {
        self.router = try Auth0Router(callback: callback, completion: completion)
        self.tokens = self.router.tokens
        
        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
        
        OAuthService.register(.auth0)
    }
}
