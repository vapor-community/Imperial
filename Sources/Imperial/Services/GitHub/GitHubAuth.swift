import Vapor

public class GitHubAuth: FederatedLoginService {
    public var idEnvKey: String = "imperial-github-id"
    public var secretEnvKey: String = "imperial-github-secret"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(idEnvKey)
        let secretError = ImperialError.missingEnvVar(secretEnvKey)
        
        self.clientID = try Env.get(idEnvKey).value(or: idError)
        self.clientSecret = try Env.get(secretEnvKey).value(or: secretError)
    }
}
