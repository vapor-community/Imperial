import Vapor
import Foundation

public class DropboxRouter: FederatedServiceRouter {
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = []
    public let callbackURL: String
    public let accessTokenURL: String = "https://api.dropboxapi.com/oauth2/token"
    
    public var callbackHeaders: HTTPHeaders {
        ["Content-Type": HTTPMediaType.urlEncodedForm.description,
         "Authorization": "Basic \(encodedClientCredentials)"]
    }
    
    private var encodedClientCredentials: String {
        Data("\(tokens.clientID):\(tokens.clientSecret)".utf8).base64EncodedString()
    }
    
    public let service: OAuthService = .dropbox
    
    public required init(callback: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        self.tokens = try DropboxAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    public func authURL(_ request: Request) throws -> String {
        return "https://www.dropbox.com/oauth2/authorize?" +
            "client_id=\(self.tokens.clientID)&" +
            "redirect_uri=\(self.callbackURL)&" +
            "response_type=code"
    }
    
    public func callbackBody(with code: String) -> ResponseEncodable {
        DropboxCallbackBody(code: code,
                            redirectURI: callbackURL)
    }
    
}
