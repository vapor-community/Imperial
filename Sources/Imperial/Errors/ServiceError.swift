/// Represents an error that occurs during a service action.
public enum ServiceError: Error, CustomStringConvertible {
    
    /// Thrown when no service is registered with a given name.
    case noServiceFound(String)
    
    /// Thrown when no `FederatedSewrvice` type is found whgen creating a `Service` from JSON.
    case noExistingService(String)
    
    /// Thrown when a `FederatedCreatable` type has a `serviceKey` that does not match any available endpoints in the service.
    case noServiceEndpoint(String)
    
    public var description: String {
        switch self {
        case let .noServiceFound(name): return "No service was found with the name '\(name)'"
        case let .noExistingService(name): return "No service exists with the name '\(name)'"
        case let .noServiceEndpoint(endpoint): return "Service does not have available endpoint for key '\(endpoint)'"
        }
    }
}
