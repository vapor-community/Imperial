import Vapor

public class GitlabAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "GITLAB_CLIENT_ID"
    public static var secretEnvKey: String = "GITLAB_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
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
