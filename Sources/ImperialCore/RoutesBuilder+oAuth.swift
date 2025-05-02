import Vapor

extension RoutesBuilder {
    public typealias AccessToken = FederatedService.AccessToken
    public typealias ResponseBody = FederatedService.ResponseBody
    
    /// Registers an OAuth provider's router with the parent route and all provider options.
    ///
    /// - Parameters:
    ///   - provider: The provider who's router will be used.
    ///   - authUrl: The path to navigate to authenticate.
    ///   - authenticateCallback: Execute custom code within the authenticate closure before redirection.
    ///   - callback: The path or URL that the provider with redirect to when authentication completes.
    ///   - queryItems: Query items appended to url provider's url.
    ///   - completion: A callback with the current request, the fetched access token and response body that is called when auth completes.
    public func oAuth<OAuthProvider>(
        from provider: OAuthProvider.Type,
        authenticate authUrl: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)? = nil,
        options: some FederatedServiceOptions,
        completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws where OAuthProvider: FederatedService {
        try OAuthProvider(
            routes: self,
            authenticate: authUrl,
            authenticateCallback: authenticateCallback,
            options: options,
            completion: completion
        )
    }

    /// Registers an OAuth provider's router with the parent route and just scope options.
    ///
    /// - Parameters:
    ///   - provider: The provider who's router will be used.
    ///   - authUrl: The path to navigate to authenticate.
    ///   - authenticateCallback: Execute custom code within the authenticate closure before redirection.
    ///   - callback: The path or URL that the provider with redirect to when authentication completes.
    ///   - scope: The scopes to get access to on authentication.
    ///   - completion: A callback with the current request, the fetched access token and response body that is called when auth completes.
    public func oAuth<OAuthProvider>(
        from provider: OAuthProvider.Type,
        authenticate authUrl: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)? = nil,
        callback: String,
        scope: [String] = [],
        completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws where OAuthProvider: FederatedService {
        let options = try provider.OptionsType(callback: callback, scope: scope)
        try self.oAuth(
            from: OAuthProvider.self, authenticate: authUrl, authenticateCallback: authenticateCallback, options: options, completion: completion
        )
    }

    /// Registers an OAuth provider's router with the parent route and a redirection callback.
    ///
    /// - Parameters:
    ///   - provider: The provider who's router will be used.
    ///   - authUrl: The path to navigate to authenticate.
    ///   - authenticateCallback: Execute custom code within the authenticate closure before redirection.
    ///   - callback: The path or URL that the provider with redirect to when authentication completes.
    ///   - scope: The scopes to get access to on authentication.
    ///   - redirectURL: The path/URL to redirect to when auth completes.
    public func oAuth<OAuthProvider>(
        from provider: OAuthProvider.Type,
        authenticate authUrl: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)? = nil,
        callback: String,
        scope: [String] = [],
        redirect redirectURL: String
    ) throws where OAuthProvider: FederatedService {
        try self.oAuth(
            from: OAuthProvider.self, authenticate: authUrl, authenticateCallback: authenticateCallback, callback: callback, scope: scope
        ) { (request, _, _) in
            return request.redirect(to: redirectURL)
        }
    }
}
