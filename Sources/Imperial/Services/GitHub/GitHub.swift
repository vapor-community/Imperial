public class GitHub: FederatedService {
    public var auth: FederatedLoginService
    public var router: FederatedServiceRouter
    
    @discardableResult
    public required init(authenticate: String, callback: String, completion: @escaping (String) -> ()) throws {
        self.router = try GitHubRouter(callback: callback, completion: completion)
        self.auth = self.router.service
        
        try self.router.configureRoutes(withAuthURL: authenticate)
    }
}
