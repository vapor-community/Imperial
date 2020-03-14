public struct GoogleJWTOAuth: OAuthServiceProtocol {
    public static let name = "googleJWT"

    public init() { }
}

extension OAuthService {
    public static let googleJWT = OAuthService(GoogleJWTOAuth())
}
