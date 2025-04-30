import Foundation
import Vapor

struct MicrosoftRouter: FederatedServiceRouter {
    static let tenantIDEnvKey: String = "MICROSOFT_TENANT_ID"
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String, ByteBuffer?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    var accessTokenURL: String { "https://login.microsoftonline.com/\(self.tenantID)/oauth2/v2.0/token" }
    let errorKey = "error_description"
    let isStateChecked = false
    /// Local properties
    var tenantID: String { Environment.get(MicrosoftRouter.tenantIDEnvKey) ?? "common" }
    let scope: [String]
    let queryItems: [URLQueryItem]

    init(callback: String, queryItems: [URLQueryItem], completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
    ) throws {
        let tokens = try MicrosoftAuth()
        self.tokens = tokens
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = queryItems.scope()
        self.queryItems = queryItems + [
            .codeResponseTypeItem,
            .init(clientID: tokens.clientID),
            .init(redirectURIItem: callback),
            .init(name: "response_mode", value: "query"),
            .init(name: "prompt", value: "consent"),
        ]
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "login.microsoftonline.com"
        components.path = "/\(tenantID)/oauth2/v2.0/authorize"
        components.queryItems = self.queryItems
        return components
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        MicrosoftCallbackBody(
            code: code,
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            redirectURI: callbackURL,
            scope: scope.joined(separator: " ")
        )
    }
}
