import Foundation
import Crypto

extension URL {
	
	func generateHMAC(key: String) -> String {
		let components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
		let params = components.queryItems!.filter { $0.name != "hmac" }
		let queryItems = params.map { $0.name + "=" + $0.value! }
		let queryString = queryItems.joined(separator: "&")
		
        let hmac = HMAC<SHA256>.authenticationCode(for: queryString.bytes, using: .init(data: key.bytes))
		return hmac.description
	}

	func isValidShopifyDomain() -> Bool {
		let domain = "myshopify.com"
		
		guard absoluteString.suffix(domain.count) == domain else { return false }
		
		return absoluteString.range(of: "^[a-z0-9.-]+.myshopify.com$", options: .regularExpression) != nil
	}
}
