import Vapor

public class Google: FederatedService {
    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter
    
    @discardableResult
    public required init(authenticate: String, callback: String, scope: [String] = [], completion: @escaping (String) -> (Future<ResponseEncodable>)) throws {
        self.router = try GoogleRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens
        
        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate)
        
        Service.register(.google)
    }
}
