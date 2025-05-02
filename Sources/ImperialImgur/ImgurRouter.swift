import Foundation
import Vapor

struct ImgurRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, AccessToken, ResponseBody?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    let accessTokenURL: String = "https://api.imgur.com/oauth2/token"
    let isStateChecked = false
    /// Local properties
    let queryItems: [URLQueryItem]

    init(
        options: some FederatedServiceOptions, completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        let tokens = try ImgurAuth()
        self.tokens = tokens
        self.callbackURL = options.callback
        self.callbackCompletion = completion
        self.queryItems = options.queryItems
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.imgur.com"
        components.path = "/oauth2/authorize"
        components.queryItems = self.queryItems
        return components
    }

    func fetchTokenAndResponseBody(from request: Request) async throws -> (AccessToken, ResponseBody?) {
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
        let responseBody: String? = response.body != nil ? .init(buffer: response.body!) : nil
        
        let refresh = try response.content.get(String.self, at: ["refresh_token"])
        request.session.setRefreshToken(refresh)

        let token = try response.content.get(String.self, at: ["access_token"])
        return (token, responseBody)
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        ImgurCallbackBody(code: code, clientId: self.tokens.clientID, clientSecret: self.tokens.clientSecret)
    }
}
