/// Defines a type that can be created with federated login data.
/// This type is used as a parameter in the `request.fetch` method
public protocol FederatedCreatable {
    
    /// The key for the service's endpoint to use when `request.create` is called with the implimenting type.
    static var serviceKey: String { get }
    
    /// Creates an instance of the model with JSON.
    ///
    /// - Parameter json: The JSON in the response from the `dataUri`.
    /// - Returns: An instence of the type that conforms to this protocol.
    /// - Throws: Any errors that could be thrown inside the method.
    static func create(with json: JSON, `for` service: ImperialService)throws -> Self
}
