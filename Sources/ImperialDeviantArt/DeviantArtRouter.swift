import Foundation
import Vapor

struct DeviantArtRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String, ByteBuffer?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String = "https://www.deviantart.com/oauth2/token"
    /// Local properties
    let queryItems: [URLQueryItem]

    init(
        callback: String, queryItems: [URLQueryItem], completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try DeviantArtAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.queryItems = queryItems + [
            .codeResponseTypeItem,
            .init(clientID: tokens.clientID),
            .init(redirectURIItem: callback),
        ]
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.deviantart.com"
        components.path = "/oauth2/authorize"
        components.queryItems = self.queryItems
        return components
    }

    func fetchTokenAndResponseBody(from request: Request) async throws -> (String, ByteBuffer?) {
        try verifyState(request)
        let code: String
        if let queryCode: String = try request.query.get(at: codeKey) {
            code = queryCode
        } else if let error: String = try request.query.get(at: errorKey) {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }

        let body = callbackBody(with: code)
        let url = URI(string: accessTokenURL)

        let buffer = try await body.encodeResponse(for: request).body.buffer
        let response = try await request.client.post(url, headers: self.callbackHeaders) { $0.body = buffer }

        let refresh = try response.content.get(String.self, at: ["refresh_token"])
        request.session.setRefreshToken(refresh)

        let token = try response.content.get(String.self, at: ["access_token"])
        return (token, response.body)
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        DeviantArtCallbackBody(
            code: code,
            clientId: self.tokens.clientID,
            clientSecret: self.tokens.clientSecret,
            redirectURI: self.callbackURL
        )
    }
}
