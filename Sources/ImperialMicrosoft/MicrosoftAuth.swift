import Vapor

final public class MicrosoftAuth: FederatedServiceTokens {
    public static let idEnvKey: String = "MICROSOFT_CLIENT_ID"
    public static let secretEnvKey: String = "MICROSOFT_CLIENT_SECRET"
    public let clientID: String
    public let clientSecret: String

    public required init() throws {
        guard let clientID = Environment.get(MicrosoftAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(MicrosoftAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(MicrosoftAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(MicrosoftAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
