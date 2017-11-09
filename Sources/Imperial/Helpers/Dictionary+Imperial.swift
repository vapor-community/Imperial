extension Dictionary where Key == String, Value == String {
    func merge(with seperator: String) -> String {
        return self.map({ "\($0)\(seperator)\($1)" }).joined(separator: " ")
    }
}
