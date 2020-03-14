public struct GitlabOAuth: OAuthServiceProtocol {
    public static let name: String = "gitlab"

    @Endpoint var user = "https://gitlab.com/api/v4/"

    public init() { }
}

extension OAuthService {
    static let gitlab = OAuthService(GitlabOAuth())
}
