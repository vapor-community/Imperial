import Vapor

public class GoogleJWTAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "GOOGLEJWT_CLIENT_EMAIL"
    public static var secretEnvKey: String = "GOOGLEJWT_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(GoogleJWTAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(GoogleJWTAuth.secretEnvKey)
        
        self.clientID = try Environment.get(GoogleJWTAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(GoogleJWTAuth.secretEnvKey).value(or: secretError)
    }
}
