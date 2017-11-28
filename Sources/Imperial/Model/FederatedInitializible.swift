import JSON

public protocol FederatedInitializible {
    var tokenPrefix: String { get }
    
    static func create(with json: JSON) -> Self
}
