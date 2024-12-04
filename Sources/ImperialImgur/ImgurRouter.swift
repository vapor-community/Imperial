import Foundation
import Vapor

public struct ImgurRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let callbackURL: String
    public let accessTokenURL: String = "https://api.imgur.com/oauth2/token"

    public init(
        callback: String,
        scope: [String],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try ImgurAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    public func authURL(_ request: Request) throws -> String {
        return "https://api.imgur.com/oauth2/authorize?" + "client_id=\(self.tokens.clientID)&" + "response_type=code"
    }

    public func fetchToken(from request: Request) async throws -> String {
        let code: String
        if let queryCode: String = try request.query.get(at: codeKey) {
            code = queryCode
        } else if let error: String = try request.query.get(at: errorKey) {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }

        let body = self.callbackBody(with: code)
        let url = URI(string: accessTokenURL)

        let buffer = try await body.encodeResponse(for: request).body.buffer
        let response = try await request.client.post(url, headers: self.callbackHeaders) { $0.body = buffer }

        let refresh = try response.content.get(String.self, at: ["refresh_token"])
        request.session.setRefreshToken(refresh)

        return try response.content.get(String.self, at: ["access_token"])
    }

    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        ImgurCallbackBody(code: code, clientId: self.tokens.clientID, clientSecret: self.tokens.clientSecret)
    }
}
