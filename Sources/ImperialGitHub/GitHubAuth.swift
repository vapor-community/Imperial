import Vapor

final public class GitHubAuth: FederatedServiceTokens {
    public static let idEnvKey: String = "GITHUB_CLIENT_ID"
    public static let secretEnvKey: String = "GITHUB_CLIENT_SECRET"
    public let clientID: String
    public let clientSecret: String

    public required init() throws {
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
