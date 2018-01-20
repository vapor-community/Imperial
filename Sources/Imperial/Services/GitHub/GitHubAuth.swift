import Vapor

public class GitHubAuth: FederatedServiceTokens {
    public var idEnvKey: String = "GITHUB_CLIENT_ID"
    public var secretEnvKey: String = "GITHUB_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(idEnvKey)
        let secretError = ImperialError.missingEnvVar(secretEnvKey)
        
        self.clientID = try Environment.get(idEnvKey) ?? idError
        self.clientSecret = try Environment.get(secretEnvKey) ?? secretError
    }
}
