public struct ShopifyOAuth: OAuthServiceProtocol {
    public static let name = "shopify"

    public init() { }
}

extension OAuthService {
    public static let shopify = OAuthService(ShopifyOAuth())
}
