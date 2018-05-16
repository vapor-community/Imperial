import Vapor

public class GoogleJWTAuth: FederatedServiceTokens {
    public var idEnvKey: String = "GOOGLEJWT_CLIENT_ID"
    public var secretEnvKey: String = "GOOGLEJWT_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(idEnvKey)
        let secretError = ImperialError.missingEnvVar(secretEnvKey)
        
        self.clientID = try Environment.get(idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(secretEnvKey).value(or: secretError)
    }
}
