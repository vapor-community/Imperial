import Vapor
import Foundation

final public class GitlabRouter: FederatedServiceRouter {
    public static var baseURL: String = "https://gitlab.com/"
    public static var callbackURL: String = "callback"
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "\(GitlabRouter.baseURL.finished(with: "/"))oauth/token"
    public let service: OAuthService = .gitlab
    
    public required init(callback: String, completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable) throws {
        self.tokens = try GitlabAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.gitlab.com"
        components.path = "/oauth/authorize"
        components.queryItems = [
            clientIDItem,
            .init(name: "redirect_uri", value: GitlabRouter.callbackURL),
            scopeItem,
            codeResponseTypeItem
        ]
        
        guard let url = components.url else {
            throw Abort(.internalServerError)
        }
        
        return url.absoluteString
    }
    
    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        GitlabCallbackBody(clientId: tokens.clientID,
                           clientSecret: tokens.clientSecret,
                           code: code,
                           grantType: "authorization_code",
                           redirectUri: GitlabRouter.callbackURL)
    }
}
