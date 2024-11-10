import Vapor
import Foundation

public class GoogleRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: (Request, String) async throws -> any AsyncResponseEncodable
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    public let service: OAuthService = .google
    public let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        return headers
    }()

    public required init(callback: String, completion: @escaping (Request, String) async throws -> any AsyncResponseEncodable) throws {
        self.tokens = try GoogleAuth()
        self.callbackURL = callback
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
    
    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        GoogleCallbackBody(code: code,
                           clientId: tokens.clientID,
                           clientSecret: tokens.clientSecret,
                           redirectURI: callbackURL)
    }

}
