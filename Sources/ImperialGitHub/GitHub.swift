@_exported import ImperialCore
import Vapor

public class GitHub: FederatedService {
    public var tokens: any FederatedServiceTokens
    public var router: any FederatedServiceRouter

    @discardableResult
    public required init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        callback: String,
        scope: [String] = [],
        completion: @escaping @Sendable (Request, String) async throws -> some AsyncResponseEncodable
    ) throws {
        self.router = try GitHubRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens

        self.router.scope = scope
        try self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)

        OAuthService.services[OAuthService.github.name] = .github
    }
}

