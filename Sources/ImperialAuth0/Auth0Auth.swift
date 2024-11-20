import Vapor

final public class Auth0Auth: FederatedServiceTokens {
    public static let domain: String = "AUTH0_DOMAIN"
    public static let idEnvKey: String = "AUTH0_CLIENT_ID"
    public static let secretEnvKey: String = "AUTH0_CLIENT_SECRET"
    public let domain: String
    public let clientID: String
    public let clientSecret: String
    
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
