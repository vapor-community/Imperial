public enum ImperialError: Error, CustomStringConvertible {
    case missingEnvVar(String)
    case noServiceFound(String)
    case missingJSONFromResponse(String)
    
    public var description: String {
        switch self {
        case let .missingEnvVar(variable): return "Missing enviroment variable '\(variable)'"
        case let .noServiceFound(name): return "No service was found with the name '\(name)'"
        case let .missingJSONFromResponse(uri): return "Reponse returned from '\(uri)' does not contain JSON"
        }
    }
}
