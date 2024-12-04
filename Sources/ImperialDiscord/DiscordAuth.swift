import Vapor

struct DiscordAuth: FederatedServiceTokens {
    static let idEnvKey: String = "DISCORD_CLIENT_ID"
    static let secretEnvKey: String = "DISCORD_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
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
