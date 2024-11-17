import Vapor

final public class DiscordAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "DISCORD_CLIENT_ID"
    public static var secretEnvKey: String = "DISCORD_CLIENT_SECRET"
    public let clientID: String
    public let clientSecret: String

    public required init() throws {
        guard let clientID = Environment.get(DiscordAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(DiscordAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(DiscordAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(DiscordAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
