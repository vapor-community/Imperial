import JSON

internal fileprivate(set) var federatedServices: [String: FederatedService.Type] = [
    :
]

extension FederatedService {
    public static func registerName() {
        let key = String(describing: self)
        federatedServices[key] = self
    }
    
    public static var typeName: String {
        return String(describing: self)
    }
}

extension Service: JSONConvertible {
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("name", self.name)
        try json.set("token_prefix", self.tokenPrefix)
        try json.set("endpoints", self.endpoints)
        try json.set("model", federatedServices[self.model.typeName])
        return json
    }
    
    public init(json: JSON) throws {
        let key: String = try json.get("model")
        
        let name: String = try json.get("name")
        let tokenPrefix: String = try json.get("token_prefix")
        let endpoints: [String: String] = try json.get("endpoints")
        let model: FederatedService.Type = try federatedServices[key] ?? ServiceError.noExistingService(key)
        
        self.init(name: name, prefix: tokenPrefix, model: model, endpoints: endpoints)
    }
}
