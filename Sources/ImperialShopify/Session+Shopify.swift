import Vapor

extension Session {
    enum ShopifyKey {
        static let domain = "shop_domain"
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
}
