import Vapor

internal fileprivate(set) var drop: Droplet!

public class Provider: Vapor.Provider {
    public static var repositoryName: String = "Imperial"
    
    public func boot(_ droplet: Droplet) throws {
        drop = droplet
    }
    
    public func boot(_ config: Config) throws {}
    public func beforeRun(_ droplet: Droplet) throws {}
    public required init(config: Config) throws {}
}
