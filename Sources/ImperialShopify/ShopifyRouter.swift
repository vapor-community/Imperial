import Vapor

public struct ShopifyRouter: FederatedServiceRouter {
    public let tokens: any FederatedServiceTokens
    public let callbackCompletion: @Sendable (Request, String) async throws -> any AsyncResponseEncodable
    public let scope: [String]
    public let callbackURL: String
    // `accessTokenURL` used to be set inside `authURL` and read by `fetchToken`
    // now `fetchToken` creates the `accessTokenURL` itself from the shop domain in the request
    // but the property is still required by the protocol, so it's set to an empty string
    public let accessTokenURL: String = ""

    public init(
        callback: String, scope: [String], completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.tokens = try ShopifyAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
        self.scope = scope
    }

    public func authURL(_ request: Request) throws -> String {
        guard let shop = request.query[String.self, at: "shop"] else { throw Abort(.badRequest) }

        let nonce = String(UUID().uuidString.prefix(6))
        try request.session.setNonce(nonce)

        var components = URLComponents()
        components.scheme = "https"
        components.host = shop
        components.path = "/admin/oauth/authorize"
        components.queryItems = [
            clientIDItem,
            .init(name: "scope", value: scope.joined(separator: ",")),
            redirectURIItem,
            .init(name: "state", value: nonce),
        ]

        guard let url = components.url else {
            throw Abort(.internalServerError)
        }

        return url.absoluteString
    }

    public func callbackBody(with code: String) -> any AsyncResponseEncodable {
        ShopifyCallbackBody(
            code: code,
            clientId: tokens.clientID,
            clientSecret: tokens.clientSecret
        )
    }

    /// Gets an access token from an OAuth provider.
    /// This method is the main body of the `callback` handler.
    ///
    /// - Parameters: request: The request for the route this method is called in.
    public func fetchToken(from request: Request) async throws -> String {
        // Extract the parameters to verify
        guard let code = request.query[String.self, at: "code"],
            let shop = request.query[String.self, at: "shop"],
            let hmac = request.query[String.self, at: "hmac"]
        else { throw Abort(.badRequest) }

        // Verify the request
        if let state = request.query[String.self, at: "state"] {
            let nonce = request.session.nonce()
            guard state == nonce else { throw Abort(.badRequest) }
        }
        guard URL(string: shop)?.isValidShopifyDomain == true else { throw Abort(.badRequest) }
        guard URL(string: request.url.string)?.generateHMAC(key: tokens.clientSecret) == hmac else { throw Abort(.badRequest) }

        // exchange code for access token
        let body = callbackBody(with: code)
        let url = URI(string: "https://\(shop)/admin/oauth/access_token")
        let buffer = try await body.encodeResponse(for: request).body.buffer
        let response = try await request.client.post(url) { $0.body = buffer }
        return try response.content.get(String.self, at: ["access_token"])
    }

    /// The route that the OAuth provider calls when the user has benn authenticated.
    ///
    /// - Parameter request: The request from the OAuth provider.
    /// - Returns: A response that should redirect the user back to the app.
    /// - Throws: Any errors that occur in the implementation code.
    public func callback(_ request: Request) async throws -> Response {
        let accessToken = try await self.fetchToken(from: request)
        let session = request.session
        guard let domain = request.query[String.self, at: "shop"] else { throw Abort(.badRequest) }
        try session.setAccessToken(accessToken)
        try session.setShopDomain(domain)
        try session.setNonce(nil)
        let response = try await self.callbackCompletion(request, accessToken)
        return try await response.encodeResponse(for: request)
    }
}
