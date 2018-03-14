import Foundation
import Vapor

extension Request {
    
    func send(method: HTTPMethod = .get, url: String, headers: HTTPHeaders.Literal = [:], body: HTTPBody = HTTPBody(), mediaType: MediaType? = nil)throws -> Future<Response> {
        let client = try self.make(HTTPClient.self)
        var header: HTTPHeaders = HTTPHeaders()
        header.append(headers)
        var request = HTTPRequest(method: method, uri: URI(url), headers: header, body: body)
        request.mediaType = mediaType ?? .urlEncodedForm
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
    func create<T: FederatedCreatable>(_ model: T.Type, with service: OAuthService)throws -> Future<T> {
        let uri = try service[model.serviceKey] ?? ServiceError.noServiceEndpoint(model.serviceKey)
        
        let token = try service.tokenPrefix + self.getAccessToken()
        
        return try self.send(url: uri, headers: [.authorization: token]).flatMap(to: T.self, { (response) -> Future<T> in
            return try model.create(from: response)
        }).map(to: T.self, { (instance) -> T in
            let session = try self.session()
            try session.set("imperial-\(model)", to: instance)
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
        let session = try self.session()
        return try session.get("imperial-\(model)", as: T.self)
    }
}
