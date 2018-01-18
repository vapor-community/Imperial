import Vapor
import HTTP

public class GoogleRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (String) -> (Future<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    public var authURL: String {
        return "https://accounts.google.com/o/oauth2/auth?" +
               "client_id=\(self.tokens.clientID)&" +
               "redirect_uri=\(self.callbackURL)&" +
               "scope=\(scope.joined(separator: " "))&" +
               "response_type=code"
    }
    
    public required init(callback: String, completion: @escaping (String) -> (Future<ResponseEncodable>)) throws {
        self.tokens = try GoogleAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func callback(_ request: Request)throws -> Future<ResponseEncodable> {
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
            "code": .string(code),
            "client_id": .string(self.tokens.clientID),
            "client_secret": .string(self.tokens.clientSecret),
            "grant_type": .string("authorization_code"),
            "redirect_uri": .string(self.callbackURL)
        ]
        let response = try drop.client.respond(to: req)
        
        guard let body = response.body.bytes,
            let accessToken: String = try JSON(bytes: body).get("access_token") else {
                throw Abort(.badRequest, reason: "Missing JSON from response body")
        }
        
        let session = try request.assertSession()
        try session.data.set("access_token", accessToken)
        try session.data.set("access_token_service", ImperialService.google)
        
        return callbackCompletion(accessToken)
    }
}
