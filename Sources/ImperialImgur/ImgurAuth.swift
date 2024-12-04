import Vapor

final public class ImgurAuth: FederatedServiceTokens {
    public static let idEnvKey: String = "IMGUR_CLIENT_ID"
    public static let secretEnvKey: String = "IMGUR_CLIENT_SECRET"
    public let clientID: String
    public let clientSecret: String

    public required init() throws {
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
