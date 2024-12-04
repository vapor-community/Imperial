import Vapor

struct GitHubAuth: FederatedServiceTokens {
    static let idEnvKey: String = "GITHUB_CLIENT_ID"
    static let secretEnvKey: String = "GITHUB_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
        guard let clientID = Environment.get(GitHubAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(GitHubAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(GitHubAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(GitHubAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
