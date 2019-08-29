import Vapor

extension Session.Keys {
    static let domain = "shop_domain"
    static let nonce = "nonce"
}

extension Session {
    
    func shopDomain() throws -> String {
        guard let domain = try? get(Keys.domain, as: String.self) else { throw Abort(.notFound) }
        return domain
    }
    
    func setShopDomain(_ domain: String) throws {
        try set(Keys.domain, to: domain)
    }
    
    func setNonce(_ nonce: String?) throws {
        try set(Keys.nonce, to: nonce)
    }
    
    func nonce() -> String? {
        return try? get(Keys.nonce, as: String.self)
    }
}
