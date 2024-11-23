import Vapor

final public class GoogleJWTAuth: FederatedServiceTokens {
    public static let idEnvKey: String = "GOOGLEJWT_CLIENT_EMAIL"
    public static let secretEnvKey: String = "GOOGLEJWT_CLIENT_SECRET"
    public let clientID: String
    public let clientSecret: String

    public required init() throws {
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
