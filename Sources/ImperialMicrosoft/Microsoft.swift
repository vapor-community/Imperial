@_exported import ImperialCore
import Vapor

public struct Microsoft: FederatedService {
    public typealias OptionsType = Options
    
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        options: some FederatedServiceOptions,
        completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        try MicrosoftRouter(options: options, completion: completion)
            .configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }
}

extension Microsoft {
    public struct Options: FederatedServiceOptions {
        public let callback: String
        public let scope: [String]
        public let queryItems: [URLQueryItem]
        
        public init(callback: String, scope: [String]) throws {
            self.callback = callback
            self.scope = scope
            self.queryItems = [
                .codeResponseTypeItem,
                .init(clientID: try MicrosoftAuth().clientID),
                .init(redirectURIItem: callback),
                .init(scope: scope.joined(separator: " ")),
                .init(name: "response_mode", value: "query"),
                .init(name: "prompt", value: "consent"),
            ]
        }
    }
}
