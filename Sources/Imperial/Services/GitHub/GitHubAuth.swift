import Vapor

public class GitHubAuth: FederatedLoginService {
    public var idEnvKey: String = "GITHUB_CLIENT_ID"
    public var secretEnvKey: String = "GITHUB_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(idEnvKey)
        let secretError = ImperialError.missingEnvVar(secretEnvKey)
        
        do {
            guard let id = ImperialConfig.gitHubID else {
                throw idError
            }
            self.clientID = id
        } catch {
            self.clientID = try Env.get(idEnvKey).value(or: idError)
        }
        
        do {
            guard let secret = ImperialConfig.gitHubSecret else {
                throw secretError
            }
            self.clientSecret = secret
        } catch {
            self.clientSecret = try Env.get(secretEnvKey).value(or: secretError)
        }
    }
}
