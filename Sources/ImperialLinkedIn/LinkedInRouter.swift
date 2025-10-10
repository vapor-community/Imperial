import Foundation
import Vapor

struct LinkedInRouter: FederatedServiceRouter {
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    let scope: [String]
    let callbackURL: String
    let accessTokenURL: String = "https://www.linkedin.com/oauth/v2/accessToken"
    let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        return headers
    }()

    init(
        callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try LinkedInAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    func authURL(_ request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.linkedin.com"
        components.path = "/oauth/v2/authorization"
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: tokens.clientID),
            URLQueryItem(name: "redirect_uri", value: callbackURL),
            URLQueryItem(name: "scope", value: scope.joined(separator: " ")),
        ]

        guard let url = components.url else {
            throw Abort(.internalServerError)
        }

        return url.absoluteString
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        LinkedInCallbackBody(
            code: code,
            redirectURI: callbackURL,
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret
        )
    }
}
