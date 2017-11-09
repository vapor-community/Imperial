/*
 Usage:
 
 class Router: FederatedServiceRouter {
    var service: FederatedLoginService
    var callbackURL: String
    var authURL: String {
        return "https://service.com/login/oauth/authorize?scope=user:email&client_id=" +
                service.clientID
    }
 
     init(callback: String)throws {
         self.service = try Service()
         self.callbackURL = callback
     }
  }
 */

protocol FederatedServiceRouter {
    var service: FederatedLoginService { get }
    var callbackURL: String { get }
    var authURL: String { get }
    
    init(callback: String)throws
}
