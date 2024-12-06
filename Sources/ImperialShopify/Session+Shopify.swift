import Vapor

extension Session {
    enum ShopifyKey {
        static let domain = "shop_domain"
        static let nonce = "nonce"
    }

    var shopDomain: String {
        get throws {
            guard let domain = try? self.get(ShopifyKey.domain, as: String.self) else {
                throw Abort(.notFound)
            }
            return domain
        }
    }

    func setShopDomain(_ domain: String) throws {
        try self.set(ShopifyKey.domain, to: domain)
    }

    var nonce: String? {
        try? self.get(ShopifyKey.nonce, as: String.self)
    }

    func setNonce(_ nonce: String?) throws {
        try self.set(ShopifyKey.nonce, to: nonce)
    }
}
