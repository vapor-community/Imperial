import Vapor

public class DeviantArt: FederatedService {
    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter

    @discardableResult
    public required init(
        grouped: [PathComponent],
        router: Router,
        authenticate: String,
        authenticateCallback: ((Request)throws -> (Future<Void>))?,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String)throws -> (Future<ResponseEncodable>)
    ) throws {
        self.router = try DeviantArtRouter(callback: callback, completion: completion)
        self.tokens = self.router.tokens

        self.router.scope = scope
        try self.router.configureRoutes(grouped: grouped, withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: router)

        OAuthService.register(.deviantart)
    }
}
