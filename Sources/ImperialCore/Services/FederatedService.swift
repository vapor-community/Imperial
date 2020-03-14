import Vapor

/**
Represents a connection to an OAuth provider to get an access token for authenticating a user.
 
Usage:

```swift
import HTTP

public class Service: FederatedService {
    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter

    @discardableResult
    public required init(authenticate: String, callback: String, scope: [String] = [], completion: @escaping (String) -> (ResponseRepresentable)) throws {
        self.router = try ServiceRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens

        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: router)

        Service.register(.service)
    }
}
```
 */
public protocol FederatedService {
    
    /// The service's token model for getting the client ID and secret.
    var tokens: FederatedServiceTokens { get }
    
    /// The service's router for handling the request for the access token.
    var router: FederatedServiceRouter { get }
    
    /// Creates a service for getting an access token from an OAuth provider.
    ///
    /// - Parameters:
    ///   - authenticate: The path for the route that will redirect the user to the OAuth provider for authentication.
    ///   - authenticateCallback: Execute custom code within the authenticate closure before redirection.
    ///   - callback: The path (or URI) for the route that the provider will call when the user authenticates.
    ///   - scope: The scopes to send to the provider to request access to.
    ///   - completion: The completion handler that will fire at the end of the callback route. The access token is passed into the callback and the response that is returned will be returned from the callback route. This will usually be a redirect back to the app.
    /// - Throws: Any errors that occur in the implementation.
    init(routes: RoutesBuilder, authenticate: String, authenticateCallback: ((Request) throws -> (EventLoopFuture<Void>))?, callback: String, scope: [String], completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws
}
