/// Represents various errors that can occur when attempting to unwrap an optional value.
public enum ImperialError: Error, CustomStringConvertible {
    
    /// Thrown when no environment varibale is found with a given name.
    /// - warning: This error is never thrown; rather, the application will fatal error.
    case missingEnvVar(String)
    
    /// Thrown when no service is registered with a given name.
    case noServiceFound(String)
    
    /// Thrown when no `FederatedSewrvice` type is found whgen creating a `Service` from JSON.
    case noExistingService(String)
    
    /// Thrown when we attempt to create a `FederatedCreatable` model and there is
    /// no JSON in the response from the the request to `dataUri`.
    case missingJSONFromResponse(String)
    
    /// Thrown when a `FederatedCreatable` type has a `serviceKey` that does not match any available endpoints in the service.
    case noServiceEndpoint(String)
    
    /// Thrown when `request.fetch` is called with a type that has not been run through `request.create`.
    case typeNotInitialized(String)
    
    /// A human readable version of the error thrown.
    public var description: String {
        switch self {
        case let .missingEnvVar(variable): return "Missing enviroment variable '\(variable)'"
        case let .noServiceFound(name): return "No service was found with the name '\(name)'"
        case let .noExistingService(name): return "No service exists with the name '\(name)'"
        case let .missingJSONFromResponse(uri): return "Reponse returned from '\(uri)' does not contain JSON"
        case let .noServiceEndpoint(endpoint): return "Service does not have available endpoint for key '\(endpoint)'"
        case let .typeNotInitialized(type): return "No instence of type '\(type)' has been created"
        }
    }
}
