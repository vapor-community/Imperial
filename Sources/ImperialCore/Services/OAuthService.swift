import class NIO.ThreadSpecificVariable
import Vapor

fileprivate var services: ThreadSpecificVariable<OAuthServiceContainer> = .init(value: .init())

/// Represents a service that interacts with an OAuth provider.
public struct OAuthService: Codable, Content {

    /// The services that are available for use in the application.
    /// Services are added and fetched with the `Service.register` and `.get` static methods.
    private static var services: OAuthServiceContainer {
        get { ImperialCore.services.currentValue! }
        set { ImperialCore.services.currentValue  = newValue }
    }


    /// The name of the service, i.e. "google", "github", etc.
    public let name: String
    
    /// The prefix for the access token when it is used in a authorization header. Defaults to `'Bearer '`.
    public let tokenPrefix: String
    
    /// The endpoints for the provider's API to use for initializing `FederatedCreatable` types
    public var endpoints: [String: String]
    
    /// Defines an OAuth provider that is supported by Imperial.
    ///
    /// Providers are usually defined in extensions as static properties.
    ///
    ///     extension OAuthService {
    ///         static let google = OAuthService(name: "google", endpoints: [:])
    ///     }
    ///
    /// - Parameters:
    ///   - name: The name of the service.
    ///   - prefix: The prefix for the access token when it is used in a authoriazation header.
    ///   - uri: The URI used to get data to initialize a `FederatedCreatable` type.
    ///   - model: The model that works with the service.
    public init(name: String, prefix: String? = nil, endpoints: [String: String]) {
        self.name = name
        self.tokenPrefix = prefix ?? "Bearer "
        self.endpoints = endpoints
    }
    
    /// Syntax sugar for getting or setting one of the service's endpoints.
    public subscript (key: String) -> String? {
        get {
            return endpoints[key]
        }
        set {
            endpoints[key] = newValue
        }
    }
    
    /// Registers a service as available for use.
    ///
    /// - Parameter service: The service to register.
    public static func register(_ service: OAuthService) {
        #warning("It would be nice if this method could be internal")
        self.services[service.name] = service
    }
    
    /// Gets a service if it is available for use.
    ///
    /// - Parameter name: The name of the service to fetch.
    /// - Returns: The service that matches the name passed in.
    /// - Throws: `ImperialError.noServiceFound` if no service is found with the name passed in.
    public static func get(service name: String) throws -> OAuthService {
        return try self.services[name].value(or: ServiceError.noServiceFound(name))
    }
}

private final class OAuthServiceContainer {
    var services: [String: OAuthService]

    init() {
        self.services = [:]
    }

    subscript(service: String) -> OAuthService? {
        get { self.services[service] }
        set { self.services[service] = newValue }
    }
}
