import Vapor
import Foundation

public class Auth0Router: FederatedServiceRouter {
    public let baseURL: String
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String)throws -> (Future<ResponseEncodable>)
    public var scope: [String] = [ ]
    public var requiredScopes = [ "openid" ]
    public let callbackURL: String
    public let accessTokenURL: String

    private func providerUrl(path: String) -> String {
        return self.baseURL.finished(with: "/") + path
    }
    
    public required init(callback: String, completion: @escaping (Request, String)throws -> (Future<ResponseEncodable>)) throws {
        let auth = try Auth0Auth()
        self.tokens = auth
        self.baseURL = "https://\(auth.domain)"
        self.accessTokenURL = baseURL.finished(with: "/") + "oauth/token"
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
        let path="authorize"

        var params=[
            "response_type=code",
            "client_id=\(self.tokens.clientID)",
            "redirect_uri=\(self.callbackURL)",
        ]

        let allScopes = self.scope + self.requiredScopes
        let scopeString = allScopes.joined(separator: " ").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if let scopes = scopeString {
            params += [ "scope=\(scopes)" ]
        }

        let rtn = self.providerUrl(path: path + "?" + params.joined(separator: "&"))
        return rtn
    }
    
    public func fetchToken(from request: Request)throws -> Future<String> {
        let code: String
        if let queryCode: String = try request.query.get(at: "code") {
            code = queryCode
        } else if let error: String = try request.query.get(at: "error") {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }
        
        let body = Auth0CallbackBody(clientId: self.tokens.clientID,
                                     clientSecret: self.tokens.clientSecret,
                                     code: code,
                                     redirectURI: self.callbackURL)
        
        return try body.encode(using: request).flatMap(to: Response.self) { request in
            guard let url = URL(string: self.accessTokenURL) else {
                throw Abort(.internalServerError, reason: "Unable to convert String '\(self.accessTokenURL)' to URL")
            }
            request.http.method = .POST
            request.http.url = url
            request.http.contentType = .urlEncodedForm

            return try request.make(Client.self).send(request)
        }.flatMap(to: String.self) { response in
            return response.content.get(String.self, at: ["access_token"])
        }
    }
    
    public func callback(_ request: Request)throws -> Future<Response> {
        return try self.fetchToken(from: request).flatMap(to: ResponseEncodable.self) { accessToken in
            let session = try request.session()
            
            session.setAccessToken(accessToken)
            try session.set("access_token_service", to: OAuthService.auth0)
            
            return try self.callbackCompletion(request, accessToken)
        }.flatMap(to: Response.self) { response in
            return try response.encode(for: request)
        }
    }
}
