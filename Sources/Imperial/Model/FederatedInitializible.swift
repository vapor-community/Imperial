import JSON

public protocol FederatedCreatable {
    static var tokenPrefix: String { get }
    static var dataUri: String { get }
    
    var service: Service { get }
    
    static func create(with json: JSON)throws -> Self
}

extension FederatedCreatable {
    public var tokenPrefix: String {
        return "Bearer "
    }
}
