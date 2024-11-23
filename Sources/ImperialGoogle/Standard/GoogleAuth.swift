import Vapor

final public class GoogleAuth: FederatedServiceTokens {
    public static let idEnvKey: String = "GOOGLE_CLIENT_ID"
    public static let secretEnvKey: String = "GOOGLE_CLIENT_SECRET"
    public let clientID: String
    public let clientSecret: String

    public required init() throws {
        guard let clientID = Environment.get(GoogleAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(GoogleAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(GoogleAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(GoogleAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
