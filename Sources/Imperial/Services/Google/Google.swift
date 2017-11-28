import HTTP

public class Google: FederatedService {
    public var auth: FederatedLoginService
    public var router: FederatedServiceRouter
    
    @discardableResult
    public required init(authenticate: String, callback: String, scope: [String: String] = [:], completion: @escaping (String) -> (ResponseRepresentable)) throws {
        self.router = try GoogleRouter(callback: callback, completion: completion)
        self.auth = self.router.service
        
        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate)
        
        Service.register(.google)
    }
}
