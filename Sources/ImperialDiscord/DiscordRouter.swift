import Foundation
import Vapor

public class DiscordRouter: FederatedServiceRouter {
    public static var baseURL: String = "https://discord.com/"
    public static var callbackURL: String = "callback"
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public var requiredScopes = ["identify"]
    public let callbackURL: String
    public let accessTokenURL: String = "\(DiscordRouter.baseURL.finished(with: "/"))api/oauth2/token"
    public let service: OAuthService = .discord
    public let callbackHeaders = HTTPHeaders([("Content-Type", "application/x-www-form-urlencoded")])

    public required init(callback: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try DiscordAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public func authURL(_ request: Request) throws -> String {
        let allScopes = scope + requiredScopes

        var components = URLComponents()
        components.scheme = "https"
        components.host = "discord.com"
        components.path = "/api/oauth2/authorize"
        components.queryItems = [
            clientIDItem,
            .init(name: "redirect_uri", value: callbackURL),
            .init(name: "response_type", value: "code"),
            .init(name: "scope", value: allScopes.joined(separator: " "))
        ]

        guard let url = components.url else {
            throw Abort(.internalServerError)
        }

        return url.absoluteString
    }

    public func callbackBody(with code: String) -> ResponseEncodable {
        return DiscordCallbackBody(
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            grantType: "authorization_code",
            code: code,
            redirectUri: callbackURL
        )
    }
}
