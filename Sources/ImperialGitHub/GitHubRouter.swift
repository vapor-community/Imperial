import Vapor
import Foundation

public class GitHubRouter: FederatedServiceRouter {

    public static var baseURL: String = "https://github.com/"
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let redirectURL: String
    public let accessTokenURL: String = "\(GitHubRouter.baseURL.finished(with: "/"))login/oauth/access_token"
    public let service: OAuthService = .github
    public let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .json
        return headers
    }()

    public required init(redirectURL: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try GitHubAuth()
        self.redirectURL = redirectURL
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
    
    public func callbackBody(with code: String) -> ResponseEncodable {
        GitHubCallbackBody(clientId: tokens.clientID,
                           clientSecret: tokens.clientSecret,
                           code: code)
    }

}
