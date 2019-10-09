import Vapor

struct NetIDCallbackBody: Content {

    let code: String
    let redirectURI: String
    let grantType: String = "authorization_code"
    
    static var defaultContentType: MediaType = .urlEncodedForm
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case redirectURI = "redirect_uri"
        case grantType = "grant_type"
    }

}
