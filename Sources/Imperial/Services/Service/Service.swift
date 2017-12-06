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
    
    /// Creates an instance of a service.
    /// This is is usually done by creating an extension and a static property.
    ///
    /// - Parameters:
    ///   - name: The name of the service.
    ///   - prefix: The prefix for the access token when it is used in a authoriazation header.
    ///   - uri: The URI used to get data to initialize a `FederatedCreatable` type.
    ///   - model: The model that works with the service.
    public init(name: String, prefix: String? = nil, model: FederatedService.Type, endpoints: [String: String]) {
        self.name = name
        self.tokenPrefix = prefix ?? "Bearer "
        self.model = model
        self.endpoints = endpoints
    }
    
    /// Syntax sugar for getting one of the service's endpoints.
    public subscript (key: String) -> String? {
        return endpoints[key]
    }
    
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
        return try services[name] ?? ServiceError.noServiceFound(name)
    }
}
