import Foundation
import Vapor

extension Request {
    /// Calls a specified endpoint and decodes the response body as a `Codable` type.
    ///
    /// The first time this method is called, the endpoint as actually access and the model is decoded,
    /// and then the model is cached to the current Vapor session.
    /// On subsequent calls, the cached value is returned instead.
    /// You can clear the current cached value so the model is re-fetched by calling `request.uncache(_:)`
    /// or `request.ucacheAll(from:)`.
    ///
    /// - Parameters:
    ///   - model: The type to decode the response body to.
    ///   - endpointKey: The key-path to the service endpoint to access.
    ///
    /// - Returns: The decoded or cached model.
    func get<Model, Service>(
        _ model: Model.Type,
        from endpointKey: KeyPath<Service, Endpoint>
    ) -> EventLoopFuture<Model>
        where Model: Codable, Service: OAuthServiceProtocol
    {
        let sessionKey = self.sessionKey(for: endpointKey)

        do {
            if let cached = try self.session.get(sessionKey, as: Model?.self) {
                return self.eventLoop.future(cached)
            }
        } catch let error {
            return self.eventLoop.future(error: error)
        }

        return self.eventLoop.tryFuture {
            return try Service.tokenPrefix + self.accessToken()
        }.flatMap { token -> EventLoopFuture<ClientResponse> in
            let endpoint = Service()[keyPath: endpointKey]
            return self.client.get(endpoint.uri, headers: ["Authorization": token])
        }.flatMapThrowing { response in
            let model = try response.content.decode(Model.self)
            try self.session.set(sessionKey, to: model)
            return model
        }
    }

    /// Remove the cached value for the specified endpoint, forcing the next `request.get(_:from:)` call to access the endpoint.
    ///
    /// - Parameter endpointKey: The key-path to the endpoint from which to uncache its cached value.
    public func uncache<Service>(_ endpointKey: KeyPath<Service, Endpoint>) where Service: OAuthServiceProtocol {
        self.session.data[self.sessionKey(for: endpointKey)] = nil
    }

    /// Remove the cached values for all the endpoints defined by an OAuth service.
    ///
    /// - Parameter service: The service from which to uncache all the cached values for its endpoints.
    public func uncacheAll<Service>(from service: Service.Type) where Service: OAuthServiceProtocol {
        service.init().endpoints.forEach { name, url in
            let key = "imperial.\(Service.name).\(url.absoluteString)"
            self.session.data[key] = nil
        }
    }

    private func sessionKey<Service>(for endpointKey: KeyPath<Service, Endpoint>) -> String
        where Service: OAuthServiceProtocol
    {
        return "imperial.\(Service.name).\(Service()[keyPath: endpointKey].url?.absoluteString ?? "<null>")"
    }
}

extension Request {

    /// A type used to represent an OAuth service on the request, so you can access the service's APIs.
    ///
    /// This type should be used in extensions of `Request`, in the service specfic targets of Imperial.
    /// The service will define an extension property with its name, such as `request.github` and then
    /// define further properties in an extenion of that property to access that service's API endpoints.
    public struct OAuthSession<Service> where Service: OAuthServiceProtocol {
        let request: Request

        /// Create an instance for accessing an OAuth service's API endpoints.
        ///
        /// - Note: This initializer should only be used in service specific Imperial targets, in `Request` type extensions.
        public init(request: Request) {
            self.request = request
        }

        /// Decode a `Codable` type from the response body of one of the service's API endpoints.
        ///
        /// - Parameters:
        ///   - endpoint: The endpoint to get the model data from.
        ///   - type: The `Codable` type to decode the data to.
        ///
        /// - Returns: The decoded response body.
        public func get<M>(endpoint: KeyPath<Service, Endpoint>, as type: M.Type = M.self) -> EventLoopFuture<M>
            where M: Codable
        {
            return self.request.get(type, from: endpoint)
        }
    }
}
