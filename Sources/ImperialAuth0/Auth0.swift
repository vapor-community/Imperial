@_exported import ImperialCore
import Vapor

public struct Auth0: FederatedService {
    public static func scopeQueryItem(_ scope: [String]) -> URLQueryItem {
        var scope = scope
        if !scope.contains("openid") {
            scope += ["openid"]
        }
        return .init(name: "scope", value: scope.joined(separator: Self.scopeSeparator))
    }
    
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        queryItems: [URLQueryItem] = [],
        completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
    ) throws {
        try Auth0Router(callback: callback, queryItems: queryItems, completion: completion)
            .configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }
}
