import Vapor

final public class ShopifyAuth: FederatedServiceTokens {
    public static let idEnvKey: String = "SHOPIFY_CLIENT_ID"
    public static let secretEnvKey: String = "SHOPIFY_CLIENT_SECRET"
    public let clientID: String
    public let clientSecret: String

    public required init() throws {
        guard let clientID = Environment.get(ShopifyAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(ShopifyAuth.idEnvKey)
        }
        self.clientID = clientID

        guard let clientSecret = Environment.get(ShopifyAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(ShopifyAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}
