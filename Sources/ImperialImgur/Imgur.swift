@_exported import ImperialCore
import Vapor

public struct Imgur: FederatedService {
    public typealias OptionsType = Options
    
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        options: some FederatedServiceOptions,
        completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        try ImgurRouter(options: options, completion: completion)
            .configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }
}

extension Imgur {
    public struct Options: FederatedServiceOptions {
        public let callback: String
        public let scope: [String]
        public let queryItems: [URLQueryItem]
        
        public init(callback: String, scope: [String]) throws {
            self.callback = callback
            self.scope = scope
            self.queryItems = [
                .codeResponseTypeItem,
                .init(clientID: try ImgurAuth().clientID),
                .init(scope: scope.joined(separator: " "))
            ]
        }
    }
}
