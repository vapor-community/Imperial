import Vapor

public class DiscordAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "DISCORD_CLIENT_ID"
    public static var secretEnvKey: String = "DISCORD_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String

    public required init() throws {
        let idError = ImperialError.missingEnvVar(DiscordAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(DiscordAuth.secretEnvKey)

        self.clientID = try Environment.get(DiscordAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(DiscordAuth.secretEnvKey).value(or: secretError)
    }
}
