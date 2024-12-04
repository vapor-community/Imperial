import Foundation
import Vapor

final public class GitlabRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let callbackURL: String
    public let accessTokenURL: String = "https://gitlab.com/oauth/token"

    public required init(
        callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try GitlabAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    public func authURL(_ request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.gitlab.com"
        components.path = "/oauth/authorize"
        components.queryItems = [
            clientIDItem,
            .init(name: "redirect_uri", value: self.callbackURL),
            scopeItem,
            codeResponseTypeItem,
        ]

        guard let url = components.url else {
            throw Abort(.internalServerError)
        }

        return url.absoluteString
    }

    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        GitlabCallbackBody(
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            code: code,
            grantType: "authorization_code",
            redirectUri: self.callbackURL
        )
    }
}
