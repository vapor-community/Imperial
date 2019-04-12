extension OAuthService {
    public static let gitlab = OAuthService.init(
        name: "gitlab",
        endpoints: [
            "user": "https://gitlab.com/api/v4/user"
        ]
    )
}
