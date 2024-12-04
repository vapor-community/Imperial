import Foundation
import Vapor

final public class MixcloudRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let callbackURL: String
    public let accessTokenURL: String = "https://www.mixcloud.com/oauth/access_token"

    public required init(
        callback: String,
        scope: [String],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try MixcloudAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    public func authURL(_ request: Request) throws -> String {
        return "https://www.mixcloud.com/oauth/authorize?" + "client_id=\(self.tokens.clientID)&" + "redirect_uri=\(self.callbackURL)"
    }

    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        MixcloudCallbackBody(
            code: code,
            clientId: self.tokens.clientID,
            clientSecret: self.tokens.clientSecret,
            redirectURI: self.callbackURL
        )
    }
}
