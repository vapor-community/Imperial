import Vapor
import Foundation

public class DeviantArtRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) async throws -> Response
    public var scope: [String] = []
    public var callbackURL: String
    public let accessTokenURL: String = "https://www.deviantart.com/oauth2/token"

    public required init(callback: String, completion: @escaping (Request, String)async throws -> Response) throws {
        self.tokens = try DeviantArtAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public func authURL(_ request: Request) throws -> String {
        let scope : String
        if self.scope.count > 0 {
            scope = "scope="+self.scope.joined(separator: " ")+"&"
        } else {
            scope = ""
        }
        return "https://www.deviantart.com/oauth2/authorize?" +
            "client_id=\(self.tokens.clientID)&" +
            "redirect_uri=\(self.callbackURL)&\(scope)" +
            "response_type=code"
    }

    public func fetchToken(from request: Request) async throws -> String {
        let code: String
        if let queryCode: String = try request.query.get(at: "code") {
            code = queryCode
        } else if let error: String = try request.query.get(at: "error") {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }

        let body = DeviantArtCallbackBody(code: code, clientId: self.tokens.clientID, clientSecret: self.tokens.clientSecret, redirectURI: self.callbackURL)
        let requestBody = try await body.encode(using: request)
        guard let url = URL(string: self.accessTokenURL) else {
            throw Abort(.internalServerError, reason: "Unable to convert String '\(self.accessTokenURL)' to URL")
        }
        requestBody.http.method = .POST
        requestBody.http.url = url
        let response = try await requestBody.make(Client.self).send(request)
        let session = try request.session()

        return response.content.get(String.self, at: ["refresh_token"])
        .flatMap { refresh in
            session.setRefreshToken(refresh)

            return response.content.get(String.self, at: ["access_token"])
        }
        
    }

    public func callback(_ request: Request) async throws -> Response {
        let accessToken = try await self.fetchToken(from: request)
        let session = try request.session()

        session.setAccessToken(accessToken)
        try session.set("access_token_service", to: OAuthService.deviantart)

        let response = try await self.callbackCompletion(request, accessToken)
        return try response.encode(for: request)
        
    }
}
