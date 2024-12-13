import Vapor

struct DropboxAuth: FederatedServiceTokens {
    static let idEnvKey: String = "DROPBOX_CLIENT_ID"
    static let secretEnvKey: String = "DROPBOX_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
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
