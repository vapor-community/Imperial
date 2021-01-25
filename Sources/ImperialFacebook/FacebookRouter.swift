import Vapor
import Foundation

public class FacebookRouter: FederatedServiceRouter {
    
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public var accessTokenURL: String = "https://graph.facebook.com/v3.2/oauth/access_token"
    public let service: OAuthService = .facebook

    public func authURL(_ request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.facebook.com"
        components.path = "/v3.2/dialog/oauth"
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

    public required init(callback: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try FacebookAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public func callbackBody(with code: String) -> ResponseEncodable {
        FacebookCallbackBody(code: code,
                             clientId: tokens.clientID,
                             clientSecret: tokens.clientSecret,
                             redirectURI: callbackURL)
    }

}
