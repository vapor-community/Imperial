/// Represents an error that occurs during a service action.
public struct ServiceError: Error, Sendable, Equatable {
    public struct ErrorType: Sendable, Hashable, CustomStringConvertible, Equatable {
        enum Base: String, Sendable, Equatable {
            case noServiceFound
            case noServiceEndpoint
        }

        let base: Base

        private init(_ base: Base) {
            self.base = base
        }

        public static let noServiceFound = Self(.noServiceFound)
        public static let noServiceEndpoint = Self(.noServiceEndpoint)

        public var description: String {
            base.rawValue
        }
    }

    private struct Backing: Sendable, Equatable {
        fileprivate let errorType: ErrorType
        fileprivate let name: String?
        fileprivate let endpoint: String?

        init(
            errorType: ErrorType,
            name: String? = nil,
            endpoint: String? = nil
        ) {
            self.errorType = errorType
            self.name = name
            self.endpoint = endpoint
        }

        static func == (lhs: ServiceError.Backing, rhs: ServiceError.Backing) -> Bool {
            lhs.errorType == rhs.errorType
        }
    }

    private var backing: Backing

    public var errorType: ErrorType { backing.errorType }
    public var name: String? { backing.name }
    public var endpoint: String? { backing.endpoint }

    private init(backing: Backing) {
        self.backing = backing
    }

    /// Thrown when no service is registered with a given name.
    public static func noServiceFound(_ name: String) -> Self {
        .init(backing: .init(errorType: .noServiceFound, name: name))
    }

    /// Thrown when a `FederatedCreatable` type has a `serviceKey` that does not match any available endpoints in the service.
    public static func noServiceEndpoint(_ endpoint: String) -> Self {
        .init(backing: .init(errorType: .noServiceEndpoint, endpoint: endpoint))
    }

    public static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        lhs.backing == rhs.backing
    }
}

extension ServiceError: CustomStringConvertible {
    public var description: String {
        var result = #"ServiceError(errorType: \#(self.errorType)"#

        if let name {
            result.append(", no service was found with the name: \(name)")
        }

        if let endpoint {
            result.append(", service does not have available endpoint for key: \(endpoint)")
        }

        result.append(")")
        
        return result
    }
}
