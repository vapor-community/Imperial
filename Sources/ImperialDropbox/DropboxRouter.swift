import Vapor
import Foundation

public class DropboxRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: (Request, String) async throws -> any AsyncResponseEncodable
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "https://api.dropboxapi.com/oauth2/token"
    
    public var callbackHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.basicAuthorization = .init(username: tokens.clientID, password: tokens.clientSecret)
        headers.contentType = .urlEncodedForm
        return headers
    }
    
    public let service: OAuthService = .dropbox
    
    public required init(callback: String, completion: @escaping (Request, String) async throws -> any AsyncResponseEncodable) throws {
        self.tokens = try DropboxAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.dropbox.com"
        components.path = "/oauth2/authorize"
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
        DropboxCallbackBody(code: code,
                            redirectURI: callbackURL)
    }
    
}
