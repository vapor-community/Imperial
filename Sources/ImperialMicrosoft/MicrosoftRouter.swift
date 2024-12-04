import Foundation
import Vapor

public struct MicrosoftRouter: FederatedServiceRouter {
    public static let tenantIDEnvKey: String = "MICROSOFT_TENANT_ID"

    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let callbackURL: String
    public var tenantID: String { Environment.get(MicrosoftRouter.tenantIDEnvKey) ?? "common" }
    public var accessTokenURL: String { "https://login.microsoftonline.com/\(self.tenantID)/oauth2/v2.0/token" }
    public let errorKey = "error_description"

    public init(
        callback: String,
        scope: [String],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try MicrosoftAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    public func authURL(_ request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "login.microsoftonline.com"
        components.path = "/\(tenantID)/oauth2/v2.0/authorize"
        components.queryItems = [
            clientIDItem,
            redirectURIItem,
            scopeItem,
            codeResponseTypeItem,
            .init(name: "response_mode", value: "query"),
            .init(name: "prompt", value: "consent"),
        ]

        guard let url = components.url else {
            throw Abort(.internalServerError)
        }

        return url.absoluteString
    }

    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        MicrosoftCallbackBody(
            code: code,
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            redirectURI: callbackURL,
            scope: scope.joined(separator: " ")
        )
    }

}
