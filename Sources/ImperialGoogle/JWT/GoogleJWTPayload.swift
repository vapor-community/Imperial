import JWTKit
import Vapor

struct GoogleJWTPayload: JWTPayload {
    var iss: IssuerClaim
    var scope: String
    var aud: AudienceClaim
    var iat: IssuedAtClaim
    var exp: ExpirationClaim

    func verify(using key: some JWTAlgorithm) throws {
        try exp.verifyNotExpired()
    }
}
