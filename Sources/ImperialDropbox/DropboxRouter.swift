import Foundation
import Vapor

struct DropboxRouter: FederatedServiceRouter {
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    let scope: [String]
    let callbackURL: String
    let accessTokenURL: String = "https://api.dropboxapi.com/oauth2/token"

    var callbackHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.basicAuthorization = .init(username: tokens.clientID, password: tokens.clientSecret)
        headers.contentType = .urlEncodedForm
        return headers
    }

    init(
        callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try DropboxAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    func authURL(_ request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.dropbox.com"
        components.path = "/oauth2/authorize"
        components.queryItems = [
            clientIDItem,
            redirectURIItem,
            scopeItem,
            codeResponseTypeItem,
        ]

        guard let url = components.url else {
            throw Abort(.internalServerError)
        }

        return url.absoluteString
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        DropboxCallbackBody(
            code: code,
            redirectURI: callbackURL
        )
    }
}
