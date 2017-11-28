import JSON

public protocol FederatedInitializible {
    static func create(with json: JSON) -> Self
}
