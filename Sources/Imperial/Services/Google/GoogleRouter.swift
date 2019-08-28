import Vapor
import Foundation

public class GoogleRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    
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
    
    public func fetchToken(from request: Request) throws -> EventLoopFuture<String> {
//        let code: String
//        if let queryCode: String = try request.query.get(at: "code") {
//            code = queryCode
//        } else if let error: String = try request.query.get(at: "error") {
//            throw Abort(.badRequest, reason: error)
//        } else {
//            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
//        }
//
//        let body = GoogleCallbackBody(code: code, clientId: self.tokens.clientID, clientSecret: self.tokens.clientSecret, redirectURI: self.callbackURL)
//        return try body.encode(using: request).flatMap(to: Response.self) { request in
//            guard let url = URL(string: self.accessTokenURL) else {
//                throw Abort(.internalServerError, reason: "Unable to convert String '\(self.accessTokenURL)' to URL")
//            }
//            request.method = .POST
//            request.url = url
//            return try request.make(Client.self).send(request)
//        }.flatMap(to: String.self) { response in
//            return response.content.get(String.self, at: ["access_token"])
//        }
        fatalError()
    }
    
    public func callback(_ request: Request) throws -> EventLoopFuture<Response> {
//        return try self.fetchToken(from: request).flatMap { accessToken in
//            let session = try request.session
//
//            session.setAccessToken(accessToken)
//            try session.set("access_token_service", to: OAuthService.google)
//
//            return try self.callbackCompletion(request, accessToken)
//        }.flatMap(to: Response.self) { response in
//            return try response.encode(for: request)
//        }
        fatalError()
    }
}
