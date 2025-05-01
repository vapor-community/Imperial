import Vapor

/// Represents a connection to an OAuth provider to get an access token for authenticating a user.
///
/// Here is an example of the implementation of a federated service:
///
/// ```swift
/// import ImperialCore
/// import Vapor
///
/// public struct Service: FederatedService {
///     @discardableResult
///     public init(
///         routes: some RoutesBuilder,
///         authenticate: String,
///         authenticateCallback: (@Sendable (Request) async throws -> Void)?,
///         callback: String,
///         queryItems: [URLQueryItem],
///         completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
///     ) throws {
///         try ServiceRouter(callback: callback, scope: scope, completion: completion)
///             .configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
///     }
/// }
/// ```
public protocol FederatedService: Sendable {
    /// Required scopes for the provider.
    /// - Returns: Array of strings that must be included in the provider's URL request.
    static var requiredScopes: [String] { get }

    /// Separator used to combine scope values. Each provider can roll their own.
    /// - Returns: String value. Default is a single space.
    static var scopeSeparator: String { get }
    
    /// Convert completion handler ByteBuffer into a string.
    /// - Parameter buffer: ByteBuffer returned in completion handler.
    /// - Returns: An optional string.
    static func string(from buffer: ByteBuffer?) -> String?

    /// Creates a service for getting an access token from an OAuth provider.
    ///
    /// - Parameters:
    ///   - routes: The routes builder to configure the routes for the service.
    ///   - authenticate: The path for the route that will redirect the user to the OAuth provider for authentication.
    ///   - authenticateCallback: Execute custom code within the authenticate closure before redirection.
    ///   - callback: The path (or URI) for the route that the provider will call when the user authenticates.
    ///   - queryItems: Query items to send to the provider to request access to.
    ///   - completion: The completion handler that will fire at the end of the callback route. The access token and optional response body are passed into the callback and the response that is returned will be returned from the callback route. This will usually be a redirect back to the app.
    /// - Throws: Any errors that occur in the implementation.
    @discardableResult init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        queryItems: [URLQueryItem],
        completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
    ) throws
}

extension FederatedService {
    public static var requiredScopes: [String] { [] }
    
    public static var scopeSeparator: String { " " }
    
    public static func string(from buffer: ByteBuffer?) -> String? {
        guard var buffer = buffer else { return nil }
        return buffer.readString(length: buffer.readableBytes)
    }
}
