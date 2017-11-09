import Vapor

public class GitHubRouter: FederatedServiceRouter {
    public let service: FederatedLoginService
    public let callbackCompletion: (String) -> ()
    public var scope: [String: String] = [:]
    public let callbackURL: String
    public let accessTokenURL: String = "https://github.com/login/oauth/access_token"
    public var authURL: String {
        return "https://github.com/login/oauth/authorize?" +
               "scope=\(scope.merge(with: ":"))&" +
               "client_id=\(self.service.clientID)"
    }
    
    public required init(callback: String, completion: @escaping (String) -> ()) throws {
        self.service = try GitHubAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    
    public func callback(_ request: Request)throws -> ResponseRepresentable {
        guard let code: String = try request.query?.get("code") else {
            throw Abort(.badRequest, reason: "Missing 'code' key from query")
        }
        let response = try drop.client.post(accessTokenURL)
        guard let json = response.json else {
            throw Abort(.internalServerError, reason: "Unable to get access token")
        }
        let accessToken: String = try json.get("access_token")
        callbackCompletion(accessToken)
        
        return Response(status: .ok)
    }
}
