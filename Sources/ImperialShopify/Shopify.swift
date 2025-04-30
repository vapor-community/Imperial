@_exported import ImperialCore
import Vapor

public struct Shopify: FederatedService {
    public static var scopeSeparator: String { "," }
    
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        queryItems: [URLQueryItem] = [],
        completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
    ) throws {
        try ShopifyRouter(callback: callback, queryItems: queryItems, completion: completion)
            .configureRoutes(
                withAuthURL: authenticate,
                authenticateCallback: authenticateCallback,
                on: routes
            )
    }
}
