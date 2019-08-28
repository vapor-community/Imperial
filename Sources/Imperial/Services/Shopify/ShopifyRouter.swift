import Vapor

public class ShopifyRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public var accessTokenURL: String = ""
    
    required public init(callback: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try ShopifyAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
//        guard let shop = request.query[String.self, at: "shop"] else { throw Abort(.badRequest) }
//
//        let nonce = String(UUID().uuidString.prefix(6))
//        try request.session.setNonce(nonce)
//
//        accessTokenURL = try accessTokenURLFrom(shop)
//        return try authURLFrom(shop, nonce: nonce).absoluteString
        fatalError()
    }
    
    /// Gets an access token from an OAuth provider.
    /// This method is the main body of the `callback` handler.
    ///
    /// - Parameters: request: The request for the route this method is called in.
    public func fetchToken(from request: Request) throws -> EventLoopFuture<String> {
//        // Extract the parameters to verify
//        guard let code = request.query[String.self, at: "code"],
//            let shop = request.query[String.self, at: "shop"],
//            let hmac = request.query[String.self, at: "hmac"] else { throw Abort(.badRequest) }
//
//        // Verify the request
//        if let state = request.query[String.self, at: "state"] {
//            let nonce = try request.session.nonce()
//            guard state == nonce else { throw Abort(.badRequest) }
//        }
//        guard URL(string: shop)?.isValidShopifyDomain() == true else { throw Abort(.badRequest) }
//        guard request.url.generateHMAC(key: tokens.clientSecret) == hmac else { throw Abort(.badRequest) }
//
//        // exchange code for access token
//        let body = ShopifyCallbackBody(code: code, clientId: tokens.clientID, clientSecret: tokens.clientSecret)
//        return try body.encode(using: request).flatMap(to: Response.self) { req in
//            guard let url = URL(string: self.accessTokenURL) else {
//                throw Abort(.internalServerError, reason: "Unable to convert String '\(self.accessTokenURL)' to URL")
//            }
//            req.method = .POST
//            req.url = url
//            return try request.make(Client.self).send(req)
//        }.flatMap(to: String.self) { response in
//            return response.content.get(String.self, at: ["access_token"])
//        }
        fatalError()
    }
    
    /// The route that the OAuth provider calls when the user has benn authenticated.
    ///
    /// - Parameter request: The request from the OAuth provider.
    /// - Returns: A response that should redirect the user back to the app.
    /// - Throws: Any errors that occur in the implementation code.
    public func callback(_ request: Request) throws -> EventLoopFuture<Response> {
//        return try self.fetchToken(from: request).flatMap(to: ResponseEncodable.self) { accessToken in
//            guard let domain = request.query[String.self, at: "shop"] else { throw Abort(.badRequest) }
//
//            let session = try request.session
//            session.setAccessToken(accessToken)
//            session.setShopDomain(domain)
//            session.setNonce(nil)
//
//            return try self.callbackCompletion(request, accessToken)
//            }.flatMap(to: Response.self) { response in
//                return try response.encode(for: request)
//        }
        fatalError()
    }
    
    private func authURLFrom(_ shop: String, nonce: String) throws -> URL {
        return URL(string: "https://\(shop)/admin/oauth/authorize?" + "client_id=\(tokens.clientID)&" +
            "scope=\(scope.joined(separator: ","))&" +
            "redirect_uri=\(callbackURL)&" +
            "state=\(nonce)")!
    }
    
    private func accessTokenURLFrom(_ shop: String) throws -> String {
        return "https://\(shop)/admin/oauth/access_token"
    }
}
