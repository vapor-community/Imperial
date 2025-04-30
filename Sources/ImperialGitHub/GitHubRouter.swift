import Foundation
import Vapor

struct GitHubRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String, ByteBuffer?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String = "https://github.com/login/oauth/access_token"
    let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .json
        return headers
    }()
    /// Local properties
    let queryItems: [URLQueryItem]

    init(
        callback: String, queryItems: [URLQueryItem], completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
    ) throws {
        let tokens = try GitHubAuth()
        self.tokens = tokens
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.queryItems = queryItems + [
            .init(clientID: tokens.clientID),
        ]
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "github.com"
        components.path = "/login/oauth/authorize"
        components.queryItems = self.queryItems
        return components
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        GitHubCallbackBody(
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            code: code
        )
    }

}
