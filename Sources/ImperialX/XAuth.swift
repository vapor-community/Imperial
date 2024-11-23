import Vapor

final public class XAuth: FederatedServiceTokens {
    public static let idEnvKey: String = "X_CLIENT_ID"
    public static let secretEnvKey: String = "X_CLIENT_SECRET"
    public let clientID: String
    public let clientSecret: String
    
    public required init() throws {
        guard let clientID = Environment.get(XAuth.idEnvKey) else {
            throw ImperialError.missingEnvVar(XAuth.idEnvKey)
        }
        self.clientID = clientID
        
        guard let clientSecret = Environment.get(XAuth.secretEnvKey) else {
            throw ImperialError.missingEnvVar(XAuth.secretEnvKey)
        }
        self.clientSecret = clientSecret
    }
}