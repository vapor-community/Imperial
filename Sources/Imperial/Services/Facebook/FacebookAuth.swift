import Vapor

public class FacebookAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "FACEBOOK_CLIENT_ID"
    public static var secretEnvKey: String = "FACEBOOK_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String

    public required init() throws {
        let idError = ImperialError.missingEnvVar(FacebookAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(FacebookAuth.secretEnvKey)

        self.clientID = try Environment.get(FacebookAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(FacebookAuth.secretEnvKey).value(or: secretError)
    }
}
