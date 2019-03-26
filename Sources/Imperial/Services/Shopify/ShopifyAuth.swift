import Vapor

public class ShopifyAuth: FederatedServiceTokens {
	public static var idEnvKey: String = "SHOPIFY_CLIENT_ID"
	public static var secretEnvKey: String = "SHOPIFY_CLIENT_SECRET"
	public var clientID: String
	public var clientSecret: String
	
	public required init() throws {
		let idError = ImperialError.missingEnvVar(ShopifyAuth.idEnvKey)
		let secretError = ImperialError.missingEnvVar(ShopifyAuth.secretEnvKey)
		
		self.clientID = try Environment.get(ShopifyAuth.idEnvKey).value(or: idError)
		self.clientSecret = try Environment.get(ShopifyAuth.secretEnvKey).value(or: secretError)
	}
}
