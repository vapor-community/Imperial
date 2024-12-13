import Vapor

struct ImgurAuth: FederatedServiceTokens {
    static let idEnvKey: String = "IMGUR_CLIENT_ID"
    static let secretEnvKey: String = "IMGUR_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
        guard let clientID = Environment.get(ImgurAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(ImgurAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(ImgurAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(ImgurAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
