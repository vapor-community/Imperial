import Vapor

public class ShopifyAuth: FederatedServiceTokens {
	public static var idEnvKey: String = "SHOPIFY_CLIENT_ID"
	public static var secretEnvKey: String = "SHOPIFY_CLIENT_SECRET"
	public var clientID: String
	public var clientSecret: String
	
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
