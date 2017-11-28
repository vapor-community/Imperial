extension Dictionary where Key == String, Value == String {
    public func merge(with separator: String) -> String {
        return self.reduce(into: [String]()) {
                   $0.append([$1.key, separator, $1.value].joined())
               }.joined(separator: " ")
    }
    
    public func mergeValues(with separator: String) -> String {
        return self.reduce(into: [String]()) { $0.append($1.value) }.joined(separator: separator)
    }
}
