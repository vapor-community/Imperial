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
        callback: String, queryItems: [URLQueryItem], completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
    ) throws {
        let tokens = try Auth0Auth()
        self.tokens = tokens
        self.baseDomain = tokens.domain
        self.accessTokenURL = try Self.providerURL(domain: tokens.domain)
        self.callbackURL = callback
        self.callbackCompletion = completion
        /// scope query item must contain `openid`
        var queryItems = queryItems
        if !queryItems.scope().contains("openid") {
            queryItems.append(.init(name: "scope", value: "openid"))
        }
        self.queryItems = queryItems + [
            .codeResponseTypeItem,
            .init(clientID: tokens.clientID),
            .init(redirectURIItem: callback),
        ]
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseDomain
        components.path = "/authorize"
        components.queryItems = self.queryItems
        return components
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
