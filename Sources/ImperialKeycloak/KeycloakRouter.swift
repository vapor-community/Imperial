import Foundation
import Vapor

struct KeycloakRouter: FederatedServiceRouter {
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    let scope: [String]
    let callbackURL: String
    let accessTokenURL: String
    let authURL: String  // This is an additional property of `tokens` that is not in the protocol

    init(
        callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try KeycloakAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope

        // We need to access additional properties of `tokens` that are not in the protocol
        let keycloakTokens = self.tokens as! KeycloakAuth
        self.authURL = keycloakTokens.authURL
        self.accessTokenURL = keycloakTokens.accessTokenURL
    }

    func authURL(_ request: Request) throws -> String {
        return "\(self.authURL)/auth?"
            + "client_id=\(self.tokens.clientID)&"
            + "redirect_uri=\(self.callbackURL)&"
            + "scope=\(scope.joined(separator: "%20"))&"
            + "response_type=code"
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
