import Vapor

struct LinkedInCallbackBody: Content {
    let grantType: String = "authorization_code"
    let code: String
    let redirectURI: String
    let clientId: String
    let clientSecret: String

    static let defaultContentType: HTTPMediaType = .urlEncodedForm

    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case code
        case redirectURI = "redirect_uri"
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }
}
