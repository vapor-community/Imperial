import Foundation
import Crypto
import Vapor
import JWTKit

public final class GoogleJWTRouter: FederatedServiceRouter {
    
    public var tokens: FederatedServiceTokens
    public var callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
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
    
    public init(callback: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try GoogleJWTAuth()
        self.callbackURL = callback
        self.authURL = callback
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
        return authURL
    }
    
    public func callbackBody(with code: String) -> ResponseEncodable {
        return "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(code)"
    }
    
    public func fetchToken(from request: Request) throws -> EventLoopFuture<String> {
        let token = try self.jwt()
        
        let body = callbackBody(with: token)
		let url = URI(string: self.accessTokenURL)
		return body.encodeResponse(for: request)
            .map { $0.body.buffer }
            .flatMap { buffer in
                return request.client.post(url, headers: self.callbackHeaders) { $0.body = buffer }
            }.flatMapThrowing { response in
                return try response.content.get(GoogleJWTResponse.self)
            }.map { $0.accessToken }
    }
    
    public func authenticate(_ request: Request) throws -> EventLoopFuture<Response> {
        let redirect: Response = request.redirect(to: self.callbackURL)
        return request.eventLoop.makeSucceededFuture(redirect)
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
