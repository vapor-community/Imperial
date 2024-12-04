import Vapor

final public class DeviantArtAuth: FederatedServiceTokens {
    public static let idEnvKey: String = "DEVIANTART_CLIENT_ID"
    public static let secretEnvKey: String = "DEVIANTART_CLIENT_SECRET"
    public let clientID: String
    public let clientSecret: String

    public required init() throws {
        guard let clientID = Environment.get(DeviantArtAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(DeviantArtAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(DeviantArtAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(DeviantArtAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
