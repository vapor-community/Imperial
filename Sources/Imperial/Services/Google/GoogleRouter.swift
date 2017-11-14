import Vapor
import HTTP
import Sessions

public class GoogleRouter: FederatedServiceRouter {
    public let service: FederatedLoginService
    public let callbackCompletion: (String) -> (ResponseRepresentable)
    public var scope: [String: String] = [:]
    public let callbackURL: String
    public let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    public var authURL: String {
        return "https://accounts.google.com/o/oauth2/auth?" +
               "client_id=\(self.service.clientID)&" +
               "redirect_uri=\(self.callbackURL)&" +
               "scope=\(self.scope.mergeValues(with: " "))&" +
               "response_type=code"
    }
    
    public required init(callback: String, completion: @escaping (String) -> (ResponseRepresentable)) throws {
        self.service = try GoogleAuth()
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
            throw Abort(.badRequest, reason: "Missing expected values in URL query")
        }
        
        let req = Request(method: .post, uri: accessTokenURL)
        req.formURLEncoded = [
            "code": .string(code),
            "client_id": .string(self.service.clientID),
            "client_secret": .string(self.service.clientSecret),
            "grant_type": .string("authorization_code")
        ]
        let response = try drop.client.respond(to: req)
        
        guard let accessToken: String = try response.json?.get("access_token") else {
            throw Abort(.badRequest, reason: "Mssing JSON from response body")
        }
        
        let session = try request.assertSession()
        try session.data.set("access_token", accessToken)
        try session.data.set("access_token_server", "google")
        
        return callbackCompletion(accessToken)
    }
}
