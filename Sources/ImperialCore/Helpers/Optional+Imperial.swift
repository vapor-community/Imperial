extension Optional {
    
    /// Gets the value contained in an optional.
    ///
    /// - Parameter error: The error to throw if the optional is `nil`.
    /// - Returns: The value contained in the optional.
    /// - Throws: The error passed in if the optional is `nil`.
    public func value(or error: Error) throws -> Wrapped {
        switch self {
        case let .some(value): return value
        case .none: throw error
        }
    }
}
