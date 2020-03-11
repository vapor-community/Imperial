import Vapor

public class ImgurAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "IMGUR_CLIENT_ID"
    public static var secretEnvKey: String = "IMGUR_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String

    public required init() throws {
        let idError = ImperialError.missingEnvVar(ImgurAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(ImgurAuth.secretEnvKey)

        self.clientID = try Environment.get(ImgurAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(ImgurAuth.secretEnvKey).value(or: secretError)
    }
}
