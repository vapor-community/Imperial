import NIOConcurrencyHelpers
import Vapor

/// Represents a service that interacts with an OAuth provider.
public struct OAuthService: Codable, Content, Sendable {
    static private let servicesBox: NIOLockedValueBox<[String: Self]> = .init([:])

    /// The services that are available for use in the application.
    /// Services are added and fetched with the `Service.register` and `.get` static methods.
    package static var services: [String: Self] {
        get {
            self.servicesBox.withLockedValue { services in
                services
            }
        }
        set {
            self.servicesBox.withLockedValue { services in
                services = newValue
            }
        }
    }

    /// The name of the service, i.e. "google", "github", etc.
    package let name: String

    /// The prefix for the access token when it is used in a authorization header. Defaults to `'Bearer '`.
    package let tokenPrefix: String

    /// The endpoints for the provider's API to use for initializing `FederatedCreatable` types
    package var endpoints: [String: String]

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
    package init(name: String, prefix: String? = nil, endpoints: [String: String]) {
        self.name = name
        self.tokenPrefix = prefix ?? "Bearer "
        self.endpoints = endpoints
    }

    /// Syntax sugar for getting or setting one of the service's endpoints.
    package subscript(key: String) -> String? {
        get {
            return endpoints[key]
        }
        set {
            endpoints[key] = newValue
        }
    }
}
