@_exported import ImperialCore
import Vapor

public class Facebook: FederatedService {
    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter

    @discardableResult
    public required init(
        routes: RoutesBuilder,
        authenticate: String,
        authenticateCallback: ((Request) async throws -> Void)?,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String) async throws -> Response
    ) async throws {
        self.router = try FacebookRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens

        self.router.scope = scope
        try await self.router.configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)

        OAuthService.register(.facebook)
    }
}

