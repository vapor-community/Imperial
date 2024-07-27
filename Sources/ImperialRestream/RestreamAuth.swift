import Vapor

public class RestreamAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "RESTREAM_CLIENT_ID"
    public static var secretEnvKey: String = "RESTREAM_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String

    public required init() throws {
        let idError = ImperialError.missingEnvVar(RestreamAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(RestreamAuth.secretEnvKey)

        self.clientID = try Environment.get(RestreamAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(RestreamAuth.secretEnvKey).value(or: secretError)
    }
}
