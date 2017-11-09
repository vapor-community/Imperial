import Vapor

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
    var callbackURL: String { get }
    var accessTokenURL: String { get }
    var authURL: String { get }
    
    init(callback: String)throws
    
    func authenticate(_ request: Request) -> ResponseRepresentable
    func callback(_ request: Request) -> ResponseRepresentable
}

extension FederatedServiceRouter {
    public func authenticate(_ request: Request) -> ResponseRepresentable {
        return Response(redirect: authURL)
    }
}
