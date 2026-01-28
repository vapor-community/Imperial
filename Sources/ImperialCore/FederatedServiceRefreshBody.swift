import Vapor

struct FederatedServiceRefreshBody: Content {
    let refreshToken: String
    let clientId: String
    let clientSecret: String
    let grantType: String = "refresh_token"

    static let defaultContentType: HTTPMediaType = .urlEncodedForm

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case grantType = "grant_type"
    }
}
