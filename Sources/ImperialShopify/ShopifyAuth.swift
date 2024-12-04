import Vapor

struct ShopifyAuth: FederatedServiceTokens {
    static let idEnvKey: String = "SHOPIFY_CLIENT_ID"
    static let secretEnvKey: String = "SHOPIFY_CLIENT_SECRET"
    let clientID: String
    let clientSecret: String

    init() throws {
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
