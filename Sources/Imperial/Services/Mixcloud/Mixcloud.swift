import Vapor

public class Mixcloud: FederatedService {
    public static var instance: Mixcloud!

    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter

    @discardableResult
    public required init(
        router: Router,
        authenticate: String,
        authenticateCallback: ((Request) throws -> (Future<Void>))?,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String) throws -> (Future<ResponseEncodable>)
    ) throws {
        self.router = try MixcloudRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens

        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: router)

        OAuthService.register(.mixcloud)
        Mixcloud.instance = self
    }
}
