import class NIO.ThreadSpecificVariable
import struct Vapor.URI
import Foundation

#if os(Linux)
import FoundationNetworking
#endif


// MARK: - OAuthService

/// A type erasure box for `OAuthServiceProtocol` types.
public struct OAuthService: Codable {
    typealias Providers = ThreadSpecificVariable<Box<[String: OAuthServiceProtocol.Type]>>
    private static var providerTypes: Providers = .init(value: .init([:]))

    /// The wrapped service instance.
    public let service: OAuthServiceProtocol

    /// Wraps an `OAuthServiceProtocol` type instance.
    public init(_ service: OAuthServiceProtocol) {
        self.service = service
    }

    /// See `Decodable.init(from:)`.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)

        guard let provider = OAuthService.providerTypes.currentValue?.value[name] else {
            throw DecodingError.dataCorruptedError(
                forKey: .name,
                in: container,
                debugDescription: "Unknown OAuth provider '\(name)'"
            )
        }

        try self.init(provider.init(from: decoder))
    }

    /// Registers the type of the .`service` property so it can be globally accessed at any point later on by Imperial.
    ///
    /// - Note: This method should only be called by `FederatedService` type initializers.
    public static func register(_ service: OAuthService) {
        OAuthService.providerTypes.currentValue?.value[service.name] = type(of: service.service)
    }

    /// See `Encodable.encode(to:)`.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)

        try self.service.encode(to: encoder)
    }

    /// The `.tokenPrefix` value for the underlying `.service` value.
    public var tokenPrefix: String { self.service.tokenPrefix }

    /// The `.tokenPrefix` value for the underlying `.name` value.
    public var name: String { self.service.name }


    /// Gets an endpoint URL for an endpoint name from the underlying `.servce`.
    public subscript(endpoint: String) -> URL? {
        return self.service.endpoints[endpoint]
    }

    enum CodingKeys: String, CodingKey {
        case name
    }
}


// MARK: - OAuthServiceProtocol

/// A type that represent an OAuth provider and the endpoints that it provides.
///
///     public struct MyOAuth: OAuthServiceProtocol {
///         public static let name = "my"
///
///         public init() { }
///
///         @Endpoint var user = "https://my.a.pi/session/user"
///         @Endpoint var history = "https://my.a.pi/session/history"
///     }
///
///     extension OAuthService {
///         public static let my = OAuthService(MyOAuth())
///     }
public protocol OAuthServiceProtocol: Codable {

    /// The prefix for the access token when it is used in a authorization header. The default implementation is `"Bearer "`.
    static var tokenPrefix: String { get }

    /// The name of the service, i.e. `google`, `github`, etc.
    static var name: String { get }

    /// An empty initializer so Imperial can create an instance of the current type on the fly.
    ///
    /// Currently this is just for future proofing.
    init()
}

extension OAuthServiceProtocol {

    /// The default static `.tokenPrefix` value, which is `"Bearer "`.
    public static var tokenPrefix: String { "Bearer " }

    /// The static `.tokenPrefix` property value, so it can easily be accessed from an instance.
    public var tokenPrefix: String { Self.tokenPrefix }

    /// The static `.name` property value, so it can easily be accessed from an instance.
    public var name: String { Self.name }

    /// All of the endpoints defined by the current type, using `@Endpoint` properties.
    ///
    /// The key of an element is the name of the endpoint, the value is the URL.
    ///
    /// If an invalid URL value is found when getting the endpoint values, a debug assertion is fired.
    /// In release mode, the property is simply skipped over.
    public var endpoints: [String: URL] {
        return Mirror(reflecting: self).children.reduce(into: [:]) { endpoints, child in
            guard let name = child.label?.drop(while: { $0 == "_" || $0 == "$" }) else { return }
            guard let endpoint = child.value as? Endpoint else { return }
            guard let url = URL(string: endpoint.wrappedValue) else {
                assertionFailure("""
                Defined @Endpoint propety in OAuth service '\(self.name)' with an invalid URL value.
                """)
                return
            }

            endpoints[String(name)] = url
        }
    }

    /// Get the endpoint URL for a given endpoint name.
    ///
    /// The name of the endpoint is the name given the an `@Endpoint` property.
    ///
    /// - Parameter endpoint: The name of the endpoint to ge the URL for.
    /// - Returns: The values assigned to the
    public subscript(endpoint: String) -> URL? {
        return self.endpoints[endpoint]
    }
}


// MARK: - Endpoint

/// An endpoint that can be called to get data to create a `FederatedCreatable` type.
///
/// The name of the endpoint will be the name of the property that is defined. If you define an endpoint property like this:
///
///     @Endpoint var user = "https://my.a.pi/session/user
///
/// Then the name of the endpoint will be `user`.
@propertyWrapper
public struct Endpoint: Codable {

    /// The underlying value of the endpoint. This will be the enpoint's URL, stored as a `String`.
    public let wrappedValue: String


    /// Allows you to access the `Endpoint` property wrapper, using `$<property-name>` syntax.
    public var projectedValue: Endpoint { self }

    /// The URL string, converted to a Foundation `URL`.
    public var url: URL? { URL(string: self.wrappedValue) }

    /// The URL string, converted to a Vapor `URI`.
    public var uri: URI { URI(string: self.wrappedValue) }


    /// Allows you to initialize an `Endpoint` property using standard assignment syntax:
    ///
    ///     @Endpoint var user = "https://my.api.io/session/user"
    public init(wrappedValue: String) {
        assert(URL(string: wrappedValue) != nil, "@Endpoint string value must be a valid URL")
        self.wrappedValue = wrappedValue
    }
}


// MARK: - Internal

final class Box<T> {
    var value: T
    init(_ value: T) { self.value = value }
}
