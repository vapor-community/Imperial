extension Optional {
    func value(or error: Error)throws -> Wrapped {
        switch self {
        case let .some(value): return value
        case .none: throw error
        }
    }
}
