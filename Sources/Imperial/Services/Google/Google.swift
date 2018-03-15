import Vapor

public class Google: FederatedService {
    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter
    
    @discardableResult
    public required init(
        router: Router,
        authenticate: String,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String)throws -> (Future<ResponseEncodable>)
    ) throws {
        self.router = try GoogleRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens
        
        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate, on: router)
        
        OAuthService.register(.google)
    }
}
