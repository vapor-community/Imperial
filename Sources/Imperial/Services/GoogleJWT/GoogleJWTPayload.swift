import Vapor
import JWT

public struct GoogleJWTPayload: JWTPayload {
    public var iss: IssuerClaim
    public var scope: String
    public var aud: AudienceClaim
    public var iat: IssuedAtClaim
    public var exp: ExpirationClaim

    public func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
