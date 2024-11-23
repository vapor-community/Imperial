import Foundation
import Vapor

final public class DropboxRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let callbackURL: String
    public let accessTokenURL: String = "https://api.dropboxapi.com/oauth2/token"

    public var callbackHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.basicAuthorization = .init(username: tokens.clientID, password: tokens.clientSecret)
        headers.contentType = .urlEncodedForm
        return headers
    }

    public let service: OAuthService = .dropbox

    public required init(
        callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try DropboxAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    public func authURL(_ request: Request) throws -> String {
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

    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        DropboxCallbackBody(
            code: code,
            redirectURI: callbackURL
        )
    }

}
