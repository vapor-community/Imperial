import Vapor
import Foundation

public class GoogleRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let redirectURL: String
    public let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    public let service: OAuthService = .google
    public let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        return headers
    }()

    public required init(redirectURL: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try GoogleAuth()
        self.redirectURL = redirectURL
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.google.com"
        components.path = "/o/oauth2/auth"
        components.queryItems = [
            clientIDItem,
            redirectURIItem,
            scopeItem,
            codeResponseTypeItem
        ]
        
        guard let url = components.url else {
            throw Abort(.internalServerError)
        }
        
        return url.absoluteString
    }
    
    public func callbackBody(with code: String) -> ResponseEncodable {
        GoogleCallbackBody(code: code,
                           clientId: tokens.clientID,
                           clientSecret: tokens.clientSecret,
                           redirectURI: redirectURL)
    }

}
