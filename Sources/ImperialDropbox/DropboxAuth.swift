import Vapor

public class DropboxAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "DROPBOX_CLIENT_ID"
    public static var secretEnvKey: String = "DROPBOX_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        guard let clientID = Environment.get(DropboxAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(DropboxAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(DropboxAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(DropboxAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
