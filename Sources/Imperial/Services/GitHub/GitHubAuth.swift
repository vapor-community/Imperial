import Vapor

public class GitHubAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "GITHUB_CLIENT_ID"
    public static var secretEnvKey: String = "GITHUB_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(GitHubAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(GitHubAuth.secretEnvKey)
        
        self.clientID = try Environment.get(GitHubAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(GitHubAuth.secretEnvKey).value(or: secretError)
    }
}
