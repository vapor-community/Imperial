import JSON

/// Defines a type that can be created with federated login data.
/// This type is used as a parameter in the `request.fetch` method
public protocol FederatedCreatable {
    
    /// The prefix for the access token when it is used in a authorization header.
    static var tokenPrefix: String { get }
    
    /// The URI to make a request to, to get the JSON to create an instance of the model.
    static var dataUri: String { get }
    
    /// Creates an instance of the model with JSON.
    ///
    /// - Parameter json: The JSON in the response from the `dataUri`.
    /// - Returns: An instence of the type that conforms to this protocol.
    /// - Throws: Any errors that could be thrown inside the method.
    static func create(with json: JSON)throws -> Self
}

extension FederatedCreatable {
    public var tokenPrefix: String {
        return "Bearer "
    }
}
