import Foundation
import Vapor

struct Auth0Router: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String, ByteBuffer?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String
    let callbackHeaders = HTTPHeaders([("Content-Type", "application/x-www-form-urlencoded")])
    /// Local properties
    let baseDomain: String
    let queryItems: [URLQueryItem]

    private static func providerURL(domain: String, path: String = "/oauth/token", queryItems: [URLQueryItem] = []) throws -> String {
        guard let url = providerComponents(domain: domain, path: path, queryItems: queryItems).url?.absoluteString else {
            throw Abort(.internalServerError)
        }
        return url
    }
    
    private static func providerComponents(domain: String, path: String, queryItems: [URLQueryItem] = []) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = domain
        components.path = path
        components.queryItems = queryItems
        return components
    }

    init(
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

    func authURL(_ request: Request) throws -> String {
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

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        Auth0CallbackBody(
            clientId: self.tokens.clientID,
            clientSecret: self.tokens.clientSecret,
            code: code,
            redirectURI: self.callbackURL
        )
    }
}
