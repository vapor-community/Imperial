import Foundation

extension Array where Element == URLQueryItem {
    /// Finds first element named `scope` and returns its optional value as array of strings.
    /// - Parameters:
    ///  - separator: String to divide the optional query item value into an array.
    public func scope(separatedBy separator: String = " ") -> [String] {
        self.first(where: { $0.name == "scope" })?
            .value?
            .components(separatedBy: separator) ?? []
    }
}
