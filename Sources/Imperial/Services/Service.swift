/// The services that are available for use in the application.
/// Services are added and fecthed with the `Service.register` and `.get` static methods.
fileprivate var services: [String: Service] = [:]

/// Represents a service that interacts with an OAuth provider.
public struct Service {
    
    /// The name of the service, i.e. "google", "github", etc.
    public let name: String
    
    /// The prefix for the access token when it is used in a authorization header. Defaults to 'Bearer '.
    public let tokenPrefix: String
    
    /// The endpoints for the provider's API to use for initializing `FederatedCreatable` types
    public let endpoints: [String: String]
    
    /// The service model that is used for interacting the the named OAuth provider.
    public let model: FederatedService.Type
    
    /// Registers a service as available for use.
    ///
    /// - Parameter service: The service to register.
    internal static func register(_ service: Service) {
        services[service.name] = service
    }
    
    /// Gets a service if it is available for use.
    ///
    /// - Parameter name: The name of the service to fetch.
    /// - Returns: The service that matches the name passed in.
    /// - Throws: `ImperialError.noServiceFound` if no service is found with the name passed in.
    public static func get(service name: String)throws -> Service {
        return try services[name] ?? ImperialError.noServiceFound(name)
    }
}
