import Vapor

public class Provider: Vapor.Provider {
    
    public static var repositoryName: String = "Imperial"
    
    /// Register all services provided by the provider here.
    public func register(_ services: inout Services) throws {
        services.register(isSingleton: true) { (container) in
            return ServiceStorage()
        }
    }
    
    /// Called after the container has initialized.
    public func boot(_ worker: Container) throws {
        Google.registerName()
        GitHub.registerName()
    }
}

internal struct ImperialConfig {
    internal fileprivate(set) static var gitHubID: String?
    internal fileprivate(set) static var gitHubSecret: String?
    internal fileprivate(set) static var googleID: String?
    internal fileprivate(set) static var googleSecret: String?
}
