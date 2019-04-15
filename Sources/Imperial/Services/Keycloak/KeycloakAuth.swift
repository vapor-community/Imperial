import Vapor

public class KeycloakAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "KEYCLOAK_CLIENT_ID"
    public static var secretEnvKey: String = "KEYCLOAK_CLIENT_SECRET"
	public static var accessTokenEnvURL: String = "KEYCLOAK_ACCESS_TOKEN_URL"
	public static var authEnvURL: String = "KEYCLOAK_AUTH_URL"
    public var clientID: String
    public var clientSecret: String
	public var accessTokenURL: String
	public var authURL: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(KeycloakAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(KeycloakAuth.secretEnvKey)
		let tokenError = ImperialError.missingEnvVar(KeycloakAuth.accessTokenEnvURL)
		let authError = ImperialError.missingEnvVar(KeycloakAuth.authEnvURL)
        
        self.clientID = try Environment.get(KeycloakAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(KeycloakAuth.secretEnvKey).value(or: secretError)
		self.accessTokenURL = try Environment.get(KeycloakAuth.accessTokenEnvURL).value(or: tokenError)
		self.authURL = try Environment.get(KeycloakAuth.authEnvURL).value(or: authError)
    }
}
