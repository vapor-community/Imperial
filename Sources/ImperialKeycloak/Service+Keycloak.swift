public struct KeycloakOAuth: OAuthServiceProtocol {
    public static let name = "keycloak"

    public init() { }
}

extension OAuthService {
    public static let keycloak = OAuthService(KeycloakOAuth())
}
