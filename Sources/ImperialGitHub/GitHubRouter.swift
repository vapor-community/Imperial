import Vapor
import Foundation

public class GitHubRouter: FederatedServiceRouter {
    public static var baseURL: String = "https://github.com/"
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) async throws -> Response
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "\(GitHubRouter.baseURL.finished(with: "/"))login/oauth/access_token"
    public let service: OAuthService = .github
    public let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .json
        return headers
    }()

    public required init(callback: String, completion: @escaping (Vapor.Request, String) async throws -> Vapor.Response) async throws {
        self.tokens = try GitHubAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "github.com"
        components.path = "/login/oauth/authorize"
        components.queryItems = [
            clientIDItem,
            scopeItem
        ]
        
        guard let url = components.url else {
            throw Abort(.internalServerError)
        }
        
        return url.absoluteString
    }
    
    public func callbackBody(with code: String) -> any Content {
        GitHubCallbackBody(clientId: tokens.clientID,
                           clientSecret: tokens.clientSecret,
                           code: code)
    }

}
