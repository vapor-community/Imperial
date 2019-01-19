import Vapor

public class ShopifyRouter: FederatedServiceRouter {
    
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (Future<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public var accessTokenURL: String {
        return _accessTokenURL
    }
    public var authURL: String {
        return _authURL
    }
    
    private var _accessTokenURL: String!
    private var _authURL: String!
    
    required public init(callback: String, completion: @escaping (Request, String) throws -> (Future<ResponseEncodable>)) throws {
        self.tokens = try ShopifyAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    /// The route thats called to initiate the auth flow
    /// ex. https://ed4da397.ngrok.io/login-shopify?shop=davidmuzi.myshopify.com
    ///
    /// - Parameter request: The request from the browser.
    /// - Returns: A response that, by default, redirects the user to `authURL`.
    /// - Throws: N/A
    public func authenticate(_ request: Request) throws -> Future<Response> {
        
        _authURL = try generateAuthenticationURL(request: request).absoluteString
        let redirect: Response = request.redirect(to: _authURL)
        return request.eventLoop.newSucceededFuture(result: redirect)
    }
    
    /// Gets an access token from an OAuth provider.
    /// This method is the main body of the `callback` handler.
    ///
    /// - Parameters: request: The request for the route this method is called in.
    public func fetchToken(from request: Request) throws -> EventLoopFuture<String> {
        
        // Extract the parameters to verify
        guard let code = request.query[String.self, at: "code"],
            let shop = request.query[String.self, at: "shop"],
            let hmac = request.query[String.self, at: "hmac"] else { throw Abort(.badRequest) }
        
        // Verify the request
        if let state = request.query[String.self, at: "state"] {
            let nonce = try request.session().nonce()
            guard state == nonce else { throw Abort(.badRequest) }
        }
        guard URL(string: shop)?.isValidShopifyDomain() == true else { throw Abort(.badRequest) }
        guard request.http.url.generateHMAC(key: tokens.clientSecret) == hmac else { throw Abort(.badRequest) }
        
        _accessTokenURL = try accessTokenURLFrom(request)
        
        // exchange code for access token
        let body = ShopifyCallbackBody(code: code, clientId: tokens.clientID, clientSecret: tokens.clientSecret)
        return try body.encode(using: request).flatMap(to: Response.self) { request in
            guard let url = URL(string: self.accessTokenURL) else {
                throw Abort(.internalServerError, reason: "Unable to convert String '\(self.accessTokenURL)' to URL")
            }
            request.http.method = .POST
            request.http.url = url
            return try request.make(Client.self).send(request)
            }.flatMap(to: String.self) { response in
                return response.content.get(String.self, at: ["access_token"])
        }
    }
    
    /// The route that the OAuth provider calls when the user has benn authenticated.
    ///
    /// - Parameter request: The request from the OAuth provider.
    /// - Returns: A response that should redirect the user back to the app.
    /// - Throws: Any errors that occur in the implementation code.
    public func callback(_ request: Request) throws -> EventLoopFuture<Response> {
        
        return try self.fetchToken(from: request).flatMap(to: ResponseEncodable.self) { accessToken in
            
            guard let domain = request.query[String.self, at: "shop"] else { throw Abort(.badRequest) }
            
            let session = try request.session()
            session.setAccessToken(accessToken)
            session.setShopDomain(domain)
            session.setNonce(nil)
            
            return try self.callbackCompletion(request, accessToken)
            }.flatMap(to: Response.self) { response in
                return try response.encode(for: request)
        }
    }
    
    /// Creates the authentication URL
    ///
    /// - Parameter request: the request from the browser to initiate authorization
    /// - Returns: fully formed URL that should be used to redirect back to Shopify
    /// - Throws: Any errors that occur in the implementation code.
    public func generateAuthenticationURL(request: Request) throws -> URL {
        let nonce = String(UUID().uuidString.prefix(6))
        try request.session().setNonce(nonce)
        return try authURLFrom(request, nonce: nonce)
    }
    
    private func authURLFrom(_ request: Request, nonce: String) throws -> URL {
        guard let shop = request.query[String.self, at: "shop"] else { throw Abort(.badRequest) }
        
        return URL(string: "https://\(shop)/admin/oauth/authorize?" + "client_id=\(tokens.clientID)&" +
            "scope=\(scope.joined(separator: ","))&" +
            "redirect_uri=\(callbackURL)&" +
            "state=\(nonce)")!
    }
    
    private func accessTokenURLFrom(_ request: Request) throws -> String {
        guard let shop = request.query[String.self, at: "shop"] else { throw Abort(.badRequest) }
        return "https://\(shop)/admin/oauth/access_token"
    }
}
