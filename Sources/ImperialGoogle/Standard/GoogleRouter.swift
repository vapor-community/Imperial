import Vapor
import Foundation

final public class GoogleRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let callbackURL: String
    public let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    public let service: OAuthService = .google
    public let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        return headers
    }()

    public required init(callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable) throws {
        self.tokens = try GoogleAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
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
    
    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        GoogleCallbackBody(code: code,
                           clientId: tokens.clientID,
                           clientSecret: tokens.clientSecret,
                           redirectURI: callbackURL)
    }

}
