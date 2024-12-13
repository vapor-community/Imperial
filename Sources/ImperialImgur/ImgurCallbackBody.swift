import Vapor

struct ImgurCallbackBody: Content {
    let code: String
    let clientId: String
    let clientSecret: String
    let grantType: String = "authorization_code"

    static let defaultContentType: HTTPMediaType = .urlEncodedForm

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case grantType = "grant_type"
    }
}
