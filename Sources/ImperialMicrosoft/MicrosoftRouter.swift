import Foundation
import Vapor

struct MicrosoftRouter: FederatedServiceRouter {
    static let tenantIDEnvKey: String = "MICROSOFT_TENANT_ID"
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, AccessToken, ResponseBody?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    var accessTokenURL: String { "https://login.microsoftonline.com/\(self.tenantID)/oauth2/v2.0/token" }
    let errorKey = "error_description"
    let isStateChecked = false
    /// Local properties
    var tenantID: String { Environment.get(MicrosoftRouter.tenantIDEnvKey) ?? "common" }
    let scope: String
    let queryItems: [URLQueryItem]

    init(
        options: some FederatedServiceOptions, completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        try Self.guard(options, is: Microsoft.Options.self)
        let tokens = try MicrosoftAuth()
        self.tokens = tokens
        self.callbackURL = options.callback
        self.callbackCompletion = completion
        self.scope = options.scope.joined(separator: " ")
        self.queryItems = options.queryItems
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
            scope: scope
        )
    }
}
