import Vapor

struct MicrosoftAuth: FederatedServiceTokens {
    static let idEnvKey: String = "MICROSOFT_CLIENT_ID"
    static let secretEnvKey: String = "MICROSOFT_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
        guard let clientID = Environment.get(MicrosoftAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(MicrosoftAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(MicrosoftAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(MicrosoftAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
