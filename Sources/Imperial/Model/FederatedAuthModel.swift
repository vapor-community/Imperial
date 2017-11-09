import FluentProvider

public protocol FederatedAuthModel: Model {
    var authTokenKey: String { get }
    var encryptEnvKey: String { get }
    var encryptKey: String { get }
}

extension FederatedAuthModel {
    var encryptEnvKey: String {
        return "imperial-access-encrypt"
    }
}
