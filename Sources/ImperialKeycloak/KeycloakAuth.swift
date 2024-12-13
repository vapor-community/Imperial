import Vapor

struct KeycloakAuth: FederatedServiceTokens {
    static let idEnvKey: String = "KEYCLOAK_CLIENT_ID"
    static let secretEnvKey: String = "KEYCLOAK_CLIENT_SECRET"
    static let accessTokenEnvURL: String = "KEYCLOAK_ACCESS_TOKEN_URL"
    static let authEnvURL: String = "KEYCLOAK_AUTH_URL"
    let clientID: String
    let clientSecret: String
    let accessTokenURL: String
    let authURL: String

    init() throws {
        guard let clientID = Environment.get(KeycloakAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(KeycloakAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(KeycloakAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(KeycloakAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret

        guard let accessTokenURL = Environment.get(KeycloakAuth.accessTokenEnvURL) else {
            throw ImperialError.missingEnvVar(KeycloakAuth.accessTokenEnvURL)
        }
        self.accessTokenURL = accessTokenURL

        guard let authURL = Environment.get(KeycloakAuth.authEnvURL) else {
            throw ImperialError.missingEnvVar(KeycloakAuth.authEnvURL)
        }
        self.authURL = authURL
    }
}
