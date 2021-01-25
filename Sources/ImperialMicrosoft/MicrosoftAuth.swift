import Vapor

public class MicrosoftAuth: FederatedServiceTokens {
    public static var idEnvKey: String = "MICROSOFT_CLIENT_ID"
    public static var secretEnvKey: String = "MICROSOFT_CLIENT_SECRET"
    public var clientID: String
    public var clientSecret: String
    
    public required init() throws {
        let idError = ImperialError.missingEnvVar(MicrosoftAuth.idEnvKey)
        let secretError = ImperialError.missingEnvVar(MicrosoftAuth.secretEnvKey)
        
        self.clientID = try Environment.get(MicrosoftAuth.idEnvKey).value(or: idError)
        self.clientSecret = try Environment.get(MicrosoftAuth.secretEnvKey).value(or: secretError)
    }
}
