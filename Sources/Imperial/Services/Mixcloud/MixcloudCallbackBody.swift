import Vapor

struct MixcloudCallbackBody: Content {
    let code: String
    let clientId: String
    let clientSecret: String
    let redirectURI: String

    static var defaultContentType: MediaType = .urlEncodedForm

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case redirectURI = "redirect_uri"
    }
}
