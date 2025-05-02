import Foundation
import Vapor

struct DropboxRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, AccessToken, ResponseBody?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String = "https://api.dropboxapi.com/oauth2/token"
    var callbackHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.basicAuthorization = .init(username: tokens.clientID, password: tokens.clientSecret)
        headers.contentType = .urlEncodedForm
        return headers
    }
    /// Local properties
    let queryItems: [URLQueryItem]


    init(
        options: some FederatedServiceOptions, completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        let tokens = try DropboxAuth()
        self.tokens = tokens
        self.callbackURL = options.callback
        self.callbackCompletion = completion
        self.queryItems = options.queryItems
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.dropbox.com"
        components.path = "/oauth2/authorize"
        components.queryItems = self.queryItems
        return components
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        DropboxCallbackBody(
            code: code,
            redirectURI: callbackURL
        )
    }
}
