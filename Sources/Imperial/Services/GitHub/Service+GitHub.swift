extension Service {
    public static let github = Service.init(
        name: "github",
        model: GitHub.self,
        endpoints: [
            "user": "https://api.github.com/user"
        ]
    )
}
