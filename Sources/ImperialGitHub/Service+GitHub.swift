extension OAuthService {
    public static let github = OAuthService.init(
        name: "github",
        endpoints: [
            "user": "https://api.github.com/user"
        ]
    )
}
