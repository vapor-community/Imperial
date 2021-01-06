import Vapor

public class DeviantArtAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "DEVIANT_CLIENT_ID"
    public static var secretEnvKey: String = "DEVIANT_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String

    public required init() throws {
        let idError = ImperialError.missingEnvVar(DeviantArtAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(DeviantArtAuth.secretEnvKey)

        self.clientID = try Environment.get(DeviantArtAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(DeviantArtAuth.secretEnvKey).value(or: secretError)
    }
}
