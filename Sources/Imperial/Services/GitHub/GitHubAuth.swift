import Vapor

public class GitHubAuth: FederatedLoginService {
    public var idEnvKey: String = "IMPERIAL_GITHUB_ID"
    public var secretEnvKey: String = "IMPERIAL_GITHUB_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(idEnvKey)
        let secretError = ImperialError.missingEnvVar(secretEnvKey)
        
        self.clientID = try Env.get(idEnvKey).value(or: idError)
        self.clientSecret = try Env.get(secretEnvKey).value(or: secretError)
    }
}
