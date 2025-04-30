import Foundation
import Vapor

struct GoogleRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String, ByteBuffer?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        return headers
    }()
    /// Local properties
    let queryItems: [URLQueryItem]

    init(
        callback: String, queryItems: [URLQueryItem], completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
    ) throws {
        let tokens = try GoogleAuth()
        self.tokens = tokens
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.queryItems = queryItems + [
            .codeResponseTypeItem,
            .init(clientID: tokens.clientID),
            .init(redirectURIItem: callback),
        ]
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.google.com"
        components.path = "/o/oauth2/auth"
        components.queryItems = self.queryItems
        return components
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        GoogleCallbackBody(
            code: code,
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            redirectURI: callbackURL
        )
    }
}
