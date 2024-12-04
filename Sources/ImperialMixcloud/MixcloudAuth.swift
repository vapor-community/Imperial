import Vapor

struct MixcloudAuth: FederatedServiceTokens {
    static let idEnvKey: String = "MIXCLOUD_CLIENT_ID"
    static let secretEnvKey: String = "MIXCLOUD_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
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
