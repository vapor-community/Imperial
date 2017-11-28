import JSON

public protocol FederatedInitializible {
    var tokenPrefix: String { get }
    var dataUri: String { get }
    
    static func create(with json: JSON) -> Self
}
