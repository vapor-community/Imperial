@_exported import ImperialCore
import Vapor

public struct Auth0: FederatedService {
    public typealias OptionsType = Options
    
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        options: some FederatedServiceOptions,
        completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        guard let options = options as? Auth0.Options else {
            throw Abort(.internalServerError)
        }
        try Auth0Router(options: options, completion: completion)
            .configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }
}

extension Auth0 {
    public struct Options: FederatedServiceOptions {
        public let callback: String
        public let scope: [String]
        public let queryItems: [URLQueryItem]
        
        public init(callback: String, scope: [String]) throws {
            self.callback = callback
            self.scope = scope
            self.queryItems = [
                .init(name: "openid", value: nil),
                .codeResponseTypeItem,
                .init(clientID: try Auth0Auth().clientID),
                .init(redirectURIItem: callback),
                .init(scope: scope.joined(separator: " ")),
            ]
        }
    }
}
