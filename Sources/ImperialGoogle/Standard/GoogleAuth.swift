import Vapor

struct GoogleAuth: FederatedServiceTokens {
    static let idEnvKey: String = "GOOGLE_CLIENT_ID"
    static let secretEnvKey: String = "GOOGLE_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
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
