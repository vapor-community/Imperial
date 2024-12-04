import Vapor

final public class MixcloudAuth: FederatedServiceTokens {
    public static let idEnvKey: String = "MIXCLOUD_CLIENT_ID"
    public static let secretEnvKey: String = "MIXCLOUD_CLIENT_SECRET"
    public let clientID: String
    public let clientSecret: String

    public required init() throws {
        guard let clientID = Environment.get(MixcloudAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(MixcloudAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(MixcloudAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(MixcloudAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
