import JSON

internal fileprivate(set) var federatedServices: [String: FederatedService.Type] = [
    :
]

extension FederatedService {
    
    /// Saves the `FederatedService` type
    /// so it can be used as the `model` property in a service.
    public static func registerName() {
        let key = Self.typeName
        federatedServices[key] = self
    }
    
    /// The description of the type as a `String`.
    public static var typeName: String {
        return String(describing: self)
    }
}


extension Service: JSONConvertible {
    
    /// Creates a JSON representation of the `Service`.
    ///
    /// - Returns: The `Service` in JSON format.
    /// - Throws: Errors that occur when setting JSON keys.
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("name", self.name)
        try json.set("token_prefix", self.tokenPrefix)
        try json.set("endpoints", self.endpoints)
        try json.set("model", self.model.typeName)
        return json
    }
    
    /// Creates a `Service` from a JSON object.
    /// The JSON must contain the following keys:
    /// - model: `String`
    /// - name: `String`
    /// - token_prefix: `String`
    /// - endpoints: JSON object (`[String: String]`)
    ///
    /// - Parameter json: The JSON to create the `Service` with.
    /// - Throws:
    ///   - `ServiceError.noExistingService`: No service is registered with the key of the `model` parameter.
    ///   - Errors from getting the values from JSON keys.
    public init(json: JSON) throws {
        let key: String = try json.get("model")
        
        let name: String = try json.get("name")
        let tokenPrefix: String = try json.get("token_prefix")
        let endpoints: [String: String] = try json.get("endpoints")
        let model: FederatedService.Type = try federatedServices[key] ?? ServiceError.noExistingService(key)
        
        self.init(name: name, prefix: tokenPrefix, model: model, endpoints: endpoints)
    }
}
