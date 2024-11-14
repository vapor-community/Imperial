import Vapor

public class FacebookAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "FACEBOOK_CLIENT_ID"
    public static var secretEnvKey: String = "FACEBOOK_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String

    public required init() throws {
        guard let clientID = Environment.get(FacebookAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(FacebookAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(FacebookAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(FacebookAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
