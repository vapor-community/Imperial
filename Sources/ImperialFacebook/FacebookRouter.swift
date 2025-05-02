import Foundation
import Vapor

struct FacebookRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, AccessToken, ResponseBody?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String = "https://graph.facebook.com/v3.2/oauth/access_token"
    /// Local properties
    let queryItems: [URLQueryItem]

    init(
        options: some FederatedServiceOptions, completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        try Self.guard(options, is: Facebook.Options.self)
        let tokens = try FacebookAuth()
        self.tokens = tokens
        self.callbackURL = options.callback
        self.callbackCompletion = completion
        self.queryItems = options.queryItems
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.facebook.com"
        components.path = "/v3.2/dialog/oauth"
        components.queryItems = self.queryItems
        return components
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        FacebookCallbackBody(
            code: code,
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            redirectURI: callbackURL
        )
    }

}
