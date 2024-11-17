import Vapor
import Foundation

final public class Auth0Router: FederatedServiceRouter {
    public let baseURL: String
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public var scope: [String] = [ ]
    public var requiredScopes = [ "openid" ]
    public let callbackURL: String
    public let accessTokenURL: String
    public var service: OAuthService = .auth0
    public let callbackHeaders = HTTPHeaders([("Content-Type", "application/x-www-form-urlencoded")])

    private func providerUrl(path: String) -> String {
        return self.baseURL.finished(with: "/") + path
    }
    
    public required init(callback: String, completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable) throws {
        let auth = try Auth0Auth()
        self.tokens = auth
        self.baseURL = "https://\(auth.domain)"
        self.accessTokenURL = baseURL.finished(with: "/") + "oauth/token"
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
        let path="authorize"

        var params=[
            "response_type=code",
            "client_id=\(self.tokens.clientID)",
            "redirect_uri=\(self.callbackURL)",
        ]

        let allScopes = self.scope + self.requiredScopes
        let scopeString = allScopes.joined(separator: " ").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if let scopes = scopeString {
            params += [ "scope=\(scopes)" ]
        }

        let rtn = self.providerUrl(path: path + "?" + params.joined(separator: "&"))
        return rtn
    }

    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        Auth0CallbackBody(clientId: self.tokens.clientID,
                          clientSecret: self.tokens.clientSecret,
                          code: code,
                          redirectURI: self.callbackURL)
    }
}
