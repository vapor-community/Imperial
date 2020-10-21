import Vapor
import Foundation

public class GoogleRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    public let headers: HTTPHeaders = ["Content-Type": HTTPMediaType.urlEncodedForm.description]
    public let service: OAuthService = .google

    public required init(callback: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try GoogleAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public func authURL(_ request: Request) throws -> String {
        return "https://accounts.google.com/o/oauth2/auth?" +
            "client_id=\(self.tokens.clientID)&" +
            "redirect_uri=\(self.callbackURL)&" +
            "scope=\(scope.joined(separator: "%20"))&" +
        "response_type=code"
    }
    
    public func body(with code: String) -> ResponseEncodable {
        GoogleCallbackBody(code: code,
                           clientId: tokens.clientID,
                           clientSecret: tokens.clientSecret,
                           redirectURI: callbackURL)
    }

}
