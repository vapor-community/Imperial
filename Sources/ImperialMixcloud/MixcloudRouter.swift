import Foundation
import Vapor

struct MixcloudRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String, ByteBuffer?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String = "https://www.mixcloud.com/oauth/access_token"
    let isStateChecked = false
    /// Local properties
    let queryItems: [URLQueryItem]

    init(
        callback: String,
        queryItems: [URLQueryItem],
        completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
    ) throws {
        let tokens = try MixcloudAuth()
        self.tokens = tokens
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.queryItems = queryItems + [
            .init(clientID: tokens.clientID),
            .init(redirectURIItem: callback),
        ]
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.mixcloud.com"
        components.path = "/oauth/authorize"
        components.queryItems = self.queryItems
        return components
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        MixcloudCallbackBody(
            code: code,
            clientId: self.tokens.clientID,
            clientSecret: self.tokens.clientSecret,
            redirectURI: self.callbackURL
        )
    }
}
