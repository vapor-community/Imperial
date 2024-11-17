import Vapor

final public class KeycloakAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "KEYCLOAK_CLIENT_ID"
    public static var secretEnvKey: String = "KEYCLOAK_CLIENT_SECRET"
    public static var accessTokenEnvURL: String = "KEYCLOAK_ACCESS_TOKEN_URL"
    public static var authEnvURL: String = "KEYCLOAK_AUTH_URL"
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
