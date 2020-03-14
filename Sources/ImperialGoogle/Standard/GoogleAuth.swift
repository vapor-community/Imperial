import Vapor

public class GoogleAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "GOOGLE_CLIENT_ID"
    public static var secretEnvKey: String = "GOOGLE_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(GoogleAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(GoogleAuth.secretEnvKey)
        
        self.clientID = try Environment.get(GoogleAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(GoogleAuth.secretEnvKey).value(or: secretError)
    }
}
