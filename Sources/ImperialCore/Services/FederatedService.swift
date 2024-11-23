import Vapor

/// Represents a connection to an OAuth provider to get an access token for authenticating a user.
///
/// Usage:
///
/// ```swift
/// import ImperialCore
/// import Vapor
///
/// public class Service: FederatedService {
///     public var tokens: any FederatedServiceTokens
///     public var router: any FederatedServiceRouter
///
///     @discardableResult
///     public required init(
///         routes: some RoutesBuilder,
///         authenticate: String,
///         authenticateCallback: (@Sendable (Request) async throws -> Void)?,
///         callback: String,
///         scope: [String] = [],
///         completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
///     ) throws {
///         self.router = try ServiceRouter(callback: callback, scope: scope, completion: completion)
///         self.tokens = self.router.tokens
///
///         try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
///
///         OAuthService.services[OAuthService.service.name] = .service
///     }
/// }
/// ```
public protocol FederatedService: Sendable {
    /// The service's token model for getting the client ID and secret.
    var tokens: any FederatedServiceTokens { get }

    /// The service's router for handling the request for the access token.
    var router: any FederatedServiceRouter { get }

    /// Creates a service for getting an access token from an OAuth provider.
    ///
    /// - Parameters:
    ///   - authenticate: The path for the route that will redirect the user to the OAuth provider for authentication.
    ///   - authenticateCallback: Execute custom code within the authenticate closure before redirection.
    ///   - callback: The path (or URI) for the route that the provider will call when the user authenticates.
    ///   - scope: The scopes to send to the provider to request access to.
    ///   - completion: The completion handler that will fire at the end of the callback route. The access token is passed into the callback and the response that is returned will be returned from the callback route. This will usually be a redirect back to the app.
    /// - Throws: Any errors that occur in the implementation.
    init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        scope: [String],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws
}
