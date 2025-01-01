import Crypto
import Foundation
import JWTKit
import Vapor

struct GoogleJWTRouter: FederatedServiceRouter {
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    let scope: [String]
    let callbackURL: String
    let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    let authURL: String
    let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        return headers
    }()

    init(
        callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try GoogleJWTAuth()
        self.callbackURL = callback
        self.authURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    func authURL(_ request: Request) throws -> String {
        return authURL
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
        return "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=\(code)"
    }

    func fetchToken(from request: Request) async throws -> String {
        let token = try await self.jwt

        let body = callbackBody(with: token)
        let url = URI(string: self.accessTokenURL)
        let buffer = try await body.encodeResponse(for: request).body.buffer
        let response = try await request.client.post(url, headers: self.callbackHeaders) { $0.body = buffer }
        return try response.content.get(GoogleJWTResponse.self).accessToken
    }

    func authenticate(_ request: Request) async throws -> Response {
        request.redirect(to: self.callbackURL)
    }

    private var jwt: String {
        get async throws {
            let payload = GoogleJWTPayload(
                iss: IssuerClaim(value: self.tokens.clientID),
                scope: self.scope.joined(separator: " "),
                aud: AudienceClaim(value: self.accessTokenURL),
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
