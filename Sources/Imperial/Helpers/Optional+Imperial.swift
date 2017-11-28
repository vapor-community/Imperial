extension Optional {
    public func value(or error: Error)throws -> Wrapped {
        switch self {
        case let .some(value): return value
        case .none: throw error
        }
    }
}

infix operator ??

public func ??<T>(lhs: T?, rhs: Error)throws -> T {
    return try lhs.value(or: rhs)
}
