import Vapor

/// Represents an error that occurs during a session action.
public enum SessionError: Error, CustomStringConvertible, AbortError {
    
    /// Thrown when the user's access token is not found within the session's data
    case usernotAuthenticated
    
    /// Throws Errors when no object is stored in the session with the given key, or decoding fails.
    case keynotFound(String)
    
    public var description: String {
        switch self {
        case .usernotAuthenticated: return "User currently not authenticated"
        case let .keynotFound(key): return "No element has been found with the key '\(key)'"
        }
    }
    
    public var reason: String {
        switch self {
        case .usernotAuthenticated: return description
        case .keynotFound: return description
        }
    }
    
    
    public var status: HTTPStatus {
        switch self {
        case .usernotAuthenticated: return .unauthorized
        case .keynotFound: return .internalServerError
        }
    }
    
}
