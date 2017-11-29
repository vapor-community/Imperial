import Vapor

extension Request {
    
    /// Creates an instance of a model the conforms to `FederatedCreatable` and stores it in the request.
    /// The model instance is cached in the request's `storage` and returned in later calles for the same type.
    ///
    /// - Parameters:
    ///   - model: A type that conforms to `FederatedCreatable`.
    ///   - fromCache: The model's instance should be fetched from the request's `storage` if one is found. This defaults to `true`.
    /// - Returns: An instance of the type passed in created with JSON from the types `dataUri`.
    /// - Throws:
    ///   - `ImperialError.missingJSONFromResponse`: If the response from `dataUri` does not contain JSON
    ///   - Errors that occur while fetching the access token from the current session.
    ///   - Errors that occur in the request to the `dataUri`.
    ///   - Errors that are thrown from `model.create`
    func fetch<T: FederatedCreatable>(_ model: T.Type, fromCache cache: Bool = true)throws -> T {
        if cache, let new = self.storage["imperial-\(model)"] {
            return new as! T
        }
        
        let token = try model.tokenPrefix + self.getAccessToken()
        let uri = model.dataUri
        let noJson = ImperialError.missingJSONFromResponse(uri)
        
        let response = try drop.client.get(uri, [.authorization: token])
        let new = try model.create(with: response.json ?? noJson)
        
        self.storage["imperial-\(model)"] = new
        return new
    }
}
