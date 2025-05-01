import Foundation

extension Array where Element == URLQueryItem {
    /// Extract the value for the first query item named `scope`
    /// - Returns: Optional string value if query item exists and has a value
    public var scope: String? {
        self.first(where: { $0.name == "scope" })?.value
    }
    
    /// Merges supplied scope values with any existing ones
    /// - Parameters:
    ///   - required: Array of strings to either add or combine with existing query item value for scope.
    ///   - separator: String used to split and join query item value.
    package func withScopes(_ required: [String], separator: String) -> [Element] {
        var items = self
        var scopes = Set(required)
        if let (index, element) = items.enumerated().first(where: { $0.element.name == "scope" }),
           let value = element.value {
            scopes = scopes.union(Set(value.components(separatedBy: separator)))
            items.remove(at: index)
        }
        return items + [.init(scope: scopes.joined(separator: separator))]
    }
}
