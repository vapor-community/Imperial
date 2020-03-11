import Vapor
import Foundation

public class ImgurRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String)throws -> (Future<ResponseEncodable>)
    public var scope: [String] = []
    public var callbackURL: String
    public let accessTokenURL: String = "https://api.imgur.com/oauth2/token"

    public required init(callback: String, completion: @escaping (Request, String)throws -> (Future<ResponseEncodable>)) throws {
        self.tokens = try ImgurAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public func authURL(_ request: Request) throws -> String {
        return "https://api.imgur.com/oauth2/authorize?" +
            "client_id=\(self.tokens.clientID)&" +
            "response_type=code"
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

        let body = ImgurCallbackBody(code: code, clientId: self.tokens.clientID, clientSecret: self.tokens.clientSecret)
        return try body.encode(using: request).flatMap(to: Response.self) { request in
            guard let url = URL(string: self.accessTokenURL) else {
                throw Abort(.internalServerError, reason: "Unable to convert String '\(self.accessTokenURL)' to URL")
            }
            request.http.method = .POST
            request.http.url = url
            return try request.make(Client.self).send(request)
        }.flatMap(to: String.self) { response in
            let session = try request.session()

            return response.content.get(String.self, at: ["refresh_token"])
            .flatMap { refresh in
                session.setRefreshToken(refresh)

                return response.content.get(String.self, at: ["access_token"])
            }
        }
    }

    public func callback(_ request: Request)throws -> Future<Response> {
        return try self.fetchToken(from: request).flatMap(to: ResponseEncodable.self) { accessToken in
            let session = try request.session()

            session.setAccessToken(accessToken)
            try session.set("access_token_service", to: OAuthService.imgur)

            return try self.callbackCompletion(request, accessToken)
        }.flatMap(to: Response.self) { response in
            return try response.encode(for: request)
        }
    }
}
