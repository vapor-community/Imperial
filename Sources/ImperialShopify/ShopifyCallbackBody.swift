import Vapor

struct ShopifyCallbackBody: Content {
	let code: String
	let clientId: String
	let clientSecret: String
		
	enum CodingKeys: String, CodingKey {
		case code
		case clientId = "client_id"
		case clientSecret = "client_secret"
	}
}
