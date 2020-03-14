import Vapor

public class GitlabAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "GITLAB_CLIENT_ID"
    public static var secretEnvKey: String = "GITLAB_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(GitlabAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(GitlabAuth.secretEnvKey)
        
        self.clientID = try Environment.get(GitlabAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(GitlabAuth.secretEnvKey).value(or: secretError)
    }
}
