import Vapor

struct FacebookAuth: FederatedServiceTokens {
    static let idEnvKey: String = "FACEBOOK_CLIENT_ID"
    static let secretEnvKey: String = "FACEBOOK_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
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
