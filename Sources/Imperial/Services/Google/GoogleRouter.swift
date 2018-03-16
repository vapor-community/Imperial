import Vapor
import Foundation

public class GoogleRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String)throws -> (Future<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    public var authURL: String {
        return "https://accounts.google.com/o/oauth2/auth?" +
               "client_id=\(self.tokens.clientID)&" +
               "redirect_uri=\(self.callbackURL)&" +
               "scope=\(scope.joined(separator: " "))&" +
               "response_type=code"
    }
    
    public required init(callback: String, completion: @escaping (Request, String)throws -> (Future<ResponseEncodable>)) throws {
        self.tokens = try GoogleAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func callback(_ request: Request)throws -> Future<Response> {
        let code: String
        if let queryCode: String = try request.query.get(at: "code") {
            code = queryCode
        } else if let error: String = try request.query.get(at: "error") {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }
        
        let body = GoogleCallbackBody(code: code, clientId: self.tokens.clientID, clientSecret: self.tokens.clientSecret, redirectURI: self.callbackURL)
        return try request.make(Client.self).post(accessTokenURL, content: body).flatMap(to: String.self, { (response) in
            return response.content.get(String.self, at: ["access_token"])
        }).flatMap(to: ResponseEncodable.self, { (accessToken) in
            let session = try request.session()
            
            try session.set("access_token", to: accessToken)
            try session.set("access_token_service", to: OAuthService.google)
            
            return try self.callbackCompletion(request, accessToken)
        }).flatMap(to: Response.self, { (response) in
            return try response.encode(for: request)
        })
    }
}
