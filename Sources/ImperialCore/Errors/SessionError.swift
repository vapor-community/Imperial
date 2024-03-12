import Vapor

/// Represents an error that occurs during a session action.
public enum SessionError: Error, CustomStringConvertible, AbortError {
    
    /// Thrown when the user's access token is not found within the session's data
    case usernotAuthenticated
    
    public var description: String {
        switch self {
        case .usernotAuthenticated: return "User currently not authenticated"
        }
    }
    
    public var reason: String {
        switch self {
        case .usernotAuthenticated: return description
        }
    }
    
    
    public var status: HTTPStatus {
        switch self {
        case .usernotAuthenticated: return .unauthorized
        }
    }
    
}
