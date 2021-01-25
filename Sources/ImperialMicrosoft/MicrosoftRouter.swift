import Vapor
import Foundation

public class MicrosoftRouter: FederatedServiceRouter {
        
    public static var tenantIDEnvKey: String = "MICROSOFT_TENANT_ID"

    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String)throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public var tenantID: String { Environment.get(MicrosoftRouter.tenantIDEnvKey) ?? "common" }
    public var accessTokenURL: String { "https://login.microsoftonline.com/\(self.tenantID)/oauth2/v2.0/token" }
    public let service: OAuthService = .microsoft
    public let errorKey = "error_description"
    
    public required init(
        callback: String,
        completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    ) throws {
        self.tokens = try MicrosoftAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public func authURL(_ request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.login.microsoftonline.com"
        components.path = "/\(tenantID)/oauth2/v2.0/authorize"
        components.queryItems = [
            clientIDItem,
            redirectURIItem,
            scopeItem,
            codeResponseTypeItem,
            .init(name: "response_mode", value: "query"),
            .init(name: "prompt", value: "consent"),
        ]
        
        guard let url = components.url else {
            throw Abort(.internalServerError)
        }
        
        return url.absoluteString
    }
    
    public func callbackBody(with code: String) -> ResponseEncodable {
        MicrosoftCallbackBody(code: code,
                              clientId: tokens.clientID,
                              clientSecret: tokens.clientSecret,
                              redirectURI: callbackURL,
                              scope: scope.joined(separator: " "))
    }
    
}
