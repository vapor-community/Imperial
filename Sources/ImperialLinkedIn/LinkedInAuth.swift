import Vapor

struct LinkedInAuth: FederatedServiceTokens {
    static let idEnvKey: String = "LINKEDIN_CLIENT_ID"
    static let secretEnvKey: String = "LINKEDIN_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
        guard
            let clientID = Environment.get(Self.idEnvKey)
        else {
            throw ImperialError.missingEnvVar(Self.idEnvKey)
        }
        self.clientID = clientID

        guard
            let clientSecret = Environment.get(Self.secretEnvKey)
        else {
            throw ImperialError.missingEnvVar(Self.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
