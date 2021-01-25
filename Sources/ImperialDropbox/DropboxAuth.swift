import Vapor

public class DropboxAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "DROPBOX_CLIENT_ID"
    public static var secretEnvKey: String = "DROPBOX_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(DropboxAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(DropboxAuth.secretEnvKey)
        
        self.clientID = try Environment.get(DropboxAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(DropboxAuth.secretEnvKey).value(or: secretError)
    }
}
