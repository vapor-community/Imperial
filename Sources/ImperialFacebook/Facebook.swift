@_exported import ImperialCore
import Vapor

public struct Facebook: FederatedService {
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        scope: [String] = [],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        try FacebookRouter(callback: callback, scope: scope, completion: completion)
            .configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }

    public static func generateAppSecretProof(key: String, message: String) -> String {
        let skey = SymmetricKey(data: key.data(using: .utf8)!)
        var hmac = HMAC<SHA256>(key: skey)
        hmac.update(data: message.data(using: .utf8)!)
        return hmac.finalize().hexEncodedString()
    }
}
