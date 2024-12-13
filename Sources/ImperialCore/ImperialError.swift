/// Represents various errors that can occur when attempting to unwrap an optional value.
public struct ImperialError: Error, Sendable, Equatable {
    public struct ErrorType: Sendable, Hashable, CustomStringConvertible, Equatable {
        enum Base: String, Sendable, Equatable {
            case missingEnvVar
        }

        let base: Base

        private init(_ base: Base) {
            self.base = base
        }

        public static let missingEnvVar = Self(.missingEnvVar)

        public var description: String {
            base.rawValue
        }
    }

    private struct Backing: Sendable, Equatable {
        fileprivate let errorType: ErrorType
        fileprivate let variable: String?

        init(errorType: ErrorType, variable: String? = nil) {
            self.errorType = errorType
            self.variable = variable
        }

        static func == (lhs: ImperialError.Backing, rhs: ImperialError.Backing) -> Bool {
            lhs.errorType == rhs.errorType
        }
    }

    private var backing: Backing

    public var errorType: ErrorType { backing.errorType }
    public var variable: String? { backing.variable }

    private init(backing: Backing) {
        self.backing = backing
    }

    /// Thrown when no environment varibale is found with a given name.
    public static func missingEnvVar(_ variable: String) -> Self {
        .init(backing: .init(errorType: .missingEnvVar, variable: variable))
    }

    public static func == (lhs: ImperialError, rhs: ImperialError) -> Bool {
        lhs.backing == rhs.backing
    }
}

extension ImperialError: CustomStringConvertible {
    /// A human readable version of the error thrown.
    public var description: String {
        var result = #"ImperialError(errorType: \#(self.errorType)"#

        if let variable {
            result.append(", missing enviroment variable: \(variable)")
        }

        result.append(")")

        return result
    }
}
