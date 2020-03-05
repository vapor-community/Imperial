import Vapor
import Foundation

public class MicrosoftRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String)throws -> (Future<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
    
    public required init(
        callback: String,
        completion: @escaping (Request, String) throws -> (Future<ResponseEncodable>)
    ) throws {
        self.tokens = try MicrosoftAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public func authURL(_ request: Request) throws -> String {
        return "https://login.microsoftonline.com/common/oauth2/v2.0/authorize?"
            + "client_id=\(self.tokens.clientID)&"
            + "response_type=code&"
            + "redirect_uri=\(self.callbackURL)&"
            + "response_mode=query&"
            + "scope=\(scope.joined(separator: "%20"))&"
            + "prompt=consent"
    }
    
    public func fetchToken(from request: Request)throws -> Future<String> {
        let code: String

        if let queryCode: String = try request.query.get(at: "code") {
            code = queryCode
        } else if let error: String = try request.query.get(at: "error_description") {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }

        let body = MicrosoftCallbackBody(
            code: code,
            clientId: self.tokens.clientID,
            clientSecret: self.tokens.clientSecret,
            redirectURI: self.callbackURL,
            scope: scope.joined(separator: "%20")
        )

        return try body.encode(using: request).flatMap(to: Response.self) { request in
            guard let url = URL(string: self.accessTokenURL) else {
                throw Abort(
                    .internalServerError,
                    reason: "Unable to convert String '\(self.accessTokenURL)' to URL"
                )
            }

            request.http.method = .POST
            request.http.url = url

            return try request.make(Client.self).send(request)
        }.flatMap(to: String.self) { response in
            return response.content.get(String.self, at: ["access_token"])
        }
    }
    
    public func callback(_ request: Request)throws -> Future<Response> {
        return try self.fetchToken(from: request).flatMap(to: ResponseEncodable.self) { accessToken in
            let session = try request.session()
            
            session.setAccessToken(accessToken)
            try session.set("access_token_service", to: OAuthService.microsoft)
            
            return try self.callbackCompletion(request, accessToken)
        }.flatMap(to: Response.self) { response in
            return try response.encode(for: request)
        }
    }
}
