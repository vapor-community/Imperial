public struct FacebookOAuth: OAuthServiceProtocol {
    public static let name = "facebook"

    public init() { }
}

extension OAuthService {
    public static let facebook = OAuthService(FacebookOAuth())
}
