import Vapor

public class Auth0: FederatedService {
    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter
    
    @discardableResult
    public required init(
        router: Router,
        authenticate: String,
        authenticateCallback: ((Request)throws -> (Future<Void>))?,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String)throws -> (Future<ResponseEncodable>)
    )throws {
        self.router = try Auth0Router(callback: callback, completion: completion)
        self.tokens = self.router.tokens
        
        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: router)
        
        OAuthService.register(.auth0)
    }
}
