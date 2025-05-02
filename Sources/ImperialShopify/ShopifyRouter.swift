import Vapor

struct ShopifyRouter: FederatedServiceRouter {
    /// FederatedServiceRouter properties
    let tokens: any FederatedServiceTokens
    let callbackCompletion: @Sendable (Request, AccessToken, ResponseBody?) async throws -> any AsyncResponseEncodable
    let callbackURL: String
    // `accessTokenURL` used to be set inside `authURL` and read by `fetchToken`
    // now `fetchToken` creates the `accessTokenURL` itself from the shop domain in the request
    // but the property is still required by the protocol, so it's set to an empty string
    let accessTokenURL: String = ""
    /// Local properties
    let queryItems: [URLQueryItem]

    init(
        options: some FederatedServiceOptions, completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        let tokens = try ShopifyAuth()
        self.tokens = tokens
        self.callbackURL = options.callback
        self.callbackCompletion = completion
        self.queryItems = options.queryItems
    }

    func authURLComponents(_ request: Request) throws -> URLComponents {
        guard let shop = request.query[String.self, at: "shop"] else { throw Abort(.badRequest) }
        var components = URLComponents()
        components.scheme = "https"
        components.host = shop
        components.path = "/admin/oauth/authorize"
        return components
    }

    func callbackBody(with code: String) -> any AsyncResponseEncodable {
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
    func fetchTokenAndResponseBody(from request: Request) async throws -> (AccessToken, ResponseBody?) {
        try verifyState(request)
        // Extract the parameters to verify
        guard let code = request.query[String.self, at: "code"],
            let shop = request.query[String.self, at: "shop"],
            let hmac = request.query[String.self, at: "hmac"]
        else { throw Abort(.badRequest) }

        guard URL(string: shop)?.isValidShopifyDomain == true else { throw Abort(.badRequest) }
        guard URL(string: request.url.string)?.generateHMAC(key: tokens.clientSecret) == hmac else { throw Abort(.badRequest) }

        // exchange code for access token
        let body = callbackBody(with: code)
        let url = URI(string: "https://\(shop)/admin/oauth/access_token")
        let buffer = try await body.encodeResponse(for: request).body.buffer
        let response = try await request.client.post(url) { $0.body = buffer }
        let responseBody: String? = response.body != nil ? .init(buffer: response.body!) : nil
        let token = try response.content.get(String.self, at: ["access_token"])
        return (token, responseBody)
    }

    /// The route that the OAuth provider calls when the user has benn authenticated.
    ///
    /// - Parameter request: The request from the OAuth provider.
    /// - Returns: A response that should redirect the user back to the app.
    /// - Throws: Any errors that occur in the implementation code.
    func callback(_ request: Request) async throws -> Response {
        let (accessToken, responseBody) = try await self.fetchTokenAndResponseBody(from: request)
        let session = request.session
        guard let domain = request.query[String.self, at: "shop"] else { throw Abort(.badRequest) }
        try session.setAccessToken(accessToken)
        try session.setShopDomain(domain)
        let response = try await self.callbackCompletion(request, accessToken, responseBody)
        return try await response.encodeResponse(for: request)
    }
}
