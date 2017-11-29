import Vapor

extension Request {
    
    /// Creates an instance of a `FederatedCreatable` type from JSON fetched from an OAuth provider's API.
    ///
    /// - Parameters:
    ///   - model: The type to create an instance of.
    ///   - service: The service to get the data from.
    /// - Returns: An instance of the type passed in.
    /// - Throws: Errors from trying to get the access token from the request.
    func create<T: FederatedCreatable>(_ model: T.Type, with service: Service)throws -> T {
        let uri = try service[model.serviceKey] ?? ImperialError.noServiceEndpoint(model.serviceKey)
        
        let token = try service.tokenPrefix + self.getAccessToken()
        let noJson = ImperialError.missingJSONFromResponse(uri)
        
        let response = try drop.client.get(uri, [.authorization: token])
        let new = try model.create(with: response.json ?? noJson, for: service)
        
        self.storage["imperial-\(model)"] = new
        return new
    }
    
    /// Gets an instance of a `FederatedCreatable` type that is stored in the request.
    ///
    /// - Parameters:
    ///   - model: A type that conforms to `FederatedCreatable`.
    /// - Returns: An instance of the type passed in that has been stored in the request.
    /// - Throws:
    ///   - `ImperialError.typeNotInitialized`: If there is no value stored in the request for the type passed in.
    func fetch<T: FederatedCreatable>(_ model: T.Type)throws -> T {
        if let new = self.storage["imperial-\(model)"] {
            return new as! T
        }
        throw ImperialError.typeNotInitialized("\(model)")
    }
}
