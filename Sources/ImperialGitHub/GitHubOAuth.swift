public struct GitHubOAuth: OAuthServiceProtocol {
    public static let name = "github"

    public init() { }

    @Endpoint var user = "https://api.github.com/user"
}

extension OAuthService {
    public static let github = OAuthService(GitHubOAuth())
}
