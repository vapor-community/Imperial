@_exported import ImperialCore
import Vapor

/// Documentation for Google OAuth for Server-Side Web Apps found at:
/// https://developers.google.com/identity/protocols/oauth2/web-server

public struct Google: FederatedService {
    public typealias OptionsType = Options
    
    @discardableResult
    public init(
        routes: some RoutesBuilder,
        authenticate: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        options: some FederatedServiceOptions,
        completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws {
        try GoogleRouter(options: options, completion: completion)
            .configureRoutes(withAuthURL: authenticate, authenticateCallback: authenticateCallback, on: routes)
    }
}

extension Google {
    public struct Options: FederatedServiceOptions {
        public enum AccessType: String {
            case offline
            case online
        }
        
        public enum Prompt: String {
            case none
            case consent
            case selectAccount = "select_account"
        }
        
        public enum Scope: String {
            case email
            case profile
        }

        public let callback: String
        public let scope: [String]
        public let queryItems: [URLQueryItem]
        
        private static func baseQueryItems(callback: String, scope: [String]) throws -> [URLQueryItem] {
            [
                .codeResponseTypeItem,
                .init(clientID: try GoogleAuth().clientID),
                .init(redirectURIItem: callback),
                .init(scope: scope.joined(separator: " ")),
            ]
        }
        
        public init(
            callback: String,
            scope: [String]
        ) throws {
            self.callback = callback
            self.scope = scope
            self.queryItems  = try Self.baseQueryItems(callback: callback, scope: scope)
        }
        
        public init(
            callback: String,
            scope: [String],
            accessType: AccessType = .online,
            includeGrantedScopes: Bool = false,
            enableGranularConsent: Bool = true,
            loginHint: String? = nil,
            prompts: Set<Prompt>? = nil
        ) throws {
            self.callback = callback
            self.scope = scope
            var queryItems = try Self.baseQueryItems(callback: callback, scope: scope)
            if accessType == .offline {
                // default is online, only include if offline
                queryItems.append(.init(name: "access_type", value: "offline"))
            }
            if includeGrantedScopes {
                // default is false, only include if true
                queryItems.append(.init(name: "include_granted_scopes", value: "true"))
            }
            if !enableGranularConsent {
                // default is true, only include if false
                queryItems.append(.init(name: "enable_granular_consent", value: "false"))
            }
            if let loginHint = loginHint {
                queryItems.append(.init(name: "login_hint", value: loginHint))
            }
            if let prompts = prompts {
                queryItems.append(.init(name: "prompt", value: prompts.map{ $0.rawValue }.joined(separator: " ")))
            }
            self.queryItems = queryItems
        }
    }
}

extension Google {
    /// Convert completion handler ByteBuffer into a dicitonary
    /// - Parameters:
    ///  - from: ByteBuffer returned in completion handler.
    public static func dictionary(_ body: ResponseBody?) -> [String: Any]? {
        guard let body = body,
              let data = body.data(using: .utf8),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return nil
        }
        return dictionary
    }
}
