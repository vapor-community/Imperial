import Vapor

struct DiscordCallbackBody: Content {
    static let defaultContentType = HTTPMediaType.urlEncodedForm

    let clientId: String
    let clientSecret: String
    let grantType: String
    let code: String
    let redirectUri: String

    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case grantType = "grant_type"
        case code
        case redirectUri = "redirect_uri"
    }
}
