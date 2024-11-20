import Vapor

final public class GitlabAuth: FederatedServiceTokens {
    public static let idEnvKey: String = "GITLAB_CLIENT_ID"
    public static let secretEnvKey: String = "GITLAB_CLIENT_SECRET"
    public let clientID: String
    public let clientSecret: String
    
    public required init() throws {
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
