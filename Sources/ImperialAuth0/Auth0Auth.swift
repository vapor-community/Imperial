import Vapor

public class Auth0Auth: FederatedServiceTokens {
    public static var domain: String = "AUTH0_DOMAIN"
    public static var idEnvKey: String = "AUTH0_CLIENT_ID"
    public static var secretEnvKey: String = "AUTH0_CLIENT_SECRET"
    public var domain: String
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
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
