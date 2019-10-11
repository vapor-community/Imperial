import Vapor

public final class NetID: FederatedService {

    public var tokens: FederatedServiceTokens
    public var router: FederatedServiceRouter
    
    @discardableResult
    public convenience init(
        router: Router,
        authenticate: String,
        authenticateCallback: ((Request) throws -> (Future<Void>))?,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String) throws -> (Future<ResponseEncodable>)
    ) throws {
        let config = NetIDConfig(
            authenticate: authenticate,
            authenticateCallback: authenticateCallback,
            callback: callback,
            scope: scope,
            claims: [],
            state: nil,
            stateVerify: nil
        )
        try self.init(router: router, config: config, completion: completion)
    }

    @discardableResult
    public init(
        router: Router,
        config: NetIDConfig,
        completion: @escaping (Request, String) throws -> (Future<ResponseEncodable>)
    ) throws {
        let netIDRouter = try NetIDRouter(callback: config.callback, completion: completion)
        netIDRouter.claims = config.claims
        netIDRouter.state = config.state
        netIDRouter.stateVerify = config.stateVerify
        self.router = netIDRouter
        self.tokens = self.router.tokens
        
        self.router.scope = config.scope
        try self.router.configureRoutes(
            withAuthURL: config.authenticate,
            authenticateCallback: config.authenticateCallback,
            on: router
        )
        
        OAuthService.register(.netid)
    }

}
