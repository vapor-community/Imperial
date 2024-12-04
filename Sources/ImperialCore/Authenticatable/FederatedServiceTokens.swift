/// Represents a type that fetches the client id and secret
/// from environment variables and stores them.
///
///  Usage:
///
///  ```swift
///  struct GitHubAuth: FederatedServiceTokens {
///      static let idEnvKey: String = "GITHUB_CLIENT_ID"
///      static let secretEnvKey: String = "GITHUB_CLIENT_SECRET"
///      let clientID: String
///      let clientSecret: String
///
///      init() throws {
///          guard let clientID = Environment.get(GitHubAuth.idEnvKey) else {
///              throw ImperialError.missingEnvVar(GitHubAuth.idEnvKey)
///          }
///          self.clientID = clientID
///
///          guard let clientSecret = Environment.get(GitHubAuth.secretEnvKey) else {
///              throw ImperialError.missingEnvVar(GitHubAuth.secretEnvKey)
///          }
///          self.clientSecret = clientSecret
///      }
///  }
///  ```
public protocol FederatedServiceTokens: Sendable {
    /// The name of the environment variable that has the client ID.
    static var idEnvKey: String { get }

    /// The client ID for the OAuth provider that the service is connected to.
    var clientID: String { get }

    /// The name of the environment variable that has the client secret.
    static var secretEnvKey: String { get }

    /// The client secret for the OAuth provider that the service is connected to.
    var clientSecret: String { get }

    /// Gets the client ID and secret from the environment variables and store them.
    init() throws
}
