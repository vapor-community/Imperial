extension OAuthService {
    static let gitlab = OAuthService.init(
        name: "gitlab",
        endpoints: [
            "user": "https://gitlab.com/api/v4/"
        ]
    )
}
