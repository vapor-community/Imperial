import Vapor

public class GoogleAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "GOOGLE_CLIENT_ID"
    public static var secretEnvKey: String = "GOOGLE_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        guard let clientID = Environment.get(GoogleAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(GoogleAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(GoogleAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(GoogleAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
