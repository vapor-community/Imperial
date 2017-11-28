fileprivate var services: [String: Service] = [:]

public struct Service {
    public let name: String
    public let model: FederatedService
    
    static func register(_ service: Service) {
        services[service.name] = service
    }
    
    static func get(service name: String)throws -> Service {
        return try services[name] ?? ImperialError.noServiceFound(name)
    }
}
