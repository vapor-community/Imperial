import Vapor
import URI

/*
 Usage:
 
 class Router: FederatedServiceRouter {
     var service: FederatedLoginService
     var callbackURL: String
     var accessTokenURL: String = "https://service.com/login/oauth/access_token"
     var authURL: String {
         return "https://service.com/login/oauth/authorize?scope=user:email&client_id=" +
                 service.clientID
     }
 
     init(callback: String)throws {
         self.service = try Service()
         self.callbackURL = callback
     }
 
     func callback(_ request: Request) -> ResponseRepresentable {
         // Get the `code` value from the request and use it to get the `access_token`.
         // See here for a Ruby implimentation: https://developer.github.com/v3/guides/basics-of-authentication/#providing-a-callback
     }
 }
 */

public protocol FederatedServiceRouter {
    var service: FederatedLoginService { get }
    var callbackCompletion: (String) -> (ResponseRepresentable) { get }
    var scope: [String: String] { get set }
    var callbackURL: String { get }
    var accessTokenURL: String { get }
    var authURL: String { get }
    
    init(callback: String, completion: @escaping (String) -> (ResponseRepresentable))throws
    
    func configureRoutes(withAuthURL authURL: String)throws
    
    func authenticate(_ request: Request)throws -> ResponseRepresentable
    func callback(_ request: Request)throws -> ResponseRepresentable
}

extension FederatedServiceRouter {
    public func authenticate(_ request: Request)throws -> ResponseRepresentable {
        return Response(redirect: authURL)
    }
    
    public func configureRoutes(withAuthURL authURL: String) throws {
        var callbackPath = URIParser().parse(bytes: callbackURL.bytes).path
        callbackPath = callbackPath != "/" ? callbackPath : callbackURL
        
        drop.get(callbackPath, handler: callback)
        drop.get(authURL, handler: authenticate)
    }
}
