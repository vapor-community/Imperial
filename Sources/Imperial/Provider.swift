import Vapor

internal fileprivate(set) var routeer: Router!

public class Provider: Vapor.Provider {
    
    public static var repositoryName: String = "Imperial"
    
    /// Register all services provided by the provider here.
    public func register(_ services: inout Services) throws {}
    
    /// Called after the container has initialized.
    public func boot(_ worker: Container) throws {
        routeer = try worker.make(Router.self, for: Container.self)
    }
}
