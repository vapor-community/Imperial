@_exported import ImperialCore
import Vapor

public struct Shopify: FederatedService {
    public typealias OptionsType = Options
    
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        options: some FederatedServiceOptions,
        completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        try ShopifyRouter(options: options, completion: completion)
            .configureRoutes(
                withAuthURL: authenticate,
                authenticateCallback: authenticateCallback,
                on: routes
            )
    }
}

extension Shopify {
    public struct Options: FederatedServiceOptions {
        public let callback: String
        public let scope: [String]
        public let queryItems: [URLQueryItem]
        
        public init(callback: String, scope: [String]) throws {
            self.callback = callback
            self.scope = scope
            self.queryItems = [
                .init(clientID: try ShopifyAuth().clientID),
                .init(redirectURIItem: callback),
                .init(scope: scope.joined(separator: ",")),
            ]
        }
    }
}
