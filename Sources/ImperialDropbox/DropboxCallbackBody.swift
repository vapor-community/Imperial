import Vapor

struct DropboxCallbackBody: Content {
    let code: String
    let redirectURI: String
    let grantType: String = "authorization_code"
    
    static var defaultContentType: HTTPMediaType = .urlEncodedForm
    
    enum CodingKeys: String, CodingKey {
        case code
        case redirectURI = "redirect_uri"
        case grantType = "grant_type"
    }
}
