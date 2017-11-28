import JSON

public protocol FederatedCreatable {
    static var tokenPrefix: String { get }
    static var dataUri: String { get }
    
    static func create(with json: JSON) -> Self
}

extension FederatedCreatable {
    public var tokenPrefix: String {
        return "Bearer "
    }
}
