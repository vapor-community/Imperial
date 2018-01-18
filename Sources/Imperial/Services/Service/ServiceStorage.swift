import Service

final class ServiceStorage: Service {
    private(set) var model: FederatedCreatable!
    
    init() {}
    
    subscript (model: FederatedCreatable) -> FederatedCreatable {
        get {
            return self.model
        }
        set {
            self.model = model
        }
    }
}
