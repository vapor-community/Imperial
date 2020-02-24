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
    func create<Model: FederatedCreatable>(_ model: Model.Type, with service: OAuthService, on req: Request) throws -> EventLoopFuture<Model> {
        let url = try service[model.serviceKey].value(or: ServiceError.noServiceEndpoint(model.serviceKey))
        
        let token = try service.tokenPrefix + req
            .accessToken()
        
        return req.client.get(URI(string: url), headers: ["Authorization": token]).flatMap { response in
            return try! model.create(from: response).flatMapThrowing { instance in
                try self.session.set("imperial-\(model)", to: instance)
                return instance
            }
        }
    }
	
    /// Gets an instance of a `FederatedCreatable` type that is stored in the request.
    ///
    /// - Parameters:
    ///   - model: A type that conforms to `FederatedCreatable`.
    /// - Returns: An instance of the type passed in that has been stored in the request.
    /// - Throws:
    ///   - `ImperialError.typeNotInitialized`: If there is no value stored in the request for the type passed in.
    func fetch<T: FederatedCreatable>(_ model: T.Type) throws -> T {
        return try session.get("imperial-\(model)", as: T.self)
    }
}
