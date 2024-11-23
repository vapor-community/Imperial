import Vapor

struct XCallbackBody: Content {
    let code: String
    let clientId: String
    let clientSecret: String
    let redirectURI: String
    let codeVerifier: String
    let grantType: String = "authorization_code"
    
    static let defaultContentType: HTTPMediaType = .urlEncodedForm
    
    enum CodingKeys: String, CodingKey {
        case code
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case redirectURI = "redirect_uri"
        case codeVerifier = "code_verifier"
        case grantType = "grant_type"
    }
}