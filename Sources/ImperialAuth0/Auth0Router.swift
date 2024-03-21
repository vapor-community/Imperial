import Vapor
import Foundation

public class Auth0Router: FederatedServiceRouter {

    public let baseURL: String
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = [ ]
    public var requiredScopes = [ "openid" ]
    public let redirectURL: String
    public let accessTokenURL: String
    public var service: OAuthService = .auth0
    public let callbackHeaders = HTTPHeaders([("Content-Type", "application/x-www-form-urlencoded")])

    private func providerUrl(path: String) -> String {
        return self.baseURL.finished(with: "/") + path
    }
    
    public required init(redirectURL: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        let auth = try Auth0Auth()
        self.tokens = auth
        self.baseURL = "https://\(auth.domain)"
        self.accessTokenURL = baseURL.finished(with: "/") + "oauth/token"
        self.redirectURL = redirectURL
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
        let path="authorize"

        var params=[
            "response_type=code",
            "client_id=\(self.tokens.clientID)",
            "redirect_uri=\(self.redirectURL)",
        ]

        let allScopes = self.scope + self.requiredScopes
        let scopeString = allScopes.joined(separator: " ").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if let scopes = scopeString {
            params += [ "scope=\(scopes)" ]
        }

        let rtn = self.providerUrl(path: path + "?" + params.joined(separator: "&"))
        return rtn
    }

    public func callbackBody(with code: String) -> ResponseEncodable {
        Auth0CallbackBody(clientId: self.tokens.clientID,
                          clientSecret: self.tokens.clientSecret,
                          code: code,
                          redirectURI: self.redirectURL)
    }
}
