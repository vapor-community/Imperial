import Foundation
import Vapor

struct KeycloakRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, AccessToken, ResponseBody?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String
    let authURL: String  // This is an additional property of `tokens` that is not in the protocol
    let isStateChecked = false
    /// Local properties
    let queryItems: [URLQueryItem]

    init(
        options: some FederatedServiceOptions, completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        try Self.guard(options, is: Keycloak.Options.self)
        let tokens = try KeycloakAuth()
        self.tokens = tokens
        self.callbackURL = options.callback
        self.callbackCompletion = completion
        self.queryItems = options.queryItems

        // We need to access additional properties of `tokens` that are not in the protocol
        let keycloakTokens = self.tokens as! KeycloakAuth
        self.authURL = keycloakTokens.authURL
        self.accessTokenURL = keycloakTokens.accessTokenURL
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        guard var components = URLComponents(string: self.authURL) else {
            throw Abort(.internalServerError)
        }
        components.path = "/auth"
        components.queryItems = self.queryItems
        return components
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        KeycloakCallbackBody(
            code: code,
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            redirectURI: callbackURL
        )
    }
}
