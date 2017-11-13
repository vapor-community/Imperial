import Vapor

public class GitHubRouter: FederatedServiceRouter {
    public let service: FederatedLoginService
    public let callbackCompletion: (String) -> (ResponseRepresentable)
    public var scope: [String: String] = [:]
    public let callbackURL: String
    public let accessTokenURL: String = "https://github.com/login/oauth/access_token"
    public var authURL: String {
        return "https://github.com/login/oauth/authorize?" +
               "scope=\(scope.merge(with: ":"))&" +
               "client_id=\(self.service.clientID)"
    }
    
    public required init(callback: String, completion: @escaping (String) -> (ResponseRepresentable)) throws {
        self.service = try GitHubAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func callback(_ request: Request)throws -> ResponseRepresentable {
        guard let code: String = try request.query?.get("code") else {
            throw Abort(.badRequest, reason: "Missing 'code' key from query")
        }
        
        let request = Request(method: .post, uri: accessTokenURL)
        request.formURLEncoded = [
            "client_id": .string(self.service.clientID),
            "client_secret": .string(self.service.clientSecret),
            "code": .string(code)
        ]
        
        let response = try drop.client.respond(to: request)
        
        guard let body = response.body.bytes else {
            throw Abort(.internalServerError, reason: "Unable to get body from access token response")
        }

        guard let accessToken: String = try Node(formURLEncoded: body, allowEmptyValues: false).get("access_token") else {
            throw Abort(.internalServerError, reason: "Unable to get access token from response body")
        }
        
        return callbackCompletion(accessToken)
    }
}
