import Vapor

extension Session.Keys {
    static let domain = "shop_domain"
    static let nonce = "nonce"
}

extension Session {
    
    func shopDomain() throws -> String {
        guard let domain = self[Keys.domain] else { throw Abort(.notFound) }
        return domain
    }
    
    func setShopDomain(_ domain: String) {
        self[Keys.domain] = domain
    }
    
    func setNonce(_ nonce: String?) {
        self[Keys.nonce] = nonce
    }
    
    func nonce() -> String? {
        return self[Keys.nonce]
    }
}
