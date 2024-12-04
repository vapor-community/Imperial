import Vapor

struct Auth0Auth: FederatedServiceTokens {
    static let domain: String = "AUTH0_DOMAIN"
    static let idEnvKey: String = "AUTH0_CLIENT_ID"
    static let secretEnvKey: String = "AUTH0_CLIENT_SECRET"
    let domain: String
    let clientID: String
    let clientSecret: String

    init() throws {
        guard let domain = Environment.get(Auth0Auth.domain) else {
            throw ImperialError.missingEnvVar(Auth0Auth.domain)
        }
        self.domain = domain

        guard let clientID = Environment.get(Auth0Auth.idEnvKey) else {
            throw ImperialError.missingEnvVar(Auth0Auth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(Auth0Auth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(Auth0Auth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
