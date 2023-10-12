import Vapor

public struct GitHubCallbackBody: Content {
    let clientId: String
    let clientSecret: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case code
    }
}
