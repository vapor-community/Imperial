import Foundation
import Vapor

struct ImgurRouter: FederatedServiceRouter {
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    let scope: [String]
    let callbackURL: String
    let accessTokenURL: String = "https://api.imgur.com/oauth2/token"

    init(
        callback: String,
        scope: [String],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try ImgurAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    func authURL(_ request: Request) throws -> String {
        return "https://api.imgur.com/oauth2/authorize?" + "client_id=\(self.tokens.clientID)&" + "response_type=token"
    }

    func fetchToken(from request: Request) async throws -> String {
        let refresh = try? request.query.get(String.self, at: "refresh_token")
        request.session.setRefreshToken(refresh)

        return try request.query.get(String.self, at: "access_token")
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        return Response(status: .badRequest)
    }

}
