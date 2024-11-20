import Vapor

final public class KeycloakAuth: FederatedServiceTokens {
    public static let idEnvKey: String = "KEYCLOAK_CLIENT_ID"
    public static let secretEnvKey: String = "KEYCLOAK_CLIENT_SECRET"
    public static let accessTokenEnvURL: String = "KEYCLOAK_ACCESS_TOKEN_URL"
    public static let authEnvURL: String = "KEYCLOAK_AUTH_URL"
    public let clientID: String
    public let clientSecret: String
    public let accessTokenURL: String
    public let authURL: String
    
    public required init() throws {
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
