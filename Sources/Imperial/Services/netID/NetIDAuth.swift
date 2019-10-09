import Vapor

public class NetIDAuth: FederatedServiceTokens {

    public static var idEnvKey: String = "NETID_CLIENT_ID"
    public static var secretEnvKey: String = "NETID_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(NetIDAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(NetIDAuth.secretEnvKey)
        
        self.clientID = try Environment.get(NetIDAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(NetIDAuth.secretEnvKey).value(or: secretError)
    }

}
