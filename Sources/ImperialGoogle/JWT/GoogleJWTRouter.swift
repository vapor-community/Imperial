import Crypto
import Foundation
import JWTKit
import Vapor

struct GoogleJWTRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, AccessToken, ResponseBody?) async throws -> any AsyncResponseEncodable // never called
    let callbackURL: String
    let accessTokenURL: String = "https://www.googleapis.com/oauth2/v4/token"
    let authURL: String
    let callbackHeaders: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.contentType = .urlEncodedForm
        return headers
    }()
    /// Local properties
    let scope: String

    init(
        options: some FederatedServiceOptions, completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try GoogleJWTAuth()
        self.callbackURL = options.callback
        self.authURL = options.callback
        self.callbackCompletion = completion
        self.scope = options.scope.joined(separator: " ")
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        guard let components = URLComponents(string: self.authURL) else {
            throw Abort(.internalServerError)
        }
        return components
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
                scope: self.scope,
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
