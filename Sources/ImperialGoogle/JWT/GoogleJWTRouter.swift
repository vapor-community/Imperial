import Foundation
import Crypto
import Vapor
import JWTKit

public final class GoogleJWTRouter: FederatedServiceRouter {
    
    public var tokens: any FederatedServiceTokens
    public var callbackCompletion: (Request, String) async throws -> any AsyncResponseEncodable
    public var scope: [String] = []
    public var callbackURL: String
    public var accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    public var authURL: String
    public let service: OAuthService = .googleJWT
    public let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        return headers
    }()
    
    public init(callback: String, completion: @escaping (Request, String) async throws -> some AsyncResponseEncodable) throws {
        self.tokens = try GoogleJWTAuth()
        self.callbackURL = callback
        self.authURL = callback
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
        return authURL
    }
    
    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        return "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(code)"
    }
    
    public func fetchToken(from request: Request) async throws -> String {
        let token = try self.jwt()
        
        let body = callbackBody(with: token)
		let url = URI(string: self.accessTokenURL)
		let buffer = try await body.encodeResponse(for: request).body.buffer
        let response = try await request.client.post(url, headers: self.callbackHeaders) { $0.body = buffer }
        return try response.content.get(GoogleJWTResponse.self).accessToken
    }
    
    public func authenticate(_ request: Request) async throws -> Response {
        request.redirect(to: self.callbackURL)
    }
    
    public func jwt() throws -> String {
        let payload = GoogleJWTPayload(
            iss: IssuerClaim(value: self.tokens.clientID),
            scope: self.scope.joined(separator: " "),
            aud: AudienceClaim(value: "https://www.googleapis.com/oauth2/v4/token"),
            iat: IssuedAtClaim(value: Date()),
            exp: ExpirationClaim(value: Date().addingTimeInterval(3600))
        )
        
        let pk = try RSAKey.private(pem: self.tokens.clientSecret.utf8)
        let signer = JWTSigner.rs256(key: pk)
        let jwtData = try signer.sign(payload)
        return jwtData
    }
}
