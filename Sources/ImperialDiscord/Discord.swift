@_exported import ImperialCore
import Vapor

public class Discord: FederatedService {
    public var tokens: any FederatedServiceTokens
    public var router: any FederatedServiceRouter

    @discardableResult
    public required init(
        routes: any RoutesBuilder,
        authenticate: String,
        authenticateCallback: ((Request) async throws -> Void)?,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String) async throws -> any AsyncResponseEncodable
    ) throws {
        self.router = try DiscordRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens

        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)

        OAuthService.register(.discord)
    }
}
