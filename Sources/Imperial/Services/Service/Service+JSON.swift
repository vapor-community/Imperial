internal fileprivate(set) var federatedServices: [String: FederatedService.Type] = [
    :
]

extension FederatedService {
    
    /// Saves the `FederatedService` type
    /// so it can be used as the `model` property in a service.
    public static func registerName() {
        let key = Self.typeName
        federatedServices[key] = self
    }
    
    /// The description of the type as a `String`.
    public static var typeName: String {
        return String(describing: self)
    }
}
