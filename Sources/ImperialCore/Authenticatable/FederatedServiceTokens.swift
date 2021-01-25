/**
Represents a type that fetches the client id and secret
from environment variables and stores them.
 
 Usage:
 
 ```swift
 public class GitHubAuth: FederatedServiceTokens {
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
 ```
 */
public protocol FederatedServiceTokens {
    
    /// The name of the environment variable that has the client ID.
    static var idEnvKey: String { get set }
    
    /// The client ID for the OAuth provider that the service is connected to.
    var clientID: String { get set }
    
    /// The name of the environment variable that has the client secret.
    static var secretEnvKey: String { get }
    
    /// The client secret for the OAuth provider that the service is connected to.
    var clientSecret: String { get }
    
    /// Gets the client ID and secret from the environment variables and store them.
    init() throws
}
