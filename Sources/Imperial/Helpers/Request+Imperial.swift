import Foundation
import Vapor

extension Request {
    
    /// Creates an instance of a `FederatedCreatable` type from JSON fetched from an OAuth provider's API.
    ///
    /// - Parameters:
    ///   - model: The type to create an instance of.
    ///   - service: The service to get the data from.
    /// - Returns: An instance of the type passed in.
    /// - Throws: Errors from trying to get the access token from the request.
    func create<Model: FederatedCreatable>(_ model: Model.Type, with service: OAuthService)throws -> Future<Model> {
        let uri = try service[model.serviceKey] ?? ServiceError.noServiceEndpoint(model.serviceKey)
        
        let token = try service.tokenPrefix + self.accessToken()
        
        return try self.make(Client.self).get(uri, headers: [.authorization: token]).flatMap(to: Model.self, { (response) -> Future<Model> in
            return try model.create(from: response)
        }).map(to: Model.self, { (instance) -> Model in
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
