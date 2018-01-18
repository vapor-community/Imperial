extension ImperialService {
    public static let github = ImperialService.init(
        name: "github",
        model: GitHub.self,
        endpoints: [
            "user": "https://api.github.com/user"
        ]
    )
}
