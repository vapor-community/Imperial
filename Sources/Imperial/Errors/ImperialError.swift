public enum ImperialError: Error, CustomStringConvertible {
    case missingEnvVar(String)
    
    public var description: String {
        switch self {
        case let .missingEnvVar(variable): return "Missing enviroment variable '\(variable)'"
        }
    }
}
