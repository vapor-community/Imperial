extension OAuthService {
    public static let auth0 = OAuthService.init(
        name: "auth0",
        endpoints: [
            "user": "https://api.auth0.com/user"
        ]
    )
}
