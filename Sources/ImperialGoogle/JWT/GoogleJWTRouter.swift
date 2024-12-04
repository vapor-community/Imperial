import Crypto
import Foundation
import JWTKit
import Vapor

public final class GoogleJWTRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let callbackURL: String
    public let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    public let authURL: String
    public let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        return headers
    }()

    public init(
        callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try GoogleJWTAuth()
        self.callbackURL = callback
        self.authURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    public func authURL(_ request: Request) throws -> String {
        return authURL
    }

    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        return "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(code)"
    }

    public func fetchToken(from request: Request) async throws -> String {
        let token = try await self.jwt

        let body = callbackBody(with: token)
        let url = URI(string: self.accessTokenURL)
        let buffer = try await body.encodeResponse(for: request).body.buffer
        let response = try await request.client.post(url, headers: self.callbackHeaders) { $0.body = buffer }
        return try response.content.get(GoogleJWTResponse.self).accessToken
    }

    public func authenticate(_ request: Request) async throws -> Response {
        request.redirect(to: self.callbackURL)
    }

    private var jwt: String {
        get async throws {
            let payload = GoogleJWTPayload(
                iss: IssuerClaim(value: self.tokens.clientID),
                scope: self.scope.joined(separator: " "),
                aud: AudienceClaim(value: "https://www.googleapis.com/oauth2/v4/token"),
                iat: IssuedAtClaim(value: Date()),
                exp: ExpirationClaim(value: Date().addingTimeInterval(3600))
            )

            let pk = try Insecure.RSA.PrivateKey(pem: self.tokens.clientSecret)
            let keys = JWTKeyCollection()
            await keys.add(rsa: pk, digestAlgorithm: .sha256)
            return try await keys.sign(payload)
        }
    }
}
