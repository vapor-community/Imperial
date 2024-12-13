import Vapor

struct GitlabAuth: FederatedServiceTokens {
    static let idEnvKey: String = "GITLAB_CLIENT_ID"
    static let secretEnvKey: String = "GITLAB_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
        guard let clientID = Environment.get(GitlabAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(GitlabAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(GitlabAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(GitlabAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
