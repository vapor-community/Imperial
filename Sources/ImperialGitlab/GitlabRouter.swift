import Foundation
import Vapor

struct GitlabRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, AccessToken, ResponseBody?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String = "https://gitlab.com/oauth/token"
    /// Local properties
    let queryItems: [URLQueryItem]

    init(
        options: some FederatedServiceOptions, completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        let tokens = try GitlabAuth()
        self.tokens = tokens
        self.callbackURL = options.callback
        self.callbackCompletion = completion
        self.queryItems = options.queryItems
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.gitlab.com"
        components.path = "/oauth/authorize"
        components.queryItems = self.queryItems
        return components
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        GitlabCallbackBody(
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            code: code,
            grantType: "authorization_code",
            redirectUri: self.callbackURL
        )
    }
}
