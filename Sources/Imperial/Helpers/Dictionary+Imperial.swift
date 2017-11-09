extension Dictionary where Key == String, Value == String {
    func merge(with separator: String) -> String {
        return self.reduce(into: "") { $0 += [$1.key, separator, $1.value].joined(separator: " ") }
    }
}
