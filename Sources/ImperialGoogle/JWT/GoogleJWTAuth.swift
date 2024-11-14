import Vapor

public class GoogleJWTAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "GOOGLEJWT_CLIENT_EMAIL"
    public static var secretEnvKey: String = "GOOGLEJWT_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        guard let clientID = Environment.get(GoogleJWTAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(GoogleJWTAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(GoogleJWTAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(GoogleJWTAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
