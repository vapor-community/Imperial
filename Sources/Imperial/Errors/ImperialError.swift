/// Represents various errors that can occur when attempting to unwrap an optional value.
public enum ImperialError: Error, CustomStringConvertible {
    
    /// Thrown when no environment varibale is found with a given name.
    /// - warning: This error is never thrown; rather, the application will fatal error.
    case missingEnvVar(String)
    
    /// Thrown when no service is registered with a given name.
    case noServiceFound(String)
    
    /// Thrown when we attempt to create a `FederatedCreatable` model and there is
    /// no JSON in the response from the the request to `dataUri`.
    case missingJSONFromResponse(String)
    
    /// A human readable version of the error thrown.
    public var description: String {
        switch self {
        case let .missingEnvVar(variable): return "Missing enviroment variable '\(variable)'"
        case let .noServiceFound(name): return "No service was found with the name '\(name)'"
        case let .missingJSONFromResponse(uri): return "Reponse returned from '\(uri)' does not contain JSON"
        }
    }
}
