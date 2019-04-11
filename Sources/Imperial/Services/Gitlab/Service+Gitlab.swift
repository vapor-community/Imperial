extension OAuthService {
    public static let gitlab = OAuthService.init(
        name: "gitlab",
        endpoints: [
            "user": "https://api.gitlab.com/user"
        ]
    )
}
