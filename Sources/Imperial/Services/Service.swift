/*
 Usage:
 
 class Service: FederatedService {
     let auth: FederatedLoginService
     let router: FederatedServiceRouter
 
     init(authenticate: String, callback: String, completion: @escaping (String) -> ())throws {
         self.router = try Router(callback: callback)
         self.auth = router.service
 
         drop.get(authenicate, router.authenticate)
         drop.get(callback, router.callback)
     }
 }
 */

public protocol FederatedService {
    var auth: FederatedLoginService { get }
    var router: FederatedServiceRouter { get }
    
    init(authenticate: String, callback: String, completion: @escaping (String) -> ())throws
}
