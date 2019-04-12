import Vapor

struct GitlabCallbackBody: Content {
    let clientId: String
    let clientSecret: String
    let code: String
    let grantType: String
    let redirectUri: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case code
        case grantType = "grant_type"
        case redirectUri = "redirect_uri"
    }
}
