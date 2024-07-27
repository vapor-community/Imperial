import Vapor
import Foundation

public class RestreamRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) async throws -> Response
    public var scope: [String] = []
    public var callbackURL: String
    public let accessTokenURL: String = "https://api.restream.io/oauth/token"

    public required init(callback: String, completion: @escaping (Request, String) async throws -> Response) throws {
        self.tokens = try RestreamAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public var service: OAuthService { .restream }

    public func authURL(_ request: Request) throws -> String {
        var components = URLComponents(string: "https://api.restream.io/login")!
        components.queryItems = [
            clientIDItem,
            redirectURIItem,
            codeResponseTypeItem,
            URLQueryItem(name: "state", value: UUID().uuidString)
        ]
        if !scope.isEmpty {
            components.queryItems?.append(scopeItem)
        }
        return components.url!.absoluteString
    }

    public func callbackBody(with code: String) -> any Content {
        return RestreamCallbackBody(
            code: code,
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            redirectURI: callbackURL
        )
    }
}
