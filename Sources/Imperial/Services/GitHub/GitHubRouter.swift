import Vapor

public class GitHubRouter: FederatedServiceRouter {
    public let service: FederatedLoginService
    public var scope: [String: String] = [:]
    public let callbackURL: String
    public let accessTokenURL: String = "https://github.com/login/oauth/access_token"
    public var authURL: String {
        return "https://github.com/login/oauth/authorize?" +
               "scope=\(scope.merge(with: ":"))&" +
               "client_id=\(self.service.clientID)"
    }
    
    public required init(callback: String) throws {
        self.service = try GitHubAuth()
        self.callbackURL = callback
    }
    
    public func callback(_ request: Request)throws -> ResponseRepresentable {
        return Response(redirect: "/")
    }
}
