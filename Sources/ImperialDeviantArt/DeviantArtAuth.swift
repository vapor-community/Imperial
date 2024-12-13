import Vapor

struct DeviantArtAuth: FederatedServiceTokens {
    static let idEnvKey: String = "DEVIANTART_CLIENT_ID"
    static let secretEnvKey: String = "DEVIANTART_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
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
