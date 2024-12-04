import Foundation
import Vapor

final public class KeycloakRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let callbackURL: String
    public let accessTokenURL: String
    let authURL: String  // This is an additional property of `tokens` that is not in the protocol

    public required init(
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

    public func authURL(_ request: Request) throws -> String {
        return "\(self.authURL)/auth?"
            + "client_id=\(self.tokens.clientID)&"
            + "redirect_uri=\(self.callbackURL)&"
            + "scope=\(scope.joined(separator: "%20"))&"
            + "response_type=code"
    }

    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        KeycloakCallbackBody(
            code: code,
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            redirectURI: callbackURL
        )
    }
}
