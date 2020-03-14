public struct GoogleOAuth: OAuthServiceProtocol {
    public static let name = "googel"

    public init() { }
}

extension OAuthService {
    public static let google = OAuthService(GoogleOAuth())
}
