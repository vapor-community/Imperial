import Vapor

extension RoutesBuilder {
    
    /// Registers an OAuth provider's router with
    /// the parent route.
    ///
    /// - Parameters:
    ///   - provider: The provider who's router will be used.
    ///   - authUrl: The path to navigate to authenticate.
    ///   - authenticateCallback: Execute custom code within the authenticate closure before redirection.
    ///   - callback: The path or URL that the provider with
    ///     redirect to when authentication completes.
    ///   - scope: The scopes to get access to on authentication.
    ///   - completion: A callback with the current request and fetched
    ///     access token that is called when auth completes.
    public func oAuth<OAuthProvider>(
        from provider: OAuthProvider.Type,
        authenticate authUrl: String,
        authenticateCallback: ((Request) throws -> (EventLoopFuture<Void>))? = nil,
        redirectURL: String,
        scope: [String] = [],
        completion: @escaping (Request, String) throws -> EventLoopFuture<ResponseEncodable>
    ) throws where OAuthProvider: FederatedService {
        _ = try OAuthProvider(
            routes: self,
            authenticate: authUrl,
            authenticateCallback: authenticateCallback,
            redirectURL: redirectURL,
            scope: scope,
            completion: completion
        )
    }
    
    /// Registers an OAuth provider's router with
    /// the parent route and a redirection callback.
    ///
    /// - Parameters:
    ///   - provider: The provider who's router will be used.
    ///   - authUrl: The path to navigate to authenticate.
    ///   - authenticateCallback: Execute custom code within the authenticate closure before redirection.
    ///   - callback: The path or URL that the provider with
    ///     redirect to when authentication completes.
    ///   - scope: The scopes to get access to on authentication.
    ///   - redirect: The path/URL to redirect to when auth completes.
    public func oAuth<OAuthProvider>(
        from provider: OAuthProvider.Type,
        authenticate authUrl: String,
        authenticateCallback: ((Request) throws -> (EventLoopFuture<Void>))? = nil,
        redirectURL: String,
        scope: [String] = [],
        redirect: String
    ) throws where OAuthProvider: FederatedService {
        try self.oAuth(from: OAuthProvider.self, authenticate: authUrl, authenticateCallback: authenticateCallback, redirectURL: redirectURL, scope: scope) { (request, _) in
            let redirect: Response = request.redirect(to: redirect)
            return request.eventLoop.makeSucceededFuture(redirect)
        }
    }
}
