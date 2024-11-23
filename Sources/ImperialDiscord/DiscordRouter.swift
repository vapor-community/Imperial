import Foundation
import Vapor

final public class DiscordRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let callbackURL: String
    public let accessTokenURL: String = "https://discord.com/api/oauth2/token"
    public let service: OAuthService = .discord
    public let callbackHeaders = HTTPHeaders([("Content-Type", "application/x-www-form-urlencoded")])

    public required init(
        callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try DiscordAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    public func authURL(_ request: Request) throws -> String {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "discord.com"
        components.path = "/api/oauth2/authorize"
        components.queryItems = [
            clientIDItem,
            .init(name: "redirect_uri", value: self.callbackURL),
            .init(name: "response_type", value: "code"),
            scopeItem,
        ]

        guard let url = components.url else {
            throw Abort(.internalServerError)
        }

        return url.absoluteString
    }

    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        return DiscordCallbackBody(
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            grantType: "authorization_code",
            code: code,
            redirectUri: self.callbackURL,
            scope: scope.joined(separator: " ")
        )
    }

}
