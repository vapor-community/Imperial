import Vapor

internal fileprivate(set) var drop: Droplet!

public class Provider: Vapor.Provider {
    public static var repositoryName: String = "Imperial"
    
    public func boot(_ droplet: Droplet) throws {
        drop = droplet
    }
    
    public func boot(_ config: Config) throws {
        guard let imperial = config["imperial"]?.object else {
            return
        }
        
        if let ghID = imperial["github_client_id"]?.string,
           let ghSecret = imperial["github_client_secret"]?.string {
            ImperialConfig.gitHubID = ghID
            ImperialConfig.gitHubSecret = ghSecret
        }
        
        if let googleID = imperial["google_client_id"]?.string,
           let googleSecret = imperial["google_client_secret"]?.string {
            ImperialConfig.googleID = googleID
            ImperialConfig.googleSecret = googleSecret
        }
    }
    
    public func beforeRun(_ droplet: Droplet) throws {}
    public required init(config: Config) throws {}
}

internal struct ImperialConfig {
    internal fileprivate(set) static var gitHubID: String?
    internal fileprivate(set) static var gitHubSecret: String?
    internal fileprivate(set) static var googleID: String?
    internal fileprivate(set) static var googleSecret: String?
}
