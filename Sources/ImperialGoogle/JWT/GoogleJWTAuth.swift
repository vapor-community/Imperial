import Vapor

struct GoogleJWTAuth: FederatedServiceTokens {
    static let idEnvKey: String = "GOOGLEJWT_CLIENT_EMAIL"
    static let secretEnvKey: String = "GOOGLEJWT_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
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
