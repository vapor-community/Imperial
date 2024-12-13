import Vapor

struct GoogleJWTResponse: Content {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
