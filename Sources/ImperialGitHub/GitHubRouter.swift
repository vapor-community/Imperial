import Vapor
import Foundation

public class GitHubRouter: FederatedServiceRouter {

    public static var baseURL: String = "https://github.com/"
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "\(GitHubRouter.baseURL.finished(with: "/"))login/oauth/access_token"
    public let service: OAuthService = .github

    public required init(callback: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try GitHubAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
        return "\(GitHubRouter.baseURL.finished(with: "/"))login/oauth/authorize?" +
            "scope=\(scope.joined(separator: "%20"))&" +
            "client_id=\(self.tokens.clientID)"
    }
    
    public func body(with code: String) -> ResponseEncodable {
        GitHubCallbackBody(clientId: tokens.clientID,
                           clientSecret: tokens.clientSecret,
                           code: code)
    }

}
