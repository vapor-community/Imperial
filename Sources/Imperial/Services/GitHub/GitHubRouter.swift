import Vapor
import Foundation

public class GitHubRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (String) -> (Future<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "https://github.com/login/oauth/access_token"
    public var authURL: String {
        return "https://github.com/login/oauth/authorize?" +
               "scope=\(scope.joined(separator: " "))&" +
               "client_id=\(self.tokens.clientID)"
    }
    
    public required init(callback: String, completion: @escaping (String) -> (Future<ResponseEncodable>)) throws {
        self.tokens = try GitHubAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func callback(_ request: Request)throws -> Future<ResponseEncodable> {
        let code: String
        if let queryCode: String = try request.query.get(at: "code") {
            code = queryCode
        } else if let error: String = try request.query.get(at: "error") {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }
        
        let bodyData = NSKeyedArchiver.archivedData(withRootObject: [
                "client_id": self.tokens.clientID,
                "client_secret": self.tokens.clientSecret,
                "code": code
            ])
        
        return try request.send(url: accessTokenURL, body: HTTPBody(bodyData)).flatMap(to: String.self, { (response) in
            return response.content.get(String.self, at: ["access_token"])
        }).map(to: ResponseEncodable.self, { (accessToken) in
            let session = try request.session()
            session.data.storage["access_token"] = accessToken
            session.data.storage["access_token_service"] = OAuthService.github
            
             return self.callbackCompletion(accessToken)
        })
    }
}
