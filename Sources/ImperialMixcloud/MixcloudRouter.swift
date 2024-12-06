import Foundation
import Vapor

struct MixcloudRouter: FederatedServiceRouter {
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    let scope: [String]
    let callbackURL: String
    let accessTokenURL: String = "https://www.mixcloud.com/oauth/access_token"

    init(
        callback: String,
        scope: [String],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try MixcloudAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    func authURL(_ request: Request) throws -> String {
        return "https://www.mixcloud.com/oauth/authorize?" + "client_id=\(self.tokens.clientID)&" + "redirect_uri=\(self.callbackURL)"
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        MixcloudCallbackBody(
            code: code,
            clientId: self.tokens.clientID,
            clientSecret: self.tokens.clientSecret,
            redirectURI: self.callbackURL
        )
    }
}
