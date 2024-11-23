import Foundation
import Vapor
import Crypto

final public class XRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let callbackURL: String
    public let accessTokenURL: String = "https://api.twitter.com/2/oauth2/token"
    public let service: OAuthService = .x
    private let codeVerifier: String
    
    public required init(
        callback: String,
        scope: [String],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try XAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
        self.codeVerifier = Data((0..<32).map { _ in UInt8.random(in: 33...126) })
            .base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    public func authURL(_ request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "twitter.com"
        components.path = "/i/oauth2/authorize"
        
        let state = String(UUID().uuidString.prefix(6))
        try request.session.setState(state)
        
        // Store code verifier
        try request.session.setCodeChallenge(self.codeVerifier)
        
        // Generate code challenge using SHA256
        let hash = SHA256.hash(data: self.codeVerifier.data(using: .utf8)!)
        let codeChallenge = Data(hash).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        
        components.queryItems = [
            clientIDItem,
            redirectURIItem,
            .init(name: "scope", value: scope.joined(separator: "%20")),
            .init(name: "state", value: state),
            codeResponseTypeItem,
            .init(name: "code_challenge", value: codeChallenge),
            .init(name: "code_challenge_method", value: "S256")
        ]
        
        guard let url = components.url else {
            throw Abort(.internalServerError)
        }
        
        return url.absoluteString
    }
    
    public func fetchToken(from request: Request) async throws -> String {
        guard let code = request.query[String.self, at: "code"] else {
            throw Abort(.badRequest)
        }
        
        if let state = request.query[String.self, at: "state"] {
            let xState = request.session.state()
            guard state == xState else { throw Abort(.badRequest) }
        }
        
        let body = callbackBody(with: code)
        let url = URI(string: accessTokenURL)
        let buffer = try await body.encodeResponse(for: request).body.buffer
        let response = try await request.client.post(url) { $0.body = buffer }
        return try response.content.get(String.self, at: ["access_token"])
    }

    // public func refreshAccessToken(using refreshToken: String, on request: Request) async throws -> String {
    //     let body: [String: String] = [
    //         "grant_type": "refresh_token",
    //         "refresh_token": refreshToken,
    //         "client_id": tokens.clientID
    //     ]
    //     let url = URI(string: accessTokenURL)
        
    //     let credentials = "\(tokens.clientID):\(tokens.clientSecret)"
    //     let base64Credentials = Data(credentials.utf8).base64EncodedString()

    //     let response = try await request.client.post(url) { req in
    //         req.headers.contentType = .urlEncodedForm
    //         req.headers.add(name: .authorization, value: "Basic \(base64Credentials)")
    //         try req.content.encode(body, as: .urlEncodedForm)
    //     }

    //     return try response.content.get(String.self, at: ["access_token"])
    // }

    
    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        XCallbackBody(
            code: code,
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret,
            redirectURI: callbackURL,
            codeVerifier: self.codeVerifier
        )
    }
}
