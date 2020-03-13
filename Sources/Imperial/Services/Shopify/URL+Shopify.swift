import Foundation
import Crypto

extension URL {
	
	func generateHMAC(key: String) -> String {
		let components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
		let params = components.queryItems!.filter { $0.name != "hmac" }
		let queryItems = params.map { $0.name + "=" + $0.value! }
		let queryString = queryItems.joined(separator: "&")
		
        let hmac = HMAC<SHA256>.authenticationCode(for: queryString.bytes, using: .init(data: key.bytes))
		return hmac.hex
	}

	func isValidShopifyDomain() -> Bool {
		let domain = "myshopify.com"
		
		guard absoluteString.suffix(domain.count) == domain else { return false }
		
		return absoluteString.range(of: "^[a-z0-9.-]+.myshopify.com$", options: .regularExpression) != nil
	}
}

extension ContiguousBytes {
    public var hex: String {
        let table: [UInt8] = [
            0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66
        ]

        return String(decoding: self.withUnsafeBytes { buffer in
            Array<UInt8>.init(unsafeUninitializedCapacity: buffer.count * 2) { output, outCount in
                outCount = buffer.reduce(into: 0) { count, byte in
                    output[count + 0] = table[Int(byte / 16)]
                    output[count + 1] = table[Int(byte % 16)]
                    count += 2
                }
            }
        }, as: Unicode.ASCII.self)
    }
}
