import Vapor
import Foundation

public class GitlabRouter: FederatedServiceRouter {

    public static var baseURL: String = "https://gitlab.com/"
    public static var callbackURL: String = "callback"
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "\(GitlabRouter.baseURL.finished(with: "/"))oauth/token"
    public let service: OAuthService = .gitlab
    
    public required init(callback: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try GitlabAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
        return "\(GitlabRouter.baseURL.finished(with: "/"))oauth/authorize?" +
            "client_id=\(self.tokens.clientID)&" +
            "redirect_uri=\(GitlabRouter.callbackURL)&" +
            "scope=\(scope.joined(separator: "%20"))&" +
            "response_type=code"
    }
    
    public func body(with code: String) -> ResponseEncodable {
        GitlabCallbackBody(clientId: tokens.clientID,
                           clientSecret: tokens.clientSecret,
                           code: code,
                           grantType: "authorization_code",
                           redirectUri: GitlabRouter.callbackURL)
    }
}
