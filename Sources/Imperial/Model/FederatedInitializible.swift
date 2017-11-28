import JSON

public protocol FederatedCreatable {
    var tokenPrefix: String { get }
    var dataUri: String { get }
    
    static func create(with json: JSON) -> Self
}

extension FederatedCreatable {
    public var tokenPrefix: String {
        return "Bearer "
    }
}
