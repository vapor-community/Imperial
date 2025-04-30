import Foundation
import Vapor

struct DiscordRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String, ByteBuffer?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String = "https://discord.com/api/oauth2/token"
    let callbackHeaders = HTTPHeaders([("Content-Type", "application/x-www-form-urlencoded")])
    /// Local properties
    let scope: [String]
    let queryItems: [URLQueryItem]

    init(
        callback: String, queryItems: [URLQueryItem], completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
    ) throws {
        let tokens = try DiscordAuth()
        self.tokens = tokens
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = queryItems.scope()
        self.queryItems = queryItems + [
            .codeResponseTypeItem,
            .init(clientID: tokens.clientID),
            .init(redirectURIItem: callback),
        ]
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "discord.com"
        components.path = "/api/oauth2/authorize"
        components.queryItems = self.queryItems
        return components
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        DiscordCallbackBody(
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            grantType: "authorization_code",
            code: code,
            redirectUri: self.callbackURL,
            scope: scope.joined(separator: " ")
        )
    }
}
