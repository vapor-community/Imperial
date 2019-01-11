import Vapor

public class Shopify: FederatedService {
	
	public var tokens: FederatedServiceTokens {
		return self.router.tokens
	}
	
	public var router: FederatedServiceRouter
	
	public required init(router: Router,
						 authenticate: String,
						 callback: String,
						 scope: [String],
						 completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
		
		self.router = try ShopifyRouter(callback: callback, completion: completion)
		self.router.scope = scope
		
		try self.router.configureRoutes(withAuthURL: authenticate, on: router)
	}
}
