/*
 Usage:
 
 class Service: FederatedLoginService {
     var idEnvKey: String = "service-id"
     var clientID: String
     var secretEnvKey: String = "service-secret"
     var clientSecret: String
 
     required init() throws {
         self.clientID = try Env.get(idEnvKey)
         self.clientSecret = try Env.get(secretEnvKey)
     }
 }
 */

public protocol FederatedServiceTokens {
    var idEnvKey: String { get }
    var clientID: String { get }
    var secretEnvKey: String { get }
    var clientSecret: String { get }
    
    init()throws
}
