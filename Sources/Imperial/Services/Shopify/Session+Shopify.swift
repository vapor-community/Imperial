import Vapor

extension Session.Keys {
	static let domain = "shop_domain"
}

extension Session {
	
	public func shopDomain() throws -> String {
		guard let domain = self[Keys.domain] else { throw Abort(.notFound) }
		return domain
	}
	
	func setShopDomain(_ domain: String) {
		self[Keys.domain] = domain
	}
}
