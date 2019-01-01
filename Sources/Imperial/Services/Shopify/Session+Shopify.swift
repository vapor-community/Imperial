import Vapor

extension Session {
	
	enum SessionKeys {
		static let domain = "shop_domain"
		static let token = "access_token"
	}
	
	func shopDomain() throws -> String {
		guard let domain = self[SessionKeys.domain] else { throw Abort(.notFound) }
		return domain
	}
	
	func setShopDomain(domain: String) {
		self[SessionKeys.domain] = domain
	}
	
	func setAccessToken(token: String) {
		self[SessionKeys.token] = token
	}
}
