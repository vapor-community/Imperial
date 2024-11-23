@_exported import ImperialCore
import Vapor

final public class GitHub: FederatedService {
    public let tokens: any FederatedServiceTokens
    public let router: any FederatedServiceRouter

    @discardableResult
    public required init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        scope: [String] = [],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.router = try GitHubRouter(callback: callback, scope: scope, completion: completion)
        self.tokens = self.router.tokens

        try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)

        OAuthService.services[OAuthService.github.name] = .github
    }
}
