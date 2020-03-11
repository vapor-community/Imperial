import Vapor

public class MixcloudAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "MIXCLOUD_CLIENT_ID"
    public static var secretEnvKey: String = "MIXCLOUD_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String

    public required init() throws {
        let idError = ImperialError.missingEnvVar(MixcloudAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(MixcloudAuth.secretEnvKey)

        self.clientID = try Environment.get(MixcloudAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(MixcloudAuth.secretEnvKey).value(or: secretError)
    }
}
