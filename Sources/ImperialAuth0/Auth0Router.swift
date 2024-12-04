import Foundation
import Vapor

public struct Auth0Router: FederatedServiceRouter {
    public let baseURL: String
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let requiredScopes = ["openid"]
    public let callbackURL: String
    public let accessTokenURL: String
    public let callbackHeaders = HTTPHeaders([("Content-Type", "application/x-www-form-urlencoded")])

    private func providerUrl(path: String) -> String {
        return self.baseURL.finished(with: "/") + path
    }

    public init(
        callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        let auth = try Auth0Auth()
        self.tokens = auth
        self.baseURL = "https://\(auth.domain)"
        self.accessTokenURL = baseURL.finished(with: "/") + "oauth/token"
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    public func authURL(_ request: Request) throws -> String {
        let path = "authorize"

        var params = [
            "response_type=code",
            "client_id=\(self.tokens.clientID)",
            "redirect_uri=\(self.callbackURL)",
        ]

        let allScopes = self.scope + self.requiredScopes
        let scopeString = allScopes.joined(separator: " ").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if let scopes = scopeString {
            params += ["scope=\(scopes)"]
        }

        let rtn = self.providerUrl(path: path + "?" + params.joined(separator: "&"))
        return rtn
    }

    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        Auth0CallbackBody(
            clientId: self.tokens.clientID,
            clientSecret: self.tokens.clientSecret,
            code: code,
            redirectURI: self.callbackURL
        )
    }
}
