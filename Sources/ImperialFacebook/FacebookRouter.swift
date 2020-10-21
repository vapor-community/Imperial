import Vapor
import Foundation

public class FacebookRouter: FederatedServiceRouter {
    
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public var accessTokenURL: String = "https://graph.facebook.com/v3.2/oauth/access_token"
    public let service: OAuthService = .facebook

    public func authURL(_ request: Request) throws -> String {
        return "https://www.facebook.com/v3.2/dialog/oauth?" +
            "client_id=\(self.tokens.clientID)" +
            "&redirect_uri=\(self.callbackURL)" +
            "&scope=\(scope.joined(separator: "%20"))" +
            "&response_type=code"
    }

    public required init(callback: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try FacebookAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public func callbackBody(with code: String) -> ResponseEncodable {
        FacebookCallbackBody(code: code,
                             clientId: tokens.clientID,
                             clientSecret: tokens.clientSecret,
                             redirectURI: callbackURL)
    }

}
