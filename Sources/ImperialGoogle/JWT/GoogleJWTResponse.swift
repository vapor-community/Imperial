import Vapor

public struct GoogleJWTResponse: Content {
    public var accessToken: String
    public var tokenType: String
    public var expiresIn: Int
    
    public enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
