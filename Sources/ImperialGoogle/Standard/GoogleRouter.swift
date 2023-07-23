import Vapor
import Foundation

public class GoogleRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    public let service: OAuthService = .google
    public var accessType: GoogleAccessType = .online
    public let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        return headers
    }()

    public required init(callback: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try GoogleAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public convenience init(
        callback: String, 
        completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>), 
        accessType: GoogleAccessType
    ) throws {
        try self.init(callback: callback, completion: completion)
        self.accessType = accessType
    }
    
    public func authURL(_ request: Request) throws -> String {        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.google.com"
        components.path = "/o/oauth2/v2/auth"
        components.queryItems = [
            clientIDItem,
            redirectURIItem,
            scopeItem,
            codeResponseTypeItem,
            accessTypeItem
        ]

        if accessType == .offline {
            components.queryItems?.append(promptItem)
        }
        
        guard let url = components.url else {
            throw Abort(.internalServerError)
        }
        
        return url.absoluteString
    }
    
    public func callbackBody(with code: String) -> ResponseEncodable {
        GoogleCallbackBody(code: code,
                           clientId: tokens.clientID,
                           clientSecret: tokens.clientSecret,
                           redirectURI: callbackURL)
    }

    public var accessTypeItem: URLQueryItem {
        .init(name: "access_type", value: accessType.rawValue)
    }

    public var promptItem: URLQueryItem {
        .init(name: "prompt", value: "consent")
    }

}
