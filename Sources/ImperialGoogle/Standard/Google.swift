@_exported import ImperialCore
import Vapor

public struct Google: FederatedService {
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        queryItems: [URLQueryItem] = [],
        completion: @escaping @Sendable (Request, String, ByteBuffer?) async throws -> some AsyncResponseEncodable
    ) throws {
        try GoogleRouter(callback: callback, queryItems: queryItems, completion: completion)
            .configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }
}

extension Google {
    /// Convert completion handler ByteBuffer into a dicitonary
    /// - Parameters:
    ///  - from: ByteBuffer returned in completion handler.
    public static func dictionary(_ buffer: ByteBuffer?) -> [String: Any]? {
        guard let string = string(from: buffer),
              let data = string.data(using: .utf8),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return nil
        }
        return dictionary
    }
}
