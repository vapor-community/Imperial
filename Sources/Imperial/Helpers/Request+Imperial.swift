import Vapor

extension Request {
    
    func get(url: String, headers: HTTPHeaders.Literal = [:], body: HTTPBody = HTTPBody(), mediaType: MediaType? = nil)throws -> Future<Response> {
        let client = try self.make(HTTPClient.self)
        var header: HTTPHeaders = HTTPHeaders()
        header.append(headers)
        var request = HTTPRequest(method: .get, uri: URI(url), headers: header, body: body)
        request.mediaType = .urlEncodedForm
        return client.send(request).map(to: Response.self, { (res) in
            return Response(http: res, using: self.superContainer)
        })
    }
    
    /// Creates an instance of a `FederatedCreatable` type from JSON fetched from an OAuth provider's API.
    ///
    /// - Parameters:
    ///   - model: The type to create an instance of.
    ///   - service: The service to get the data from.
    /// - Returns: An instance of the type passed in.
    /// - Throws: Errors from trying to get the access token from the request.
    func create<T: FederatedCreatable>(_ model: T.Type, with service: ImperialService)throws -> Future<T> {
        let uri = try service[model.serviceKey] ?? ServiceError.noServiceEndpoint(model.serviceKey)
        
        let token = try service.tokenPrefix + self.getAccessToken()
        
        return try self.get(url: uri, headers: [.authorization: token]).flatMap(to: T.self, { (response) -> Future<T> in
            return try model.create(from: response)
        }).map(to: T.self, { (instance) -> T in
            let session = try self.session()
            session.data.storage["imperial-\(model)"] = instance
            return instance
        })
    }
    
    /// Gets an instance of a `FederatedCreatable` type that is stored in the request.
    ///
    /// - Parameters:
    ///   - model: A type that conforms to `FederatedCreatable`.
    /// - Returns: An instance of the type passed in that has been stored in the request.
    /// - Throws:
    ///   - `ImperialError.typeNotInitialized`: If there is no value stored in the request for the type passed in.
    func fetch<T: FederatedCreatable>(_ model: T.Type)throws -> T {
        let cache = try self.privateContainer.make(ServiceStorage.self, for: Request.self)
        if let new = cache["imperial-\(model)"] {
            return new as! T
        }
        throw ImperialError.typeNotInitialized("\(model)")
    }
}
