import Vapor

extension Session {
    enum ShopifyKey {
        static let domain = "shop_domain"
        static let nonce = "nonce"
    }

    func shopDomain() throws -> String {
        guard let domain = try? self.get(ShopifyKey.domain, as: String.self) else { throw Abort(.notFound) }
        return domain
    }
    
    func setShopDomain(_ domain: String) throws {
        try self.set(ShopifyKey.domain, to: domain)
    }
    
    func setNonce(_ nonce: String?) throws {
        try self.set(ShopifyKey.nonce, to: nonce)
    }
    
    func nonce() -> String? {
        return try? self.get(ShopifyKey.nonce, as: String.self)
    }
}
