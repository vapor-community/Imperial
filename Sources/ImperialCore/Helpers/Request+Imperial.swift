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
    func create<Model: FederatedCreatable>(_ model: Model.Type, with service: OAuthService, on req: Request) async throws -> Model {
        guard let url = service[model.serviceKey] else {
            throw ServiceError.noServiceEndpoint(model.serviceKey)
        }

        let token =
            try service.tokenPrefix
            + req
            .accessToken()

        let response = try await req.client.get(URI(string: url), headers: ["Authorization": token])
        let instance = try await model.init(from: response)
        try self.session.set("imperial-\(model)", to: instance)
        return instance
    }

    /// Gets an instance of a `FederatedCreatable` type that is stored in the request.
    ///
    /// - Parameters:
    ///   - model: A type that conforms to `FederatedCreatable`.
    /// - Returns: An instance of the type passed in that has been stored in the request.
    func fetch<T: FederatedCreatable>(_ model: T.Type) throws -> T {
        return try session.get("imperial-\(model)", as: T.self)
    }
}
