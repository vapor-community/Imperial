import Foundation
import Vapor

public class MixcloudRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (Future<ResponseEncodable>)
    public var scope: [String] = []
    public var callbackURL: String
    public let accessTokenURL: String = "https://www.mixcloud.com/oauth/access_token"

    public required init(callback: String, completion: @escaping (Request, String) throws -> (Future<ResponseEncodable>)) throws {
        self.tokens = try MixcloudAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public func authURL(_ request: Request) throws -> String {
        return "https://www.mixcloud.com/oauth/authorize?" + "client_id=\(self.tokens.clientID)&" + "redirect_uri=\(self.callbackURL)"
    }

    public func fetchToken(from request: Request) throws -> Future<String> {
        let code: String
        if let queryCode: String = try request.query.get(at: "code") {
            code = queryCode
        } else if let error: String = try request.query.get(at: "error") {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }

        let body = MixcloudCallbackBody(
            code: code, clientId: self.tokens.clientID, clientSecret: self.tokens.clientSecret, redirectURI: self.callbackURL)
        return
            try request
            .client()
            .get(self.accessTokenURL) { request in
                try request.query.encode(body)
            }.flatMap(to: String.self) { response in
                return response.content.get(String.self, at: ["access_token"])
            }
    }

    public func callback(_ request: Request) throws -> Future<Response> {
        return try self.fetchToken(from: request).flatMap(to: ResponseEncodable.self) { accessToken in
            let session = try request.session()

            session.setAccessToken(accessToken)
            try session.set("access_token_service", to: OAuthService.mixcloud)

            return try self.callbackCompletion(request, accessToken)
        }.flatMap(to: Response.self) { response in
            return try response.encode(for: request)
        }
    }
}
