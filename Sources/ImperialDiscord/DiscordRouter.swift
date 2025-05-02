import Foundation
import Vapor

struct DiscordRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, AccessToken, ResponseBody?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String = "https://discord.com/api/oauth2/token"
    let callbackHeaders = HTTPHeaders([("Content-Type", "application/x-www-form-urlencoded")])
    /// Local properties
    let scope: String
    let queryItems: [URLQueryItem]

    init(
        options: some FederatedServiceOptions, completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        try Self.guard(options, is: Discord.Options.self)
        let tokens = try DiscordAuth()
        self.tokens = tokens
        self.callbackURL = options.callback
        self.callbackCompletion = completion
        self.scope = options.scope.joined(separator: " ")
        self.queryItems = options.queryItems
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
            scope: scope
        )
    }
}
