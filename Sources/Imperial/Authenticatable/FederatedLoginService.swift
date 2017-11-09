/*
 Usage:
 
 class Service: FederatedLoginService {
     var idEnvKey: String = "service-id"
     var clientID: String
     var secretEnvKey: String = "service-secret"
     var clientSecret: String
     var callbackURL: String
 
     required init(callback: String) throws {
         self.clientID = try Env.get(idEnvKey)
         self.clientSecret = try Env.get(secretEnvKey)
         self.callbackURL = callback
     }
 }
 */

public protocol FederatedLoginService {
    var idEnvKey: String { get }
    var clientID: String { get }
    var secretEnvKey: String { get }
    var clientSecret: String { get }
    var callbackURL: String { get }
    
    init(callback: String)throws
}
