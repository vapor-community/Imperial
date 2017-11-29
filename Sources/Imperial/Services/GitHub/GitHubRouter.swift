import Vapor
import Sessions

public class GitHubRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (String) -> (ResponseRepresentable)
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "https://github.com/login/oauth/access_token"
    public var authURL: String {
        return "https://github.com/login/oauth/authorize?" +
               "scope=\(scope.joined(separator: " "))&" +
               "client_id=\(self.tokens.clientID)"
    }
    
    public required init(callback: String, completion: @escaping (String) -> (ResponseRepresentable)) throws {
        self.tokens = try GitHubAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func callback(_ request: Request)throws -> ResponseRepresentable {
        let code: String
        if let queryCode: String = try request.query?.get("code") {
            code = queryCode
        } else if let error: String = try request.query?.get("error") {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }
        
        let req = Request(method: .post, uri: accessTokenURL)
        req.formURLEncoded = [
            "client_id": .string(self.tokens.clientID),
            "client_secret": .string(self.tokens.clientSecret),
            "code": .string(code)
        ]
        
        let response = try drop.client.respond(to: req)
        
        guard let body = response.body.bytes else {
            throw Abort(.internalServerError, reason: "Unable to get body from access token response")
        }

        guard let accessToken: String = try Node(formURLEncoded: body, allowEmptyValues: false).get("access_token") else {
            throw Abort(.internalServerError, reason: "Unable to get access token from response body")
        }
        
        let session = try request.assertSession()
        try session.data.set("access_token", accessToken)
        try session.data.set("access_token_service", Service.github)
        
        return callbackCompletion(accessToken)
    }
}
